import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';
import 'package:fluffychat/utils/presence_extension.dart';

import '../avatar.dart';
import '../matrix.dart';

class PresenceDialog extends StatelessWidget {
  final Uri avatarUrl;
  final String displayname;
  final Presence presence;

  const PresenceDialog(
    this.presence, {
    this.avatarUrl,
    this.displayname,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Avatar(avatarUrl, displayname),
        title: Text(displayname),
        subtitle: Text(presence.sender),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(presence.getLocalizedStatusMessage(context)),
          if (presence.presence != null)
            Text(
              presence.presence.toString().split('.').last,
              style: TextStyle(
                color: presence.currentlyActive == true
                    ? Colors.green
                    : Theme.of(context).primaryColor,
              ),
            )
        ],
      ),
      actions: <Widget>[
        if (presence.sender != Matrix.of(context).client.userID)
          FlatButton(
            child: Text(L10n.of(context).sendAMessage),
            onPressed: () async {
              final roomId = await User(
                presence.sender,
                room: Room(id: '', client: Matrix.of(context).client),
              ).startDirectChat();
              await Navigator.of(context).pushAndRemoveUntil(
                  AppRoute.defaultRoute(
                    context,
                    ChatView(roomId),
                  ),
                  (Route r) => r.isFirst);
            },
          ),
        FlatButton(
          child: Text(L10n.of(context).close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
