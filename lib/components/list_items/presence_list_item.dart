import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';

import '../avatar.dart';
import '../matrix.dart';
import 'package:fluffychat/utils/presence_extension.dart';

class PresenceListItem extends StatelessWidget {
  final Presence presence;

  const PresenceListItem(this.presence);

  Future<Profile> _requestProfile(BuildContext context) async {
    if (presence.avatarUrl != null) {
      return Profile.fromJson({
        'avatar_url': presence.avatarUrl.toString(),
        'displayname': presence.displayname ?? presence.sender.localpart,
      });
    }
    return Matrix.of(context).client.getProfileFromUserId(presence.sender);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
        future: _requestProfile(context),
        builder: (context, snapshot) {
          Uri avatarUrl;
          String displayname = presence.sender.localpart;
          if (snapshot.hasData) {
            avatarUrl = snapshot.data.avatarUrl;
            displayname = snapshot.data.displayname;
          }
          return InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (c) => AlertDialog(
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
                    if (presence.isStatus)
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
                      child: Text(I18n.of(context).sendAMessage),
                      onPressed: () async {
                        final String roomId = await User(
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
                    child: Text(I18n.of(context).close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
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
