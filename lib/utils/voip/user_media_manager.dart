// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:just_audio/just_audio.dart';

class UserMediaManager {
  factory UserMediaManager() {
    return _instance;
  }

  UserMediaManager._internal();

  static final UserMediaManager _instance = UserMediaManager._internal();

  AudioPlayer? _assetsAudioPlayer;

  Future<void> startRingingTone() async {
    const path = 'assets/sounds/phone.ogg';
    final player = _assetsAudioPlayer = AudioPlayer();
    player.setAsset(path);
    player.play();

    return;
  }

  Future<void> stopRingingTone() async {
    await _assetsAudioPlayer?.stop();
    _assetsAudioPlayer = null;
    return;
  }
}
