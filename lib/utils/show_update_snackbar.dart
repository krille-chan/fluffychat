import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            duration: const Duration(
              seconds:
                  // #Pangea
                  // 30
                  5,
              // Pangea#
            ),
            showCloseIcon: true,
            content: Text(L10n.of(context).updateInstalled(currentVersion)),
            // #Pangea
            // action: SnackBarAction(
            //   label: L10n.of(context).changelog,
            //   onPressed: () => launchUrlString(AppConfig.changelogUrl),
            // ),
            // Pangea#
          ),
        );
      }
      await store.setString(versionStoreKey, currentVersion);
    }
  }
}
