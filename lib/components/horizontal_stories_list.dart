import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import '../utils/client_presence_extension.dart';
import '../utils/presence_extension.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'avatar.dart';

class HorizontalStoriesList extends StatefulWidget {
  final String searchQuery;

  const HorizontalStoriesList({Key key, this.searchQuery = ''})
      : super(key: key);
  @override
  _HorizontalStoriesListState createState() => _HorizontalStoriesListState();
}

class _HorizontalStoriesListState extends State<HorizontalStoriesList> {
  StreamSubscription _onSync;

  @override
  void dispose() {
    _onSync?.cancel();
    super.dispose();
  }

  DateTime _lastSetState = DateTime.now();
  Timer _coolDown;

  void _updateView() {
    _lastSetState = DateTime.now();
    setState(() => null);
  }

  static const double height = 68.0;

  @override
  Widget build(BuildContext context) {
    _onSync ??= Matrix.of(context).client.onSync.stream.listen((_) {
      if (DateTime.now().millisecondsSinceEpoch -
              _lastSetState.millisecondsSinceEpoch <
          1000) {
        _coolDown?.cancel();
        _coolDown = Timer(Duration(seconds: 1), _updateView);
      } else {
        _updateView();
      }
    });
    final contactList = Matrix.of(context)
        .client
        .contactList
        .where((p) =>
            p.senderId.toLowerCase().contains(widget.searchQuery.toLowerCase()))
        .toList();
    return AnimatedContainer(
      height: height,
      duration: Duration(milliseconds: 300),
      child: contactList.isEmpty
          ? null
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: contactList.length,
              itemBuilder: (context, i) =>
                  _StoriesListTile(story: contactList[i]),
            ),
    );
  }
}

class _StoriesListTile extends StatelessWidget {
  final Presence story;

  const _StoriesListTile({
    Key key,
    @required this.story,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final hasStatusMessage = story.presence.statusMsg?.isNotEmpty ?? false;
    return FutureBuilder<Profile>(
        future: Matrix.of(context).client.getProfileFromUserId(story.senderId),
        builder: (context, snapshot) {
          final displayname =
              snapshot.data?.displayname ?? story.senderId.localpart;
          final avatarUrl = snapshot.data?.avatarUrl;
          return Container(
            width: Avatar.defaultSize + 32,
            height: _HorizontalStoriesListState.height,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                if (story.senderId == Matrix.of(context).client.userID) {
                  await showOkAlertDialog(
                    context: context,
                    title: displayname,
                    message: story.presence.statusMsg,
                    okLabel: L10n.of(context).close,
                  );
                  return;
                }
                if (hasStatusMessage) {
                  if (OkCancelResult.ok !=
                      await showOkCancelAlertDialog(
                        context: context,
                        title: displayname,
                        message: story.presence.statusMsg,
                        okLabel: L10n.of(context).sendAMessage,
                        cancelLabel: L10n.of(context).close,
                      )) {
                    return;
                  }
                }
                final roomId = await Matrix.of(context)
                    .client
                    .startDirectChat(story.senderId);
                await AdaptivePageLayout.of(context)
                    .pushNamedAndRemoveUntilIsFirst('/rooms/${roomId}');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Avatar.defaultSize,
                    height: Avatar.defaultSize,
                    child: Stack(
                      children: [
                        Center(child: Avatar(avatarUrl, displayname)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.circle,
                            color: story.color,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(displayname.split(' ').first,
                      style: TextStyle(
                        fontWeight: hasStatusMessage ? FontWeight.bold : null,
                        color: hasStatusMessage
                            ? Theme.of(context).accentColor
                            : null,
                      )),
                ],
              ),
            ),
          );
        });
  }
}
