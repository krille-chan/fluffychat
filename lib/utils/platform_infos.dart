import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';

import '../config/app_config.dart';

abstract class PlatformInfos {
  static bool get isWeb => kIsWeb;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  // #Pangea
  // static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isWindows => getOperatingSystem() == 'Windows';
  // Pangea#
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isCupertinoStyle => isIOS || isMacOS;

  static bool get isMobile => isAndroid || isIOS;

  /// For desktops which don't support ChachedNetworkImage yet
  static bool get isBetaDesktop => isWindows || isLinux;

  static bool get isDesktop => isLinux || isWindows || isMacOS;

  static bool get usesTouchscreen => !isMobile;

  /// Web could also record in theory but currently only wav which is too large
  /// #Pangea
  // static bool get platformCanRecord => (isMobile || isMacOS);
  static bool get platformCanRecord => (isMobile || isMacOS || isWeb);
  // Pangea#

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
    final version = await PlatformInfos.getVersion();
    showAboutDialog(
      context: context,
      // #Pangea
      useRootNavigator: false,
      // Pangea#
      children: [
        Text('Version: $version'),
        TextButton.icon(
          onPressed: () => launchUrlString(AppConfig.sourceCodeUrl),
          icon: const Icon(Icons.source_outlined),
          label: Text(L10n.of(context).sourceCode),
        ),
        Builder(
          builder: (innerContext) {
            return TextButton.icon(
              onPressed: () {
                context.go('/logs');
                Navigator.of(innerContext).pop();
              },
              icon: const Icon(Icons.list_outlined),
              label: const Text('Logs'),
            );
          },
        ),
        Builder(
          builder: (innerContext) {
            return TextButton.icon(
              onPressed: () {
                context.go('/configs');
                Navigator.of(innerContext).pop();
              },
              icon: const Icon(Icons.settings_applications_outlined),
              label: const Text('Advanced Configs'),
            );
          },
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

  // #Pangea
  static String? getOperatingSystem() {
    if (!kIsWeb) return null;
    final String platform = html.window.navigator.platform?.toLowerCase() ?? '';

    if (platform.contains('mac')) {
      return 'macOS';
    } else if (platform.contains('win')) {
      return 'Windows';
    } else if (platform.contains('linux')) {
      return 'Linux';
    }
    return null;
  }
// Pangea#
}
