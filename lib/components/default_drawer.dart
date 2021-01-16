import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'matrix.dart';

class DefaultDrawer extends StatelessWidget {
  void _drawerTapAction(BuildContext context, String route) {
    Navigator.of(context).pop();
    AdaptivePageLayout.of(context).pushNamedAndRemoveUntilIsFirst(route);
  }

  void _setStatus(BuildContext context) async {
    final client = Matrix.of(context).client;
    final input = await showTextInputDialog(
      title: L10n.of(context).setStatus,
      context: context,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context).statusExampleMessage,
        )
      ],
    );
    if (input == null || input.single.isEmpty) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => client.sendPresence(
        client.userID,
        PresenceType.online,
        statusMsg: input.single,
      ),
    );
    Navigator.of(context).pop();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text(L10n.of(context).setStatus),
              onTap: () => _setStatus(context),
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.people_outline),
              title: Text(L10n.of(context).createNewGroup),
              onTap: () => _drawerTapAction(context, '/newgroup'),
            ),
            ListTile(
              leading: Icon(Icons.person_add_outlined),
              title: Text(L10n.of(context).newPrivateChat),
              onTap: () => _drawerTapAction(context, '/newprivatechat'),
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.archive_outlined),
              title: Text(L10n.of(context).archive),
              onTap: () => _drawerTapAction(
                context,
                '/archive',
              ),
            ),
            ListTile(
              leading: Icon(Icons.group_work_outlined),
              title: Text(L10n.of(context).discoverGroups),
              onTap: () => _drawerTapAction(
                context,
                '/discover',
              ),
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text(L10n.of(context).settings),
              onTap: () => _drawerTapAction(
                context,
                '/settings',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
