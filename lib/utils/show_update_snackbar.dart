// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

abstract class UpdateNotifier {
  static const String versionStoreKey = 'last_known_version';

  static Future<void> showUpdateDialog(BuildContext context) async {
    final l10n = L10n.of(context);
    final currentVersion = await PlatformInfos.getVersion();
    final store = await SharedPreferences.getInstance();
    final storedVersion = store.getString(versionStoreKey);
    if (!context.mounted) return;

    if (currentVersion != storedVersion) {
      if (storedVersion != null) {
        showAdaptiveDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: Text(
              l10n.updateInstalled(currentVersion),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(l10n.possibleByYou),
            actions: [
              AdaptiveDialogAction(
                bigButtons: true,
                autofocus: true,
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
                onPressed: () => launchUrlString(AppConfig.changelogUrl),
                child: Text(l10n.changelog),
              ),
              AdaptiveDialogAction(
                bigButtons: true,
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
