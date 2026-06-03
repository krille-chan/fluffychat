// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum AppSwitcherPrivacyMode {
  off,
  appLock,
  always;

  static AppSwitcherPrivacyMode fromSetting(String setting) {
    for (final mode in AppSwitcherPrivacyMode.values) {
      if (mode.name == setting) {
        return mode;
      }
    }
    return AppSwitcherPrivacyMode.always;
  }
}

extension AppSwitcherPrivacySetting on AppSettings<String> {
  AppSwitcherPrivacyMode get appSwitcherPrivacyMode =>
      AppSwitcherPrivacyMode.fromSetting(value);

  Future<void> setAppSwitcherPrivacyMode(AppSwitcherPrivacyMode mode) =>
      setItem(mode.name);
}

class AppSwitcherPrivacy {
  static const _channelName = 'chat.fluffy/app_switcher_privacy';

  @visibleForTesting
  static const channel = MethodChannel(_channelName);

  @visibleForTesting
  static bool? debugIsAndroid;

  @visibleForTesting
  static bool? debugIsMobile;

  static bool get isAndroid => debugIsAndroid ?? PlatformInfos.isAndroid;

  static bool get isMobile => debugIsMobile ?? PlatformInfos.isMobile;

  static Future<void> setState({
    required bool enabled,
    required bool foreground,
  }) async {
    if (!isAndroid) return;

    await channel.invokeMethod<void>('setState', {
      'enabled': enabled,
      'foreground': foreground,
    });
  }
}
