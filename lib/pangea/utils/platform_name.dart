// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

class MyPlatformName {
  static String get platformName {
    if (kIsWeb) {
      return 'web';
    }
    if (Platform.isAndroid) {
      return 'android';
    }

    if (Platform.isIOS) {
      return 'ios';
    }

    if (Platform.isFuchsia) {
      return 'fuchsia';
    }

    if (Platform.isLinux) {
      return 'linux';
    }
    if (Platform.isMacOS) {
      return 'macos';
    }
    if (Platform.isWindows) {
      return 'windows';
    }
    return 'unknownplatform';
  }

  static String get getPlatformWithModeName {
    String mode = 'Release';
    if (kDebugMode) {
      mode = 'Debug';
    }
    return MyPlatformName.platformName + mode;
  }
}
