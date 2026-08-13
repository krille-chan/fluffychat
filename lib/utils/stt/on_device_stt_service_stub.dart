// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'stt_service.dart';

/// Web fallback: on-device transcription is not available because it requires
/// native code (`dart:ffi`/whisper.cpp). This stub keeps the public surface
/// identical so the rest of the app can be compiled for the web.
SttService createOnDeviceSttServiceImpl() =>
    const _UnavailableOnDeviceSttService();

class _UnavailableOnDeviceSttService implements SttService {
  const _UnavailableOnDeviceSttService();

  @override
  bool get isAvailable => false;

  @override
  void setDownloadProgressListener(SttDownloadProgressListener? listener) {}

  @override
  void setModelLoadListener(SttModelLoadListener? listener) {}

  @override
  Future<bool> isModelDownloaded(String model) async => false;

  @override
  Future<int?> modelSizeBytes(String model) async => null;

  @override
  Future<void> deleteModel(String model) async {}

  @override
  Future<void> ensureReady({String? model}) async {}

  @override
  Future<void> warmUp({String? model}) async {}

  @override
  Future<String> transcribe(
    file, {
    void Function(int progress)? onProgress,
    String? model,
  }) async {
    throw TranscriptionException(
      'On-device transcription is not available on this platform',
    );
  }
}
