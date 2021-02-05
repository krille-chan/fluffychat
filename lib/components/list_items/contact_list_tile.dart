import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/presence_extension.dart';
import '../matrix.dart';

class ContactListTile extends StatelessWidget {
  final Presence contact;

  const ContactListTile({Key key, @required this.contact}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var statusMsg = contact.presence?.statusMsg?.isNotEmpty ?? false
        ? contact.presence.statusMsg
        : null;
    return FutureBuilder<Profile>(
        future:
            Matrix.of(context).client.getProfileFromUserId(contact.senderId),
        builder: (context, snapshot) {
          final displayname =
              snapshot.data?.displayname ?? contact.senderId.localpart;
          final avatarUrl = snapshot.data?.avatarUrl;
          return ListTile(
              leading: Avatar(avatarUrl, displayname),
              title: Row(
                children: [
                  Icon(Icons.circle, color: contact.color, size: 10),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      displayname,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              subtitle: statusMsg == null
                  ? Text(contact.getLocalizedLastActiveAgo(context))
                  : Row(
                      children: [
                        Icon(Icons.edit_outlined,
                            color: Theme.of(context).accentColor, size: 12),
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            statusMsg,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                        ),
                      ],
                    ),
              onTap: () async {
                if (contact.senderId == Matrix.of(context).client.userID) {
                  return;
                }
                final roomId = await User(contact.senderId,
                        room: Room(id: '', client: Matrix.of(context).client))
                    .startDirectChat();
                await AdaptivePageLayout.of(context)
                    .pushNamedAndRemoveUntilIsFirst('/rooms/${roomId}');
              });
        });
  }
}
