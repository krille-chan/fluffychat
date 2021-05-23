import 'package:famedlysdk/famedlysdk.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import '../avatar.dart';
import '../matrix.dart';

class PublicRoomListItem extends StatelessWidget {
  final PublicRoom publicRoomEntry;

  const PublicRoomListItem(this.publicRoomEntry, {Key key}) : super(key: key);

  void joinAction(BuildContext context) async {
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => _joinRoomAndWait(context),
    );
    if (success.error == null) {
      VRouter.of(context).pushNamed('/rooms/${success.result}');
    }
  }

  Future<String> _joinRoomAndWait(BuildContext context) async {
    final roomId =
        await Matrix.of(context).client.joinRoom(publicRoomEntry.roomId);
    if (Matrix.of(context).client.getRoomById(roomId) == null) {
      await Matrix.of(context)
          .client
          .onRoomUpdate
          .stream
          .firstWhere((r) => r.id == roomId);
    }
    return roomId;
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
            : publicRoomEntry.numJoinedMembers == null
                ? L10n.of(context).joinRoom
                : L10n.of(context).countParticipants(
                    publicRoomEntry.numJoinedMembers.toString()),
        maxLines: 1,
      ),
      onTap: () => joinAction(context),
    );
  }
}
