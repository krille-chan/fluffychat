import 'dart:async';

import 'package:just_audio/just_audio.dart';

enum CallToneType { incoming, outgoing }

class UserMediaManager {
  factory UserMediaManager() => _instance;

  UserMediaManager._internal();

  static final UserMediaManager _instance = UserMediaManager._internal();

  final AudioPlayer _player = AudioPlayer();

  CallToneType? _currentTone;

  bool _isPlaying = false;

  // ─────────────────────────────
  // Incoming ringtone
  // ─────────────────────────────
  Future<void> startIncomingRingtone() async {
    await _startTone(CallToneType.incoming, 'assets/sounds/phone.ogg');
  }

  // ─────────────────────────────
  // Outgoing ringback
  // ─────────────────────────────
  Future<void> startOutgoingRingtone() async {
    await _startTone(CallToneType.outgoing, 'assets/sounds/call.ogg');
  }

  // ─────────────────────────────
  // Core play logic
  // ─────────────────────────────
  Future<void> _startTone(CallToneType type, String asset) async {
    try {
      if (_isPlaying && _currentTone == type) return;

      await stopRingingTone();

      _currentTone = type;

      await _player.setAsset(asset);
      await _player.setLoopMode(LoopMode.one);

      _isPlaying = true;
      unawaited(_player.play());
    } catch (_) {}
  }

  // ─────────────────────────────
  // Stop all sounds
  // ─────────────────────────────
  Future<void> stopRingingTone() async {
    try {
      _isPlaying = false;
      _currentTone = null;
      await _player.stop();
    } catch (_) {}
  }

  // ─────────────────────────────
  // Dispose
  // ─────────────────────────────
  Future<void> dispose() async {
    try {
      await _player.dispose();
    } catch (_) {}
  }
}
