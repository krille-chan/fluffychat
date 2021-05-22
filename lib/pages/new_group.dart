import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart' as sdk;
import 'package:fluffychat/pages/views/new_group_ui.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class NewGroup extends StatefulWidget {
  @override
  NewGroupController createState() => NewGroupController();
}

class NewGroupController extends State<NewGroup> {
  TextEditingController controller = TextEditingController();
  bool publicGroup = false;

  void setPublicGroup(bool b) => setState(() => publicGroup = b);

  void submitAction([_]) async {
    final matrix = Matrix.of(context);
    final roomID = await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.createRoom(
        preset: publicGroup
            ? sdk.CreateRoomPreset.public_chat
            : sdk.CreateRoomPreset.private_chat,
        visibility: publicGroup ? sdk.Visibility.public : null,
        roomAliasName: publicGroup && controller.text.isNotEmpty
            ? controller.text.trim().toLowerCase().replaceAll(' ', '_')
            : null,
        name: controller.text.isNotEmpty ? controller.text : null,
      ),
    );
    AdaptivePageLayout.of(context).popUntilIsFirst();
    if (roomID != null) {
      await AdaptivePageLayout.of(context).pushNamed('/rooms/${roomID.result}');
      await AdaptivePageLayout.of(context)
          .pushNamed('/rooms/${roomID.result}/invite');
    }
  }

  @override
  Widget build(BuildContext context) => NewGroupUI(this);
}
