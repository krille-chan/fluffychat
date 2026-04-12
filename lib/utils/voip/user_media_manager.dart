import 'dart:async';

import 'package:just_audio/just_audio.dart';

class UserMediaManager {
  factory UserMediaManager() {
    return _instance;
  }

  UserMediaManager._internal();

  static final UserMediaManager _instance = UserMediaManager._internal();

  AudioPlayer? _assetsAudioPlayer;

  Future<void> startRingingTone() async {
    await stopRingingTone();
    const path = 'assets/sounds/phone.ogg';
    final player = AudioPlayer();
    _assetsAudioPlayer = player;
    try {
      await player.setAsset(path);
      await player.setLoopMode(LoopMode.one);
      unawaited(player.play());
    } catch (_) {
      // Ringtone failures are non-fatal; ignore silently
    }
  }

  Future<void> stopRingingTone() async {
    final player = _assetsAudioPlayer;
    _assetsAudioPlayer = null;
    try {
      await player?.stop();
      await player?.dispose();
    } catch (_) {}
  }
}
