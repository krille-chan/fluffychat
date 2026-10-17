// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

abstract class UpdateNotifier {
  static const String versionStoreKey = 'last_known_version';
  static const String dismissedUpdateStoreKey = 'dismissed_update_version';
  static const String _windowsInstallerAssetName =
      'fluffychat-windows-x64-setup.exe';

  /// Checks GitHub for a newer release with a Windows installer and
  /// displays a banner with a download link. Only for Windows, as all other
  /// platforms get updated by their store or package manager.
  static Future<void> showUpdateAvailableBanner(BuildContext context) async {
    if (!PlatformInfos.isWindows || !AppSettings.checkForUpdates.value) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = L10n.of(context);

    // Check for updates at most once per day
    final today = DateTime.now().toIso8601String().split('T').first;
    if (AppSettings.lastUpdateCheckDate.value == today) return;
    await AppSettings.lastUpdateCheckDate.setItem(today);

    final String latestVersion;
    final String downloadUrl;
    try {
      final response = await http.get(
        Uri.parse(AppConfig.latestReleaseApiUrl),
        headers: {'Accept': 'application/vnd.github+json'},
      );
      if (response.statusCode != 200) return;
      final release = jsonDecode(response.body) as Map<String, Object?>;
      latestVersion = (release['tag_name'] as String).replaceFirst(
        RegExp('^v'),
        '',
      );
      final installer = (release['assets'] as List)
          .cast<Map<String, Object?>>()
          .firstWhere((asset) => asset['name'] == _windowsInstallerAssetName);
      downloadUrl = installer['browser_download_url'] as String;
    } catch (e, s) {
      Logs().w('Unable to check for updates', e, s);
      return;
    }

    final currentVersion = await PlatformInfos.getVersion();
    if (latestVersion == currentVersion) return;

    final store = await SharedPreferences.getInstance();
    if (store.getString(dismissedUpdateStoreKey) == latestVersion) return;

    scaffoldMessenger.showMaterialBanner(
      MaterialBanner(
        leading: const Icon(Icons.system_update_outlined),
        content: Text(l10n.updateAvailable(latestVersion)),
        actions: [
          TextButton(
            onPressed: () {
              store.setString(dismissedUpdateStoreKey, latestVersion);
              scaffoldMessenger.hideCurrentMaterialBanner();
            },
            child: Text(l10n.close),
          ),
          TextButton(
            onPressed: () {
              launchUrlString(downloadUrl);
              scaffoldMessenger.hideCurrentMaterialBanner();
            },
            child: Text(l10n.download),
          ),
        ],
      ),
    );
  }

  static Future<void> showUpdateDialog(BuildContext context) async {
    final l10n = L10n.of(context);
    final currentVersion = await PlatformInfos.getVersion();
    final store = await SharedPreferences.getInstance();
    final storedVersion = store.getString(versionStoreKey);
    if (!context.mounted) return;

    if (currentVersion != storedVersion) {
      if (storedVersion != null) {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => AlertDialog(
            title: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 256),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
                child: Image.asset('assets/logo/mini/banner.png'),
              ),
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 256),
              child: Column(
                mainAxisSize: .min,
                spacing: 16,
                children: [
                  Text(
                    l10n.updateInstalled(currentVersion),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    l10n.possibleByYou,
                    textAlign: .center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            actions: [
              AdaptiveDialogAction(
                bigButtons: true,
                targetPlatform: TargetPlatform.android,
                onPressed: () => launchUrlString(AppConfig.helpUrl),
                child: Row(
                  mainAxisSize: .min,
                  spacing: 4,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    Text(
                      l10n.support,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
              AdaptiveDialogAction(
                bigButtons: true,
                targetPlatform: TargetPlatform.android,
                onPressed: () => launchUrlString(AppConfig.changelogUrl),
                child: Text(l10n.changelog),
              ),
              AdaptiveDialogAction(
                bigButtons: true,
                targetPlatform: TargetPlatform.android,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.close),
              ),
            ],
          ),
        );
      }
      await store.setString(versionStoreKey, currentVersion);
    }
  }
}
