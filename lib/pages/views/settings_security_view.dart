import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../settings_security.dart';

class SettingsSecurityView extends StatelessWidget {
  final SettingsSecurityController controller;
  const SettingsSecurityView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).security)),
      body: MaxWidthBody(
        withScrolling: true,
        child: Column(
          children: [
            ListTile(
              trailing: const Icon(Icons.block_outlined),
              title: Text(L10n.of(context).ignoredUsers),
              onTap: () => VRouter.of(context).to('ignorelist'),
            ),
            ListTile(
              trailing: const Icon(Icons.security_outlined),
              title: Text(
                L10n.of(context).changePassword,
              ),
              onTap: controller.changePasswordAccountAction,
            ),
            ListTile(
              trailing: const Icon(Icons.email_outlined),
              title: Text(L10n.of(context).passwordRecovery),
              onTap: () => VRouter.of(context).to('3pid'),
            ),
            if (Matrix.of(context).client.encryption != null) ...{
              const Divider(thickness: 1),
              if (PlatformInfos.isMobile)
                ListTile(
                  trailing: const Icon(Icons.lock_outlined),
                  title: Text(L10n.of(context).appLock),
                  onTap: controller.setAppLockAction,
                ),
              ListTile(
                title: Text(L10n.of(context).yourPublicKey),
                onTap: () => showOkAlertDialog(
                  useRootNavigator: false,
                  context: context,
                  title: L10n.of(context).yourPublicKey,
                  message: Matrix.of(context).client.fingerprintKey.beautified,
                  okLabel: L10n.of(context).ok,
                ),
                trailing: const Icon(Icons.vpn_key_outlined),
              ),
              ListTile(
                title: Text(L10n.of(context).cachedKeys),
                trailing: const Icon(Icons.wb_cloudy_outlined),
                subtitle: Text(
                    '${Matrix.of(context).client.encryption.keyManager.enabled ? L10n.of(context).onlineKeyBackupEnabled : L10n.of(context).onlineKeyBackupDisabled}\n${Matrix.of(context).client.encryption.crossSigning.enabled ? L10n.of(context).crossSigningEnabled : L10n.of(context).crossSigningDisabled}'),
                onTap: controller.bootstrapSettingsAction,
              ),
            },
          ],
        ),
      ),
    );
  }
}
