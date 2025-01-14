import 'package:audioplayers/audioplayers.dart';

class ClickPlayer {
  late AudioPlayer _player;

  ClickPlayer() {
    _player = AudioPlayer();
    _player.setPlayerMode(PlayerMode.lowLatency);
    _player.setVolume(0.5);
  }

  Future<void> play() async {
    await _player.stop();
    _player.play(AssetSource('sounds/click.ogg'));
  }

  void dispose() {
    _player.dispose();
  }
}
