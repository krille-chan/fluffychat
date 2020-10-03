import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/user_status.dart';
import 'package:fluffychat/views/status_view.dart';
import 'package:flutter/material.dart';
import '../avatar.dart';
import '../matrix.dart';

class StatusListItem extends StatelessWidget {
  final UserStatus status;

  const StatusListItem(this.status, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    return FutureBuilder<Profile>(
        future: client.getProfileFromUserId(status.userId),
        builder: (context, snapshot) {
          final profile =
              snapshot.data ?? Profile(client.userID, Uri.parse(''));
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StatusView(
                  status: status,
                  avatarUrl: profile.avatarUrl,
                  displayname: profile.displayname,
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
                        Avatar(profile.avatarUrl, profile.displayname),
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
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(80),
                    ),
                    padding: EdgeInsets.all(2),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 6.0, top: 0.0, right: 6.0),
                    child: Text(
                      profile.displayname.trim().split(' ').first,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2.color,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
