import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';

import '../avatar.dart';
import '../matrix.dart';

class ParticipantListItem extends StatelessWidget {
  final User user;

  const ParticipantListItem(this.user);

  participantAction(BuildContext context, String action) async {
    final MatrixState matrix = Matrix.of(context);
    switch (action) {
      case "ban":
        await matrix.tryRequestWithLoadingDialog(user.ban());
        break;
      case "unban":
        await matrix.tryRequestWithLoadingDialog(user.unban());
        break;
      case "kick":
        await matrix.tryRequestWithLoadingDialog(user.kick());
        break;
      case "admin":
        await matrix.tryRequestWithLoadingDialog(user.setPower(100));
        break;
      case "user":
        await matrix.tryRequestWithLoadingDialog(user.setPower(100));
        break;
      case "message":
        final String roomId = await user.startDirectChat();
        await Navigator.of(context).pushAndRemoveUntil(
            AppRoute.defaultRoute(
              context,
              Chat(roomId),
            ),
            (Route r) => r.isFirst);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Map<Membership, String> membershipBatch = {
      Membership.join: "",
      Membership.ban: "Banned",
      Membership.invite: "Invited",
      Membership.leave: "Left",
    };
    final String permissionBatch = user.powerLevel == 100
        ? "Admin"
        : user.powerLevel >= 50 ? "Moderator" : "";
    List<PopupMenuEntry<String>> items = <PopupMenuEntry<String>>[];
    if (user.canChangePowerLevel &&
        user.room.ownPowerLevel == 100 &&
        user.powerLevel != 100) {
      items.add(
        PopupMenuItem(child: Text("Make an admin"), value: "admin"),
      );
    }
    if (user.canChangePowerLevel && user.powerLevel != 0) {
      items.add(
        PopupMenuItem(child: Text("Revoke all permissions"), value: "user"),
      );
    }
    if (user.canKick) {
      items.add(
        PopupMenuItem(child: Text("Kick from group"), value: "kick"),
      );
    }
    if (user.canBan && user.membership != Membership.ban) {
      items.add(
        PopupMenuItem(child: Text("Ban from group"), value: "ban"),
      );
    } else if (user.canBan && user.membership == Membership.ban) {
      items.add(
        PopupMenuItem(child: Text("Remove exile"), value: "unban"),
      );
    }
    if (user.id != Matrix.of(context).client.userID) {
      items.add(
        PopupMenuItem(child: Text("Send a message"), value: "message"),
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
