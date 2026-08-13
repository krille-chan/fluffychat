// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

/// Observer for model-download activity, reported per model. [active] is true
/// while a download of [model] is running (with [progress] 0..1, [receivedBytes]
/// and [totalBytes], the latter -1 when unknown) and false once it ends.
typedef SttDownloadProgressListener =
    void Function(
      String model,
      bool active,
      double progress,
      int receivedBytes,
      int totalBytes,
    );

/// Observer for the native model-load phase (loading the model into memory,
/// which has no byte progress). Called with `true` while loading, `false` once
/// inference starts or the load ends.
typedef SttModelLoadListener = void Function(bool loading);

/// On-device Speech-to-Text contract. The real implementation (whisper_ggml)
/// uses `dart:ffi` and is only compiled on native platforms; a web stub reports
/// the service as unavailable (see the conditional import).
abstract class SttService {
  bool get isAvailable;

  void setDownloadProgressListener(SttDownloadProgressListener? listener);
  void setModelLoadListener(SttModelLoadListener? listener);

  /// Whether the given model is already downloaded and locally complete.
  Future<bool> isModelDownloaded(String model);

  /// Size in bytes of the given model's local file, or null if not present.
  Future<int?> modelSizeBytes(String model);

  /// Deletes the given model's local file, freeing storage. Safe to call for a
  /// model that is currently resident in memory (the resident copy is
  /// unaffected); the model is re-downloaded on next use.
  Future<void> deleteModel(String model);

  /// Ensures the model file is present (downloads it if necessary).
  Future<void> ensureReady({String? model});

  /// Loads (and parks) [model] into native memory without transcribing, so the
  /// next transcription with it starts without a load.
  Future<void> warmUp({String? model});

  /// Transcribes the given audio [file] and returns the recognised text.
  /// [onProgress], if given, receives inference progress as 0..100.
  Future<String> transcribe(
    File file, {
    void Function(int progress)? onProgress,
    String? model,
  });
}

/// Thrown when a transcription fails for any reason.
class TranscriptionException implements Exception {
  final String message;
  TranscriptionException(this.message);

  @override
  String toString() => 'TranscriptionException: $message';
}
