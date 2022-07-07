import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/spaces_drawer.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ChatListDrawer extends StatelessWidget {
  final ChatListController controller;
  const ChatListDrawer(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SpacesDrawer(
                  controller: controller,
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.group_add_outlined,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                title: Text(L10n.of(context)!.createNewGroup),
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  VRouter.of(context).to('/newgroup');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.adaptive.share_outlined,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                title: Text(L10n.of(context)!.inviteContact),
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  FluffyShare.share(
                      L10n.of(context)!.inviteText(
                          Matrix.of(context).client.userID!,
                          'https://matrix.to/#/${Matrix.of(context).client.userID}?client=im.fluffychat'),
                      context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings_outlined,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                title: Text(L10n.of(context)!.settings),
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  VRouter.of(context).to('/settings');
                },
              ),
            ],
          ),
        ),
      );
}
