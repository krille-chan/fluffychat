import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'settings_security.dart';

class SettingsSecurityView extends StatelessWidget {
  final SettingsSecurityController controller;
  const SettingsSecurityView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context)!.security)),
      body: ListTileTheme(
        iconColor: Theme.of(context).colorScheme.onBackground,
        child: MaxWidthBody(
          withScrolling: true,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_outlined),
                trailing: const Icon(Icons.chevron_right_outlined),
                title: Text(L10n.of(context)!.whoCanSeeMyStories),
                onTap: () => VRouter.of(context).to('stories'),
              ),
              ListTile(
                leading: const Icon(Icons.block_outlined),
                trailing: const Icon(Icons.chevron_right_outlined),
                title: Text(L10n.of(context)!.ignoredUsers),
                onTap: () => VRouter.of(context).to('ignorelist'),
              ),
              ListTile(
                leading: const Icon(Icons.password_outlined),
                trailing: const Icon(Icons.chevron_right_outlined),
                title: Text(
                  L10n.of(context)!.changePassword,
                ),
                onTap: controller.changePasswordAccountAction,
              ),
              ListTile(
                leading: const Icon(Icons.mail_outlined),
                trailing: const Icon(Icons.chevron_right_outlined),
                title: Text(L10n.of(context)!.passwordRecovery),
                onTap: () => VRouter.of(context).to('3pid'),
              ),
              if (Matrix.of(context).client.encryption != null) ...{
                const Divider(thickness: 1),
                if (PlatformInfos.isMobile)
                  ListTile(
                    leading: const Icon(Icons.lock_outlined),
                    trailing: const Icon(Icons.chevron_right_outlined),
                    title: Text(L10n.of(context)!.appLock),
                    onTap: controller.setAppLockAction,
                  ),
                ListTile(
                  title: Text(L10n.of(context)!.yourPublicKey),
                  subtitle: Text(
                    Matrix.of(context).client.fingerprintKey.beautified,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                  leading: const Icon(Icons.vpn_key_outlined),
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
            ],
          ),
        ),
      ),
    );
  }
}
