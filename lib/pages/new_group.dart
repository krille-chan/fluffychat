import 'package:matrix/matrix.dart' as sdk;
import 'package:fluffychat/pages/views/new_group_view.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class NewGroup extends StatefulWidget {
  @override
  NewGroupController createState() => NewGroupController();
}

class NewGroupController extends State<NewGroup> {
  TextEditingController controller = TextEditingController();
  bool publicGroup = false;

  void setPublicGroup(bool b) => setState(() => publicGroup = b);

  void submitAction([_]) async {
    final client = Matrix.of(context).client;
    final roomID = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final roomId = await client.createRoom(
          preset: publicGroup
              ? sdk.CreateRoomPreset.publicChat
              : sdk.CreateRoomPreset.privateChat,
          visibility: publicGroup ? sdk.Visibility.public : null,
          roomAliasName: publicGroup && controller.text.isNotEmpty
              ? controller.text.trim().toLowerCase().replaceAll(' ', '_')
              : null,
          name: controller.text.isNotEmpty ? controller.text : null,
        );
        if (client.getRoomById(roomId) == null) {
          await client.onSync.stream.firstWhere(
              (sync) => sync.rooms?.join?.containsKey(roomId) ?? false);
        }
        if (!publicGroup && client.encryptionEnabled) {
          await client.getRoomById(roomId).enableEncryption();
        }
        return roomId;
      },
    );
    if (roomID.error == null) {
      VRouter.of(context).toSegments(['rooms', roomID.result, 'invite']);
    }
  }

  @override
  Widget build(BuildContext context) => NewGroupView(this);
}
