import 'package:flutter/foundation.dart';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class UserMediaManager {
  factory UserMediaManager() {
    return _instance;
  }

  UserMediaManager._internal();

  static final UserMediaManager _instance = UserMediaManager._internal();

  Future<void> startRingingTone() {
    if (kIsWeb) {
      throw 'Platform [web] not supported';
    }
    return FlutterRingtonePlayer.playRingtone(volume: 80);
  }

  Future<void> stopRingingTone() {
    if (kIsWeb) {
      throw 'Platform [web] not supported';
    }
    return FlutterRingtonePlayer.stop();
  }
}
