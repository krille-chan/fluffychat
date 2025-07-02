import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/l10n/l10n.dart';
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

  static bool get supportsVideoPlayer =>
      !PlatformInfos.isWindows && !PlatformInfos.isLinux;

  /// Web could also record in theory but currently only wav which is too large
  static bool get platformCanRecord => (isMobile || isMacOS);

  static String get clientName =>
      '${AppConfig.applicationName} ${isWeb ? 'web' : Platform.operatingSystem}${kReleaseMode ? '' : 'Debug'}';

  static Future<String> getVersion() async {
    var version = kIsWeb ? 'Web' : 'Unknown';
    try {
      version = (await PackageInfo.fromPlatform()).version;
    } catch (_) {}
    return version;
  }

  static void showDialog(BuildContext context) async {
    showAboutDialog(
      context: context,
      children: [
        TextButton.icon(
          onPressed: () => launchUrlString(AppConfig.sourceCodeUrl),
          icon: const Icon(Icons.source_outlined),
          label: Text(L10n.of(context).sourceCode),
        ),
      ],
      applicationIcon: Image.asset(
        'assets/logo.png',
        width: 64,
        height: 64,
        filterQuality: FilterQuality.medium,
      ),
      applicationName: AppConfig.applicationName,
    );
  }
}
