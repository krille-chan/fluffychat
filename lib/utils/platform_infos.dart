import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class PlatformInfos {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get usesTouchscreen => !isMobile;
}
