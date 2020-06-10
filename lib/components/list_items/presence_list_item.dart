import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/presence_dialog.dart';
import 'package:flutter/material.dart';

import '../avatar.dart';
import '../matrix.dart';

class PresenceListItem extends StatelessWidget {
  final Presence presence;

  const PresenceListItem(this.presence);

  static final Map<String, Profile> _presences = {};

  Future<Profile> _requestProfile(BuildContext context) async {
    _presences[presence.senderId] ??=
        await Matrix.of(context).client.getProfileFromUserId(presence.senderId);
    return _presences[presence.senderId];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
        future: _requestProfile(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          Uri avatarUrl;
          var displayname = presence.senderId.localpart;
          if (snapshot.hasData) {
            avatarUrl = snapshot.data.avatarUrl;
            displayname = snapshot.data.displayname;
          }
          return InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (c) => PresenceDialog(
                presence,
                avatarUrl: avatarUrl,
                displayname: displayname,
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
            ),
          );
        });
  }
}
