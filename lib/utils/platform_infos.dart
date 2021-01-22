import 'dart:io';

import 'package:fluffychat/components/sentry_switch_list_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../app_config.dart';

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

  static Future<String> getVersion() async {
    var version = kIsWeb ? 'Web' : 'Unknown';
    try {
      version = (await PackageInfo.fromPlatform()).version;
    } catch (_) {}
    return version;
  }

  static void showDialog(BuildContext context) async {
    var version = await PlatformInfos.getVersion();
    showAboutDialog(
      context: context,
      children: [
        Text('Version: $version'),
        RaisedButton(
          child: Text(L10n.of(context).privacy),
          onPressed: () => launch(AppConfig.privacyUrl),
        ),
        RaisedButton(
          child: Text(L10n.of(context).sourceCode),
          onPressed: () => launch(AppConfig.sourceCodeUrl),
        ),
        RaisedButton(
          child: Text(AppConfig.emojiFontName),
          onPressed: () => launch(AppConfig.emojiFontUrl),
        ),
        SentrySwitchListTile(label: L10n.of(context).sendBugReports),
      ],
      applicationIcon: Image.asset('assets/logo.png', width: 64, height: 64),
      applicationName: AppConfig.applicationName,
    );
  }
}
