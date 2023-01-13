import 'package:flutter/material.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/new_space/new_space_view.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewSpace extends StatefulWidget {
  const NewSpace({Key? key}) : super(key: key);

  @override
  NewSpaceController createState() => NewSpaceController();
}

class NewSpaceController extends State<NewSpace> {
  TextEditingController controller = TextEditingController();
  bool publicGroup = false;

  void setPublicGroup(bool b) => setState(() => publicGroup = b);

  void submitAction([_]) async {
    final matrix = Matrix.of(context);
    final roomID = await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.createRoom(
        preset: publicGroup
            ? sdk.CreateRoomPreset.publicChat
            : sdk.CreateRoomPreset.privateChat,
        creationContent: {'type': RoomCreationTypes.mSpace},
        visibility: publicGroup ? sdk.Visibility.public : null,
        roomAliasName: publicGroup && controller.text.isNotEmpty
            ? controller.text.trim().toLowerCase().replaceAll(' ', '_')
            : null,
        name: controller.text.isNotEmpty ? controller.text : null,
      ),
    );
    if (roomID.error == null) {
      VRouter.of(context).toSegments(['spaces', roomID.result!]);
    }
  }

  @override
  Widget build(BuildContext context) => NewSpaceView(this);
}
