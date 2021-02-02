import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../utils/string_color.dart';
import '../../utils/date_time_extension.dart';
import '../matrix.dart';

class StatusListTile extends StatelessWidget {
  final Status status;

  const StatusListTile({Key key, @required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final text = status.message;
    final isImage = text.startsWith('mxc://') && text.split(' ').length == 1;
    return FutureBuilder<Profile>(
        future: Matrix.of(context).client.getProfileFromUserId(status.senderId),
        builder: (context, snapshot) {
          final displayname =
              snapshot.data?.displayname ?? status.senderId.localpart;
          final avatarUrl = snapshot.data?.avatarUrl;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Avatar(avatarUrl, displayname),
                title: Text(
                  displayname,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(status.dateTime.localizedTime(context),
                    style: TextStyle(fontSize: 14)),
                trailing: Matrix.of(context).client.userID == status.senderId
                    ? null
                    : PopupMenuButton(
                        onSelected: (_) => AdaptivePageLayout.of(context)
                            .pushNamed('/settings/ignore',
                                arguments: status.senderId),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            child: Text(L10n.of(context).ignore),
                            value: 'ignore',
                          ),
                        ],
                      ),
              ),
              isImage
                  ? CachedNetworkImage(
                      imageUrl: Uri.parse(text).getThumbnail(
                        Matrix.of(context).client,
                        width: 360,
                        height: 360,
                        method: ThumbnailMethod.scale,
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Container(
                      height: 256,
                      color: text.color,
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(CupertinoIcons.chat_bubble),
                      onPressed:
                          Matrix.of(context).client.userID == status.senderId
                              ? null
                              : () async {
                                  final result = await showFutureLoadingDialog(
                                    context: context,
                                    future: () => User(
                                      status.senderId,
                                      room: Room(
                                          id: '',
                                          client: Matrix.of(context).client),
                                    ).startDirectChat(),
                                  );
                                  if (result.error == null) {
                                    await AdaptivePageLayout.of(context)
                                        .pushNamed('/rooms/${result.result}');
                                  }
                                },
                    ),
                    IconButton(
                      icon: Icon(Icons.ios_share),
                      onPressed: () => AdaptivePageLayout.of(context)
                          .pushNamed('/newstatus', arguments: status.message),
                    ),
                    IconButton(
                      icon: Icon(Icons.share_outlined),
                      onPressed: () => FluffyShare.share(
                        '$displayname: ${status.message}',
                        context,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outlined),
                      onPressed: () => showFutureLoadingDialog(
                        context: context,
                        future: () => Matrix.of(context)
                            .removeStatusOfUser(status.senderId),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
