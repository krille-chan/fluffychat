import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';
import '../../utils/client_presence_extension.dart';
import '../avatar.dart';
import '../matrix.dart';

class PresenceListItem extends StatelessWidget {
  final Presence presence;

  const PresenceListItem(this.presence);

  void _startChatAction(BuildContext context, String userId) async {
    final roomId = await User(userId,
            room: Room(client: Matrix.of(context).client, id: ''))
        .startDirectChat();
    await Navigator.of(context).pushAndRemoveUntil(
        AppRoute.defaultRoute(
          context,
          ChatView(roomId),
        ),
        (Route r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
        future:
            Matrix.of(context).client.requestProfileCached(presence.senderId),
        builder: (context, snapshot) {
          Uri avatarUrl;
          var displayname = presence.senderId.localpart;
          if (snapshot.hasData) {
            avatarUrl = snapshot.data.avatarUrl;
            displayname =
                snapshot.data.displayname ?? presence.senderId.localpart;
          }
          return InkWell(
            onTap: () => _startChatAction(context, presence.senderId),
            child: Container(
              width: 80,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 9),
                  Avatar(avatarUrl, displayname),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      displayname,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
