import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'settings_security.dart';

class SettingsSecurityView extends StatelessWidget {
  final SettingsSecurityController controller;
  const SettingsSecurityView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context)!.security)),
      body: ListTileTheme(
        iconColor: Theme.of(context).colorScheme.onBackground,
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
                  if (error != null)
                    ListTile(
                      leading: const Icon(
                        Icons.warning_outlined,
                        color: Colors.orange,
                      ),
                      title: Text(
                        error.toLocalizedString(context),
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                  if (capabilities?.mChangePassword?.enabled == true ||
                      error != null) ...[
                    ListTile(
                      leading: const Icon(Icons.key_outlined),
                      trailing: error != null
                          ? null
                          : const Icon(Icons.chevron_right_outlined),
                      title: Text(
                        L10n.of(context)!.changePassword,
                        style: TextStyle(
                          decoration:
                              error == null ? null : TextDecoration.lineThrough,
                        ),
                      ),
                      onTap: error != null
                          ? null
                          : () =>
                              context.go('/rooms/settings/security/password'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.mail_outlined),
                      trailing: error != null
                          ? null
                          : const Icon(Icons.chevron_right_outlined),
                      title: Text(
                        L10n.of(context)!.passwordRecovery,
                        style: TextStyle(
                          decoration:
                              error == null ? null : TextDecoration.lineThrough,
                        ),
                      ),
                      onTap: error != null
                          ? null
                          : () => context.go('/rooms/settings/security/3pid'),
                    ),
                  ],
                  ListTile(
                    leading: const Icon(Icons.block_outlined),
                    trailing: const Icon(Icons.chevron_right_outlined),
                    title: Text(L10n.of(context)!.blockedUsers),
                    onTap: () =>
                        context.go('/rooms/settings/security/ignorelist'),
                  ),
                  if (Matrix.of(context).client.encryption != null) ...{
                    if (PlatformInfos.isMobile)
                      ListTile(
                        leading: const Icon(Icons.lock_outlined),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        title: Text(L10n.of(context)!.appLock),
                        onTap: controller.setAppLockAction,
                      ),
                  },
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.tap_and_play),
                    trailing: const Icon(Icons.chevron_right_outlined),
                    title: Text(
                      L10n.of(context)!.dehydrate,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onTap: controller.dehydrateAction,
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outlined),
                    trailing: const Icon(Icons.chevron_right_outlined),
                    title: Text(
                      L10n.of(context)!.deleteAccount,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onTap: controller.deleteAccountAction,
                  ),
                  ListTile(
                    title: Text(L10n.of(context)!.yourPublicKey),
                    subtitle: SelectableText(
                      Matrix.of(context).client.fingerprintKey.beautified,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    leading: const Icon(Icons.vpn_key_outlined),
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
