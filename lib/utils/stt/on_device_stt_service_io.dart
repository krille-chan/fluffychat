// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';
import 'package:whisper_ggml/whisper_ggml.dart';

import 'stt_service.dart';

/// Native implementation of on-device transcription backed by `whisper_ggml`
/// (whisper.cpp). This file is only compiled on native platforms via the
/// conditional import in `on_device_stt_service.dart`.
SttService createOnDeviceSttServiceImpl() => WhisperGgmlSttService();

class WhisperGgmlSttService implements SttService {
  WhisperGgmlSttService();

  final WhisperController _controller = WhisperController();

  /// Name of the model currently resident ("parked") in native memory, or null
  /// when none is resident. Only one native transcription runs at a time (see
  /// [_nativeQueue]), so this stays consistent.
  String? _parkedModelName;
  bool _redownloadAttempted = false;
  SttDownloadProgressListener? _downloadListener;
  SttModelLoadListener? _modelLoadListener;

  /// In-flight downloads per model, so a second request for the same model
  /// awaits the first instead of racing on the same file. Downloads of
  /// *different* models run in parallel (they write different files).
  final Map<String, Future<void>> _activeDownloads = {};

  /// Serializes native operations (transcription / warm-up): whisper_ggml is
  /// not safe to call concurrently. Model downloads are NOT serialized (see
  /// [_activeDownloads]) so several models can download at once.
  Future<void>? _nativeQueue;

