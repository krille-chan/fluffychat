import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';
import 'package:matrix/matrix.dart';

import '../settings_account.dart';

class SettingsAccountView extends StatelessWidget {
  final SettingsAccountController controller;
  const SettingsAccountView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).account)),
      body: MaxWidthBody(
        withScrolling: true,
        child: Column(
          children: [
            ListTile(
              trailing: Icon(Icons.edit_outlined),
              title: Text(L10n.of(context).editDisplayname),
              subtitle: Text(controller.profile?.displayName ??
                  Matrix.of(context).client.userID.localpart),
              onTap: controller.setDisplaynameAction,
            ),
            ListTile(
              trailing: Icon(Icons.phone_outlined),
              title: Text(L10n.of(context).editJitsiInstance),
              subtitle: Text(AppConfig.jitsiInstance),
              onTap: controller.setJitsiInstanceAction,
            ),
            ListTile(
              trailing: Icon(Icons.devices_other_outlined),
              title: Text(L10n.of(context).devices),
              onTap: () => VRouter.of(context).to('devices'),
            ),
            ListTile(
              trailing: Icon(Icons.exit_to_app_outlined),
              title: Text(L10n.of(context).logout),
              onTap: controller.logoutAction,
            ),
            ListTile(
              trailing: Icon(Icons.delete_forever_outlined),
              title: Text(
                L10n.of(context).deleteAccount,
                style: TextStyle(color: Colors.red),
              ),
              onTap: controller.deleteAccountAction,
            ),
          ],
        ),
      ),
    );
  }
}
