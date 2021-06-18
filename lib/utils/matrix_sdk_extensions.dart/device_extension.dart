import 'package:matrix/matrix.dart';
import 'package:flutter/material.dart';

extension DeviceExtension on Device {
  String get displayname =>
      (displayName?.isNotEmpty ?? false) ? displayName : 'Unknown device';

  IconData get icon => displayname.toLowerCase().contains('android')
      ? Icons.phone_android_outlined
      : displayname.toLowerCase().contains('ios')
          ? Icons.phone_iphone_outlined
          : displayname.toLowerCase().contains('web')
              ? Icons.web_outlined
              : displayname.toLowerCase().contains('desktop')
                  ? Icons.desktop_mac_outlined
                  : Icons.device_unknown_outlined;
}

extension DeviceKeysExtension on DeviceKeys {
  String get displayname => (deviceDisplayName?.isNotEmpty ?? false)
      ? deviceDisplayName
      : 'Unknown device';

  IconData get icon => displayname.toLowerCase().contains('android')
      ? Icons.phone_android_outlined
      : displayname.toLowerCase().contains('ios')
          ? Icons.phone_iphone_outlined
          : displayname.toLowerCase().contains('web')
              ? Icons.web_outlined
              : displayname.toLowerCase().contains('desktop')
                  ? Icons.desktop_mac_outlined
                  : Icons.device_unknown_outlined;
}