  Future<T> _nativeExclusive<T>(Future<T> Function() task) {
    final previous = _nativeQueue ?? Future<void>.value();
    final result = previous.then((_) => task());
    _nativeQueue = result.then((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  /// Resolves the exposed models (tiny/base/small) by name, defaulting to base.
  /// Uses a name→model map (not firstWhere) to resolve cleanly without a
  /// linear scan and avoid analyzer suggestions.
  static final Map<String, WhisperModel> _modelsByName = {
    for (final m in [WhisperModel.tiny, WhisperModel.base, WhisperModel.small])
      m.modelName: m,
  };

  WhisperModel _resolveModel([String? override]) {
    final name = (override?.isNotEmpty ?? false)
        ? override!
        : AppSettings.sttModel.value;
    return _modelsByName[name] ?? WhisperModel.base;
  }

  int _minModelBytes(WhisperModel model) {
    switch (model) {
      case WhisperModel.tiny:
      case WhisperModel.tinyEn:
        return 60 * 1024 * 1024;
      case WhisperModel.base:
      case WhisperModel.baseEn:
        return 130 * 1024 * 1024;
      case WhisperModel.small:
      case WhisperModel.smallEn:
      case WhisperModel.smallEnTdrz:
        return 400 * 1024 * 1024;
      case WhisperModel.medium:
      case WhisperModel.mediumEn:
        return 1400000000;
      case WhisperModel.large:
        return 2800000000;
    }
  }

  Future<String> _modelPath(WhisperModel model) => _controller.getPath(model);

  Future<bool> _isFileReady(WhisperModel model) async {
    final file = File(await _modelPath(model));
    return file.existsSync() && file.lengthSync() >= _minModelBytes(model);
  }

  @override
  bool get isAvailable => true;

  @override
  void setDownloadProgressListener(SttDownloadProgressListener? listener) {
    _downloadListener = listener;
  }

  @override
  void setModelLoadListener(SttModelLoadListener? listener) {
    _modelLoadListener = listener;
  }

  @override
  Future<bool> isModelDownloaded(String model) async {
    final resolved = _resolveModel(model);
    return _isFileReady(resolved);
  }

  @override
  Future<int?> modelSizeBytes(String model) async {
    final file = File(await _modelPath(_resolveModel(model)));
    if (!file.existsSync()) return null;
    return file.lengthSync();
  }

  @override
  Future<void> deleteModel(String model) async {
    // Instant, lock-free file deletion (deleting a different model never
    // conflicts with a running download or transcription).
    final resolved = _resolveModel(model);
    final file = File(await _modelPath(resolved));
    if (!file.existsSync()) return;
    try {
      await file.delete();
      Logs().v('STT: deleted model ${resolved.modelName}');
    } catch (e) {
      Logs().v('STT: could not delete model ${resolved.modelName}', e);
    }
  }

  @override
  Future<void> ensureReady({String? model}) => _ensureReady(model);

  Future<void> _ensureReady(String? modelOverride) async {
    final model = _resolveModel(modelOverride);
    if (await _isFileReady(model)) return;
    // Reuse an in-flight download of the same model if there is one.
    final existing = _activeDownloads[model.modelName];
    if (existing != null) {
      await existing;
      return;
    }
    final completer = Completer<void>();
    _activeDownloads[model.modelName] = completer.future;
    try {
      await _downloadModel(model);
      completer.complete();
    } catch (e, s) {
      completer.completeError(e, s);
      rethrow;
    } finally {
      _activeDownloads.remove(model.modelName);
    }
  }

  Future<void> _downloadModel(WhisperModel model) async {
    final path = await _modelPath(model);
    await File(path).parent.create(recursive: true);
    final client = http.Client();
    var received = 0;
    var total = -1;
    final sw = Stopwatch()..start();
    _downloadListener?.call(model.modelName, true, 0, received, total);
    try {
      final request = http.Request('GET', model.modelUri);
      final response = await client.send(request);
      if (response.statusCode != 200) {
        throw TranscriptionException(
          'Model download failed (HTTP ${response.statusCode})',
        );
      }
      total = response.contentLength ?? -1;
      final sink = File(path).openWrite();
      try {
        final stream = response.stream.timeout(
          const Duration(seconds: 30),
          onTimeout: (sink) =>
              sink.addError(TimeoutException('Model download stalled')),
        );
        await for (final chunk in stream) {
          received += chunk.length;
          sink.add(chunk);
          final fraction = total > 0 ? (received / total).clamp(0.0, 1.0) : 0.0;
          _downloadListener?.call(
            model.modelName,
            true,
            fraction,
            received,
            total,
          );
        }
      } finally {
        await sink.flush();
        await sink.close();
      }
      final mbps = sw.elapsed.inMilliseconds == 0
          ? 0.0
          : (received / 1048576) / (sw.elapsed.inMilliseconds / 1000);
      Logs().i(
        'STT: downloaded ${model.modelName} '
        '${(received / 1048576).toStringAsFixed(1)} MB '
        'in ${sw.elapsed} (${mbps.toStringAsFixed(1)} MB/s)',
      );
    } finally {
      client.close();
      _downloadListener?.call(model.modelName, false, 1, received, total);
    }
  }

  /// Wraps an inference-progress callback with model-load tracking: while the
  /// model isn't resident yet the native call first loads it (no byte progress),
  /// so we report the load phase via the load listener until the first inference
  /// progress arrives.
  void Function(int) _trackLoad(
    WhisperModel model,
    void Function(int)? onProgress,
  ) {
    final alreadyParked = _parkedModelName == model.modelName;
    if (!alreadyParked) _modelLoadListener?.call(true);
    var firstProgress = true;
    return (percent) {
      if (firstProgress) {
        firstProgress = false;
        if (!alreadyParked) _modelLoadListener?.call(false);
      }
      onProgress?.call(percent);
    };
  }

  /// Runs a whisper transcription and parks the model afterwards
  /// (keepModelLoaded: true), so consecutive transcriptions with the same model
  /// don't reload it.
  Future<String?> _runWhisper(
    File file, {
    required WhisperModel model,
    void Function(int progress)? onProgress,
  }) async {
    final result = await _controller.transcribe(
      model: model,
      audioPath: file.path,
      lang: 'auto',
      suppressNonSpeechTokens: true,
      keepModelLoaded: true,
      onProgress: _trackLoad(model, onProgress),
    );
    _modelLoadListener?.call(false);
    _parkedModelName = model.modelName;
    return result?.transcription.text.trim();
  }

  @override
  Future<void> warmUp({String? model}) {
    return _nativeExclusive(() async {
      final resolved = _resolveModel(model);
      if (_parkedModelName == resolved.modelName) return; // already resident
      await _ensureReady(model);
      final warmup = await _writeSilentWarmupWav();
      final sw = Stopwatch()..start();
      try {
        await _runWhisper(warmup, model: resolved);
        Logs().i('STT: warm-up of ${resolved.modelName} took ${sw.elapsed}');
      } catch (e) {
        Logs().v('STT: model warm-up failed (non-fatal)', e);
      } finally {
        try {
          if (await warmup.exists()) await warmup.delete();
        } catch (_) {}
      }
    });
  }

  @override
  Future<String> transcribe(
    File file, {
    void Function(int progress)? onProgress,
    String? model,
  }) {
    return _nativeExclusive(() async {
      await _ensureReady(model);
      final resolved = _resolveModel(model);
      Logs().v(
        'STT: transcribing ${file.path} with model ${resolved.modelName}',
      );
      final sw = Stopwatch()..start();
      var text = await _runWhisper(
        file,
        model: resolved,
        onProgress: onProgress,
      );
      Logs().i('STT: inference took ${sw.elapsed}');
      if (text == null && !_redownloadAttempted) {
        Logs().w(
          'STT: transcription returned no result; re-downloading the model once in case it is corrupt',
        );
        _redownloadAttempted = true;
        _parkedModelName = null;
        await deleteModel(resolved.modelName);
        await _ensureReady(model);
        text = await _runWhisper(file, model: resolved, onProgress: onProgress);
      }
      if (text == null) {
        throw TranscriptionException('On-device transcription failed');
      }
      return text;
    });
  }

  /// Writes a short silent 16 kHz mono WAV used to warm up a model.
  Future<File> _writeSilentWarmupWav() async {
    const sampleRate = 16000;
    const seconds = 2;
    const dataSize = sampleRate * seconds * 2; // 16-bit mono
    List<int> le16(int v) => [v & 0xFF, (v >> 8) & 0xFF];
    List<int> le32(int v) => [
      v & 0xFF,
      (v >> 8) & 0xFF,
      (v >> 16) & 0xFF,
      (v >> 24) & 0xFF,
    ];
    final bytes = BytesBuilder()
      ..add('RIFF'.codeUnits)
      ..add(le32(36 + dataSize))
      ..add('WAVE'.codeUnits)
      ..add('fmt '.codeUnits)
      ..add(le32(16))
      ..add(le16(1)) // PCM
      ..add(le16(1)) // mono
      ..add(le32(sampleRate))
      ..add(le32(sampleRate * 2))
      ..add(le16(2)) // block align
      ..add(le16(16)) // bits per sample
      ..add('data'.codeUnits)
      ..add(le32(dataSize))
      ..add(Uint8List(dataSize)); // zeros = silence
    final file = File('${Directory.systemTemp.path}/fluffychat_stt_warmup.wav');
    await file.writeAsBytes(bytes.takeBytes(), flush: true);
    return file;
  }
}
