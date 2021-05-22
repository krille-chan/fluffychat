import 'dart:io';

import 'package:fluffychat/widgets/sentry_switch_list_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../config/app_config.dart';

abstract class PlatformInfos {
  static bool get isWeb => kIsWeb;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isCupertinoStyle => isIOS || isMacOS;

  static bool get isMobile => isAndroid || isIOS;

  /// For desktops which don't support ChachedNetworkImage yet
  static bool get isBetaDesktop => isWindows || isLinux;

  static bool get isDesktop => isLinux || isWindows || isMacOS;

  static bool get usesTouchscreen => !isMobile;

  static String get clientName =>
      '${AppConfig.applicationName} ${isWeb ? 'web' : Platform.operatingSystem}';

  static Future<String> getVersion() async {
    var version = kIsWeb ? 'Web' : 'Unknown';
    try {
      version = (await PackageInfo.fromPlatform()).version;
    } catch (_) {}
    return version;
  }

  static void showDialog(BuildContext context) async {
    final version = await PlatformInfos.getVersion();
    showAboutDialog(
      context: context,
      useRootNavigator: false,
      children: [
        Text('Version: $version'),
        OutlinedButton(
          onPressed: () => launch(AppConfig.sourceCodeUrl),
          child: Text(L10n.of(context).sourceCode),
        ),
        OutlinedButton(
          onPressed: () => launch(AppConfig.emojiFontUrl),
          child: Text(AppConfig.emojiFontName),
        ),
        SentrySwitchListTile(label: L10n.of(context).sendBugReports),
      ],
      applicationIcon: Image.asset('assets/logo.png', width: 64, height: 64),
      applicationName: AppConfig.applicationName,
    );
  }
}
