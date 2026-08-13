// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';

import 'on_device_stt_service.dart';
import 'stt_service.dart';
import 'transcription_cache.dart';

/// Orchestrates on-device Speech-to-Text for voice messages.
///
/// Downloads & decrypts the voice attachment, runs the transcription via the
/// on-device provider and stores the result in the [cache]. Hosted on
/// [MatrixState] and accessed through `Matrix.of(context)`.
///
/// The active model is the configured default ([AppSettings.sttModel]); the
/// provider keeps it resident (parked) so consecutive voice messages don't
/// reload it, and preloads it at app start ([preloadDefaultModel]).
class SttManager {
  SttManager(this.cache);

  final TranscriptionCache cache;

  /// Per-model download state, keyed by model name. Observed by the settings
  /// rows to show per-model progress.
  final ValueNotifier<Map<String, ModelDownloadState>> modelDownloads =
      ValueNotifier({});

  /// True while any model is downloading or the native model is loading — used
  /// to disable the "Transcribe" button and show a busy indicator.
  final ValueNotifier<bool> isBusy = ValueNotifier(false);

  final ValueNotifier<bool> _modelLoading = ValueNotifier(false);

  /// Bumped whenever the set of locally downloaded models changes (download
  /// finished or a model deleted), so UIs showing download status refresh.
  final ValueNotifier<int> modelRevision = ValueNotifier(0);

  SttService? _onDeviceService;
  bool _onDeviceCreated = false;

  SttService get _onDevice {
    if (!_onDeviceCreated) {
      final svc = createOnDeviceSttService();
      svc.setDownloadProgressListener((
        model,
        active,
        progress,
        received,
        total,
      ) {
        final map = Map<String, ModelDownloadState>.from(modelDownloads.value);
        if (active) {
          map[model] = ModelDownloadState(progress, received, total);
        } else {
          map.remove(model);
        }
        modelDownloads.value = map;
        if (!active) modelRevision.value++;
        _recomputeBusy();
      });
      svc.setModelLoadListener((loading) {
        _modelLoading.value = loading;
        _recomputeBusy();
      });
      _onDeviceService = svc;
      _onDeviceCreated = true;
    }
    return _onDeviceService!;
  }

  void _recomputeBusy() {
    isBusy.value = modelDownloads.value.isNotEmpty || _modelLoading.value;
  }

  bool get onDeviceAvailable => _onDevice.isAvailable;

  bool get isFeatureAvailable =>
      !kIsWeb && AppSettings.sttEnabled.value && onDeviceAvailable;

  static const models = <String>['tiny', 'base', 'small'];

  /// Downloads & transcribes the voice message [event] and stores the result,
  /// using the configured default model.
  Future<void> transcribeEvent(Event event) async {
    final eventId = event.eventId;
    final existing = cache[eventId];
    if (existing?.status == TranscriptionStatus.loading ||
        existing?.status == TranscriptionStatus.preparing) {
      return;
    }
    if (!isFeatureAvailable) {
      cache.put(
        eventId,
        const TranscriptionEntry(status: TranscriptionStatus.error),
      );
      return;
    }
    final activeModel = AppSettings.sttModel.value;
    final svc = _onDevice;

    try {
      cache.put(
        eventId,
        const TranscriptionEntry(status: TranscriptionStatus.loading),
      );

      final matrixFile = await event.downloadAndDecryptAttachment();
      final file = await _writeTempFile(matrixFile, event);
      try {
        await svc.ensureReady(model: activeModel);
        final text = await svc.transcribe(
          file,
          onProgress: (percent) => cache.put(
            eventId,
            TranscriptionEntry(
              status: TranscriptionStatus.loading,
              progress: percent / 100,
            ),
          ),
          model: activeModel,
        );
        cache.put(
          eventId,
          TranscriptionEntry(
            status: TranscriptionStatus.ready,
            text: text,
            model: activeModel,
          ),
        );
      } finally {
        try {
          if (await file.exists()) await file.delete();
        } catch (_) {}
      }
    } catch (e, s) {
      Logs().e('STT: transcription failed', e, s);
      cache.put(
        eventId,
        const TranscriptionEntry(status: TranscriptionStatus.error),
      );
    }
  }

  /// Starts (or joins) the download of [model]. Downloads of different models
  /// run in parallel; progress is reported via [modelDownloads].
  Future<void> downloadModel(String model) async {
    final svc = _onDevice;
    if (!svc.isAvailable) return;
    try {
      await svc.ensureReady(model: model);
    } catch (e, s) {
      Logs().v('STT: download of $model failed', e, s);
    } finally {
      modelRevision.value++;
    }
  }

  /// Makes [model] the active default and immediately downloads (if needed) and
  /// loads it, so the next transcription starts without delay. Download/load
  /// progress is shown via [modelDownloads] / [isBusy].
  Future<void> activateModel(String model) async {
    await AppSettings.sttModel.setItem(model);
    final svc = _onDevice;
    if (!svc.isAvailable) return;
    // Download + load in the background; ignore errors (user can retry).
    svc.warmUp(model: model).catchError((Object _) {});
  }

  /// Whether the given model is downloaded locally and complete.
  Future<bool> isModelDownloaded(String model) async {
    final svc = _onDevice;
    if (!svc.isAvailable) return false;
    return svc.isModelDownloaded(model);
  }

  /// Size in bytes of the given model's local file, or null if absent.
  Future<int?> modelSizeBytes(String model) async {
    final svc = _onDevice;
    if (!svc.isAvailable) return null;
    return svc.modelSizeBytes(model);
  }

  /// Deletes the given model's local file to free storage. Re-downloaded on use.
  Future<void> deleteModel(String model) async {
    final svc = _onDevice;
    if (!svc.isAvailable) return;
    await svc.deleteModel(model);
    modelRevision.value++;
  }

  /// Preloads the configured default model at app start (background) so the
  /// first transcription of a chat doesn't pay the load cost.
  Future<void> preloadDefaultModel() async {
    if (kIsWeb || !AppSettings.sttEnabled.value) return;
    final svc = _onDevice;
    if (!svc.isAvailable) return;
    try {
      await svc.warmUp();
    } catch (e, s) {
      Logs().v('STT: background default model preload failed', e, s);
    }
  }

  Future<File> _writeTempFile(MatrixFile matrixFile, Event event) async {
    final tempDir = await getTemporaryDirectory();
    final ext = _extensionFor(matrixFile);
    final path =
        '${tempDir.path}/stt_${event.eventId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}.$ext';
    final file = File(path);
    await file.writeAsBytes(matrixFile.bytes, flush: true);
    return file;
  }

  String _extensionFor(MatrixFile matrixFile) {
    final name = matrixFile.name.toLowerCase();
    final dot = name.lastIndexOf('.');
    if (dot != -1 && dot < name.length - 1) {
      final ext = name.substring(dot + 1);
      if (RegExp(r'^[a-z0-9]{2,5}$').hasMatch(ext)) return ext;
    }
    switch (matrixFile.mimeType.toLowerCase()) {
      case 'audio/ogg':
      case 'audio/opus':
        return 'ogg';
      case 'audio/mpeg':
        return 'mp3';
      case 'audio/mp4':
      case 'audio/aac':
        return 'm4a';
      case 'audio/wav':
      case 'audio/x-wav':
        return 'wav';
      case 'audio/webm':
        return 'webm';
      case 'audio/x-caf':
        return 'caf';
      case 'audio/flac':
        return 'flac';
      default:
        return 'bin';
    }
  }
}
