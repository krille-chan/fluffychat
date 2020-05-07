import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';

import '../avatar.dart';
import '../matrix.dart';

class ParticipantListItem extends StatelessWidget {
  final User user;

  const ParticipantListItem(this.user);

  participantAction(BuildContext context, String action) async {
    switch (action) {
      case "ban":
        if (await SimpleDialogs(context).askConfirmation()) {
          await SimpleDialogs(context).tryRequestWithLoadingDialog(user.ban());
        }
        break;
      case "unban":
        if (await SimpleDialogs(context).askConfirmation()) {
          await SimpleDialogs(context)
              .tryRequestWithLoadingDialog(user.unban());
        }
        break;
      case "kick":
        if (await SimpleDialogs(context).askConfirmation()) {
          await SimpleDialogs(context).tryRequestWithLoadingDialog(user.kick());
        }
        break;
      case "admin":
        if (await SimpleDialogs(context).askConfirmation()) {
          await SimpleDialogs(context)
              .tryRequestWithLoadingDialog(user.setPower(100));
        }
        break;
      case "moderator":
        if (await SimpleDialogs(context).askConfirmation()) {
          await SimpleDialogs(context)
              .tryRequestWithLoadingDialog(user.setPower(50));
        }
        break;
      case "user":
        if (await SimpleDialogs(context).askConfirmation()) {
          await SimpleDialogs(context)
              .tryRequestWithLoadingDialog(user.setPower(0));
        }
        break;
      case "message":
        final String roomId = await user.startDirectChat();
        await Navigator.of(context).pushAndRemoveUntil(
            AppRoute.defaultRoute(
              context,
              ChatView(roomId),
            ),
            (Route r) => r.isFirst);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<Membership, String> membershipBatch = {
      Membership.join: "",
      Membership.ban: L10n.of(context).banned,
      Membership.invite: L10n.of(context).invited,
      Membership.leave: L10n.of(context).leftTheChat,
    };
    final String permissionBatch = user.powerLevel == 100
        ? L10n.of(context).admin
        : user.powerLevel >= 50 ? L10n.of(context).moderator : "";
    List<PopupMenuEntry<String>> items = <PopupMenuEntry<String>>[];

    if (user.id != Matrix.of(context).client.userID) {
      items.add(
        PopupMenuItem(
            child: Text(L10n.of(context).sendAMessage), value: "message"),
      );
    }
    if (user.canChangePowerLevel &&
        user.room.ownPowerLevel == 100 &&
        user.powerLevel != 100) {
      items.add(
        PopupMenuItem(
            child: Text(L10n.of(context).makeAnAdmin), value: "admin"),
      );
    }
    if (user.canChangePowerLevel &&
        user.room.ownPowerLevel >= 50 &&
        user.powerLevel != 50) {
      items.add(
        PopupMenuItem(
            child: Text(L10n.of(context).makeAModerator), value: "moderator"),
      );
    }
    if (user.canChangePowerLevel && user.powerLevel != 0) {
      items.add(
        PopupMenuItem(
            child: Text(L10n.of(context).revokeAllPermissions), value: "user"),
      );
    }
    if (user.canKick) {
      items.add(
        PopupMenuItem(
            child: Text(L10n.of(context).kickFromChat), value: "kick"),
      );
    }
    if (user.canBan && user.membership != Membership.ban) {
      items.add(
        PopupMenuItem(child: Text(L10n.of(context).banFromChat), value: "ban"),
      );
    } else if (user.canBan && user.membership == Membership.ban) {
      items.add(
        PopupMenuItem(
            child: Text(L10n.of(context).removeExile), value: "unban"),
      );
    }
    return PopupMenuButton(
      onSelected: (action) => participantAction(context, action),
      itemBuilder: (c) => items,
      child: ListTile(
        title: Row(
          children: <Widget>[
            Text(user.calcDisplayname()),
            permissionBatch.isEmpty
                ? Container()
                : Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Text(permissionBatch)),
                  ),
            membershipBatch[user.membership].isEmpty
                ? Container()
                : Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Center(child: Text(membershipBatch[user.membership])),
                  ),
          ],
        ),
        subtitle: Text(user.id),
        leading: Avatar(user.avatarUrl, user.calcDisplayname()),
      ),
    );
  }
}
