import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../utils/app_route.dart';
import '../../views/chat.dart';
import '../avatar.dart';

class PublicRoomListItem extends StatelessWidget {
  final PublicRoomEntry publicRoomEntry;

  const PublicRoomListItem(this.publicRoomEntry, {Key key}) : super(key: key);

  void joinAction(BuildContext context) async {
    final success = await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(publicRoomEntry.join());
    if (success != false) {
      await Navigator.of(context).push(
        AppRoute.defaultRoute(
          context,
          ChatView(publicRoomEntry.roomId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTopic =
        publicRoomEntry.topic != null && publicRoomEntry.topic.isNotEmpty;
    return ListTile(
      leading: Avatar(
          publicRoomEntry.avatarUrl == null
              ? null
              : Uri.parse(publicRoomEntry.avatarUrl),
          publicRoomEntry.name),
      title: Text(hasTopic
          ? '${publicRoomEntry.name} (${publicRoomEntry.numJoinedMembers})'
          : publicRoomEntry.name),
      subtitle: Text(
        hasTopic
            ? publicRoomEntry.topic
            : L10n.of(context).countParticipants(
                publicRoomEntry.numJoinedMembers?.toString() ?? '0'),
        maxLines: 1,
      ),
      onTap: () => joinAction(context),
    );
  }
}
