import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'settings_account.dart';

class SettingsAccountView extends StatelessWidget {
  final SettingsAccountController controller;
  const SettingsAccountView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context)!.account)),
      body: ListTileTheme(
        iconColor: Theme.of(context).textTheme.bodyText1!.color,
        child: MaxWidthBody(
          withScrolling: true,
          child: Column(
            children: [
              ListTile(
                title: Text(L10n.of(context)!.yourUserId),
                subtitle: Text(Matrix.of(context).client.userID!),
                trailing: const Icon(Icons.copy_outlined),
                onTap: () => FluffyShare.share(
                  Matrix.of(context).client.userID!,
                  context,
                ),
              ),
              ListTile(
                trailing: const Icon(Icons.edit_outlined),
                title: Text(L10n.of(context)!.editDisplayname),
                subtitle: Text(controller.profile?.displayName ??
                    Matrix.of(context).client.userID!.localpart!),
                onTap: controller.setDisplaynameAction,
              ),
              const Divider(height: 1),
              ListTile(
                trailing: const Icon(Icons.person_add_outlined),
                title: Text(L10n.of(context)!.addAccount),
                subtitle: Text(L10n.of(context)!.enableMultiAccounts),
                onTap: controller.addAccountAction,
              ),
              ListTile(
                trailing: const Icon(Icons.exit_to_app_outlined),
                title: Text(L10n.of(context)!.logout),
                onTap: controller.logoutAction,
              ),
              const Divider(height: 1),
              ListTile(
                trailing: const Icon(Icons.delete_outlined),
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
