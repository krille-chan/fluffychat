import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:fluffychat/views/presence_view.dart';
import 'package:flutter/material.dart';
import '../avatar.dart';
import '../matrix.dart';

class PresenceListItem extends StatelessWidget {
  final Room room;

  const PresenceListItem(this.room);

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
    final user = room.getUserByMXIDSync(room.directChatMatrixID);
    final presence =
        Matrix.of(context).client.presences[room.directChatMatrixID];
    final hasStatus = presence?.presence?.statusMsg != null;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => presence?.presence?.statusMsg == null
          ? _startChatAction(context, user.id)
          : /*showDialog(
              context: context,
              builder: (_) => PresenceDialog(
                presence,
                avatarUrl: user.avatarUrl,
                displayname: user.calcDisplayname(),
              ),
            ),*/
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PresenceView(
                  presence: presence,
                  avatarUrl: user.avatarUrl,
                  displayname: user.calcDisplayname(),
                ),
              ),
            ),
      child: Container(
        width: 76,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Container(
              child: Stack(
                children: [
                  Avatar(user.avatarUrl, user.calcDisplayname()),
                  if (presence?.presence?.currentlyActive == true)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: !hasStatus
                      ? Theme.of(context).secondaryHeaderColor
                      : Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(80),
              ),
              padding: EdgeInsets.all(2),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0, top: 0.0, right: 6.0),
              child: Text(
                user.calcDisplayname().trim().split(' ').first,
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .color
                      .withOpacity(hasStatus ? 1 : 0.66),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
