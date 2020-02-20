import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pedantic/pedantic.dart';
import 'package:toast/toast.dart';

import '../../i18n/i18n.dart';
import '../../utils/app_route.dart';
import '../../utils/date_time_extension.dart';
import '../../utils/event_extension.dart';
import '../../utils/room_extension.dart';
import '../../views/chat.dart';
import '../theme_switcher.dart';
import '../avatar.dart';
import '../dialogs/simple_dialogs.dart';
import '../matrix.dart';

class ChatListItem extends StatelessWidget {
  final Room room;
  final bool activeChat;
  final Function onForget;

  const ChatListItem(this.room, {this.activeChat = false, this.onForget});

  void clickAction(BuildContext context) async {
    if (!activeChat) {
      if (room.membership == Membership.invite &&
          await Matrix.of(context).tryRequestWithLoadingDialog(room.join()) ==
              false) {
        return;
      }

      if (room.membership == Membership.ban) {
        Toast.show(I18n.of(context).youHaveBeenBannedFromThisChat, context,
            duration: 5);
        return;
      }

      if (room.membership == Membership.leave) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(I18n.of(context).archivedRoom),
            content: Text(I18n.of(context).thisRoomHasBeenArchived),
            actions: <Widget>[
              FlatButton(
                child: Text(I18n.of(context).close.toUpperCase(),
                    style: TextStyle(color: Colors.blueGrey)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text(I18n.of(context).delete.toUpperCase(),
                    style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  await archiveAction(context);
                  await Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(I18n.of(context).rejoin.toUpperCase(),
                    style: TextStyle(color: Colors.blue)),
                onPressed: () async {
                  await Matrix.of(context)
                      .tryRequestWithLoadingDialog(room.join());
                  await Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }

      if (room.membership == Membership.join) {
        if (Matrix.of(context).shareContent != null) {
          unawaited(room.sendEvent(Matrix.of(context).shareContent));
          Matrix.of(context).shareContent = null;
        }
        await Navigator.pushAndRemoveUntil(
          context,
          AppRoute.defaultRoute(context, ChatView(room.id)),
          (r) => r.isFirst,
        );
      }
    }
  }

  Future<bool> archiveAction(BuildContext context) async {
    {
      if ([Membership.leave, Membership.ban].contains(room.membership)) {
        final success =
            await Matrix.of(context).tryRequestWithLoadingDialog(room.forget());
        if (success != false) {
          if (this.onForget != null) this.onForget();
        }
        return success;
      }
      final bool confirmed = await SimpleDialogs(context).askConfirmation();
      if (!confirmed) {
        return false;
      }
      final success =
          await Matrix.of(context).tryRequestWithLoadingDialog(room.leave());
      if (success == false) {
        return false;
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(room.id),
      secondaryActions: <Widget>[
        if ([Membership.join, Membership.invite].contains(room.membership))
          IconSlideAction(
            caption: I18n.of(context).leave,
            color: Colors.red,
            icon: Icons.archive,
            onTap: () => archiveAction(context),
          ),
        if ([Membership.leave, Membership.ban].contains(room.membership))
          IconSlideAction(
            caption: I18n.of(context).delete,
            color: Colors.red,
            icon: Icons.delete_forever,
            onTap: () => archiveAction(context),
          ),
      ],
      actionPane: SlidableDrawerActionPane(),
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onWillDismiss: (actionType) => archiveAction(context),
      ),
      child: Material(
        color: chatListItemColor(context, activeChat),
        child: ListTile(
          leading: Avatar(room.avatar, room.displayname),
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  room.getLocalizedDisplayname(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 16),
              room.pushRuleState == PushRuleState.notify
                  ? Container()
                  : Icon(
                      Icons.notifications_off,
                      color: Colors.grey[400],
                      size: 16,
                    ),
              SizedBox(width: 4),
              Text(
                room.timeCreated.localizedTimeShort(context),
                style: TextStyle(
                  color: Color(0xFF555555),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: room.membership == Membership.invite
                    ? Text(
                        I18n.of(context).youAreInvitedToThisChat,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Text(
                        room.lastEvent.getLocalizedBody(context,
                            withSenderNamePrefix: true, hideReply: true),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          decoration: room.lastEvent.redacted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
              ),
              SizedBox(width: 8),
              room.notificationCount > 0
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 20,
                      decoration: BoxDecoration(
                        color: room.highlightCount > 0
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          room.notificationCount.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : Text(" "),
            ],
          ),
          onTap: () => clickAction(context),
        ),
      ),
    );
  }
}
