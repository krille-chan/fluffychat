import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

IconData _getIconFromName(String displayname) {
  final name = displayname.toLowerCase();
  if ({'android'}.any((s) => name.contains(s))) {
    return Icons.phone_android_outlined;
  }
  if ({'ios', 'ipad', 'iphone', 'ipod'}.any((s) => name.contains(s))) {
    return Icons.phone_iphone_outlined;
  }
  if ({
    'web',
    'http://',
    'https://',
    'firefox',
    'chrome',
    '/_matrix',
    'safari',
    'opera',
  }.any((s) => name.contains(s))) {
    return Icons.web_outlined;
  }
  if ({'desktop', 'windows', 'macos', 'linux', 'ubuntu'}
      .any((s) => name.contains(s))) {
    return Icons.desktop_mac_outlined;
  }
  return Icons.device_unknown_outlined;
}

extension DeviceExtension on Device {
  String get displayname =>
      (displayName?.isNotEmpty ?? false) ? displayName! : 'Unknown device';

  IconData get icon => _getIconFromName(displayname);
}

extension DeviceKeysExtension on DeviceKeys {
  String get displayname => (deviceDisplayName?.isNotEmpty ?? false)
      ? deviceDisplayName!
      : 'Unknown device';

  IconData get icon => _getIconFromName(displayname);
}
