// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/foundation.dart';

/// Lifecycle of a single transcription attempt.
enum TranscriptionStatus { idle, preparing, loading, ready, error }

/// Immutable snapshot of a transcription for one event.
class TranscriptionEntry {
  final TranscriptionStatus status;
  final String? text;
  final double? progress;

  /// The on-device model that produced this transcription (e.g. `base`), for
  /// display.
  final String? model;

  const TranscriptionEntry({
    this.status = TranscriptionStatus.idle,
    this.text,
    this.progress,
    this.model,
  });

  bool get isFinished =>
      status == TranscriptionStatus.ready ||
      status == TranscriptionStatus.error;
}

/// In-memory, session-spanning cache of transcriptions keyed by Matrix event id.
///
/// Deliberately not persisted: transcription is cheap and local, so (like other
/// clients) results are discarded when the app is closed.
class TranscriptionCache
    extends ValueNotifier<Map<String, TranscriptionEntry>> {
  TranscriptionCache() : super(const {});

  TranscriptionEntry? operator [](String eventId) => value[eventId];

  void put(String eventId, TranscriptionEntry entry) {
    value = {...value, eventId: entry};
  }

  void remove(String eventId) {
    if (!value.containsKey(eventId)) return;
    value = Map<String, TranscriptionEntry>.from(value)..remove(eventId);
  }
}

/// Snapshot of an in-progress model download, used for a global progress
/// indicator (independent of which event/operation triggered the download).
class ModelDownloadState {
  final double progress; // 0..1, or 0 when the total size is unknown
  final int receivedBytes;
  final int totalBytes; // -1 when unknown

  const ModelDownloadState(this.progress, this.receivedBytes, this.totalBytes);

  bool get hasTotal => totalBytes > 0;
}
