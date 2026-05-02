import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

abstract class UpdateNotifier {
  static const String versionStoreKey = 'last_known_version';

  static Future<void> showUpdateSnackBar(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final currentVersion = await PlatformInfos.getVersion();
    final store = await SharedPreferences.getInstance();
    final storedVersion = store.getString(versionStoreKey);

    if (currentVersion != storedVersion) {
      if (storedVersion != null) {
        scaffoldMessenger.showMaterialBanner(
          MaterialBanner(
            content: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.updateInstalled(currentVersion),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    CloseButton(
                      onPressed: scaffoldMessenger.clearMaterialBanners,
                    ),
                  ],
                ),
                Text(l10n.fluffyChatSupportBannerMessage),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => launchUrlString(AppConfig.changelogUrl),
                child: Text(l10n.changelog),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                  foregroundColor: theme.colorScheme.onErrorContainer,
                ),
                onPressed: () => launchUrlString(AppConfig.supportUrl),
                icon: Icon(Icons.favorite),
                label: Text(l10n.support),
              ),
            ],
          ),
        );
      }
      await store.setString(versionStoreKey, currentVersion);
    }
  }
}
