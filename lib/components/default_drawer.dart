import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/archive.dart';
import 'package:fluffychat/views/discover_view.dart';
import 'package:fluffychat/views/new_group.dart';
import 'package:fluffychat/views/new_private_chat.dart';
import 'package:fluffychat/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'matrix.dart';

class DefaultDrawer extends StatelessWidget {
  void _drawerTapAction(BuildContext context, Widget view) {
    Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
      AppRoute.defaultRoute(
        context,
        view,
      ),
      (r) => r.isFirst,
    );
  }

  void _setStatus(BuildContext context) async {
    Navigator.of(context).pop();
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
    final client = Matrix.of(context).client;
    await showFutureLoadingDialog(
      context: context,
      future: () => client.sendPresence(
        client.userID,
        PresenceType.online,
        statusMsg: input.single,
      ),
    );
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
              onTap: () => _drawerTapAction(context, NewGroupView()),
            ),
            ListTile(
              leading: Icon(Icons.person_add_outlined),
              title: Text(L10n.of(context).newPrivateChat),
              onTap: () => _drawerTapAction(context, NewPrivateChatView()),
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.archive_outlined),
              title: Text(L10n.of(context).archive),
              onTap: () => _drawerTapAction(
                context,
                Archive(),
              ),
            ),
            ListTile(
              leading: Icon(Icons.group_work_outlined),
              title: Text(L10n.of(context).discoverGroups),
              onTap: () => _drawerTapAction(
                context,
                DiscoverView(),
              ),
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text(L10n.of(context).settings),
              onTap: () => _drawerTapAction(
                context,
                SettingsView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
