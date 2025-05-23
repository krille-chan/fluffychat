import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';

abstract class UpdateNotifier {
  static const String versionStoreKey = 'last_known_version';

  static void showUpdateSnackBar(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final currentVersion = await PlatformInfos.getVersion();
    final store = await SharedPreferences.getInstance();
    final storedVersion = store.getString(versionStoreKey);

    if (currentVersion != storedVersion) {
      if (storedVersion != null) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 30),
            showCloseIcon: true,
            content: Text(L10n.of(context).updateInstalled(currentVersion)),
            action: SnackBarAction(
              label: L10n.of(context).changelog,
              onPressed: () => launchUrlString(AppConfig.changelogUrl),
            ),
          ),
        );
      }
      await store.setString(versionStoreKey, currentVersion);
    }
  }
}
