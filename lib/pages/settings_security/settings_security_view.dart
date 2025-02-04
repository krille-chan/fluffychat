import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/settings_switch_list_tile.dart';
import 'settings_security.dart';

class SettingsSecurityView extends StatelessWidget {
  final SettingsSecurityController controller;
  const SettingsSecurityView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).security)),
      body: ListTileTheme(
        iconColor: theme.colorScheme.onSurface,
        child: MaxWidthBody(
          child: FutureBuilder(
            future: Matrix.of(context)
                .client
                .getCapabilities()
                .timeout(const Duration(seconds: 10)),
            builder: (context, snapshot) {
              final capabilities = snapshot.data;
              final error = snapshot.error;
              if (error == null && capabilities == null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  ),
                );
              }
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      L10n.of(context).privacy,
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SettingsSwitchListTile.adaptive(
                    title: L10n.of(context).sendTypingNotifications,
                    subtitle:
                        L10n.of(context).sendTypingNotificationsDescription,
                    onChanged: (b) => AppConfig.sendTypingNotifications = b,
                    storeKey: SettingKeys.sendTypingNotifications,
                    defaultValue: AppConfig.sendTypingNotifications,
                  ),
                  SettingsSwitchListTile.adaptive(
                    title: L10n.of(context).sendReadReceipts,
                    subtitle: L10n.of(context).sendReadReceiptsDescription,
                    onChanged: (b) => AppConfig.sendPublicReadReceipts = b,
                    storeKey: SettingKeys.sendPublicReadReceipts,
                    defaultValue: AppConfig.sendPublicReadReceipts,
                  ),
                  ListTile(
                    trailing: const Icon(Icons.chevron_right_outlined),
                    title: Text(L10n.of(context).blockedUsers),
                    subtitle: Text(
                      L10n.of(context).thereAreCountUsersBlocked(
                        Matrix.of(context).client.ignoredUsers.length,
                      ),
                    ),
                    onTap: () =>
                        context.go('/rooms/settings/security/ignorelist'),
                  ),
                  if (Matrix.of(context).client.encryption != null) ...{
                    if (PlatformInfos.isMobile)
                      ListTile(
                        trailing: const Icon(Icons.chevron_right_outlined),
                        title: Text(L10n.of(context).appLock),
                        subtitle: Text(L10n.of(context).appLockDescription),
                        onTap: controller.setAppLockAction,
                      ),
                  },
                  Divider(color: theme.dividerColor),
                  ListTile(
                    title: Text(
                      L10n.of(context).account,
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(L10n.of(context).yourPublicKey),
                    leading: const Icon(Icons.vpn_key_outlined),
                    subtitle: SelectableText(
                      Matrix.of(context).client.fingerprintKey.beautified,
                      style: const TextStyle(fontFamily: 'UbuntuMono'),
                    ),
                  ),
                  if (capabilities?.mChangePassword?.enabled != false ||
                      error != null)
                    ListTile(
                      leading: const Icon(Icons.password_outlined),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      title: Text(L10n.of(context).changePassword),
                      onTap: () =>
                          context.go('/rooms/settings/security/password'),
                    ),
                  ListTile(
                    iconColor: Colors.orange,
                    leading: const Icon(Icons.delete_sweep_outlined),
                    title: Text(
                      L10n.of(context).dehydrate,
                      style: const TextStyle(color: Colors.orange),
                    ),
                    onTap: controller.dehydrateAction,
                  ),
                  Divider(color: theme.dividerColor),
                  ListTile(
                    iconColor: Colors.red,
                    leading: const Icon(Icons.delete_outlined),
                    title: Text(
                      L10n.of(context).deleteAccount,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onTap: controller.deleteAccountAction,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
