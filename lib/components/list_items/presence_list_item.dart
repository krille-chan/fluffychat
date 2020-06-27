import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/presence_dialog.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
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
    return InkWell(
      onTap: () => presence?.presence?.statusMsg == null
          ? _startChatAction(context, user.id)
          : showDialog(
              context: context,
              builder: (_) => PresenceDialog(
                presence,
                avatarUrl: user.avatarUrl,
                displayname: user.calcDisplayname(),
              ),
            ),
      child: Container(
        width: 80,
        child: Column(
          children: <Widget>[
            SizedBox(height: 16),
            Container(
              child: Avatar(user.avatarUrl, user.calcDisplayname()),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: presence?.presence?.statusMsg == null
                      ? presence?.presence?.currentlyActive == true
                          ? Colors.blue
                          : Theme.of(context).secondaryHeaderColor
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
                      .withOpacity(0.66),
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
