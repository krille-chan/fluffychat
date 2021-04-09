import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';

import '../../app_config.dart';
import 'matrix.dart';

class UnreadBadgeBackButton extends StatelessWidget {
  final String roomId;

  const UnreadBadgeBackButton({
    Key key,
    @required this.roomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: BackButton()),
        StreamBuilder(
            stream: Matrix.of(context).client.onSync.stream,
            builder: (context, _) {
              final unreadCount = Matrix.of(context)
                  .client
                  .rooms
                  .where((r) =>
                      r.id != roomId &&
                      (r.isUnread || r.membership == Membership.invite))
                  .length;
              return unreadCount > 0
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(bottom: 4, right: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              BorderRadius.circular(AppConfig.borderRadius),
                        ),
                        child: Text(
                          '$unreadCount',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container();
            }),
      ],
    );
  }
}
