import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';

abstract class UpdateNotifier {
  static const String versionStoreKey = 'last_known_version';

  static void showUpdateSnackBar(BuildContext context) async {
    final theme = Theme.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final currentVersion = await PlatformInfos.getVersion();
    final store = await SharedPreferences.getInstance();
    final storedVersion = store.getString(versionStoreKey);

    if (currentVersion != storedVersion) {
      if (storedVersion != null) {
        ScaffoldFeatureController? controller;
        controller = scaffoldMessenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 30),
            content: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close_outlined,
                    size: 20,
                    color: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () => controller?.close(),
                ),
                Expanded(
                  child: Text(
                    L10n.of(context).updateInstalled(currentVersion),
                  ),
                ),
              ],
            ),
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
