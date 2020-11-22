import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class PlatformInfos {
  static bool get isWeb => kIsWeb;

  static bool get isCupertinoStyle =>
      !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// For desktops which don't support ChachedNetworkImage yet
  static bool get isBetaDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux);

  static bool get isDesktop =>
      !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

  static bool get usesTouchscreen => !isMobile;
}
