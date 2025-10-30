import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

import 'package:fluffychat/config/app_config.dart';

class ClickPlayer {
  late AudioPlayer _player;

  ClickPlayer() {
    _player = AudioPlayer();
    _player.setPlayerMode(PlayerMode.lowLatency);
    _player.setVolume(min(0.5, AppConfig.volume));
  }

  Future<void> play() async {
    await _player.stop();
    _player.play(AssetSource('sounds/click.mp3'));
  }

  void dispose() {
    _player.dispose();
  }
}
