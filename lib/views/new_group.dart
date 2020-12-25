import 'package:famedlysdk/matrix_api.dart' as api;
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:pedantic/pedantic.dart';

import 'chat.dart';
import 'chat_list.dart';
import 'invitation_selection.dart';

class NewGroupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(),
      secondScaffold: _NewGroup(),
    );
  }
}

class _NewGroup extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<_NewGroup> {
  TextEditingController controller = TextEditingController();
  bool publicGroup = false;

  void submitAction(BuildContext context) async {
    final matrix = Matrix.of(context);
    final roomID = await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.createRoom(
        preset: publicGroup
            ? api.CreateRoomPreset.public_chat
            : api.CreateRoomPreset.private_chat,
        visibility: publicGroup ? api.Visibility.public : null,
        roomAliasName:
            publicGroup && controller.text.isNotEmpty ? controller.text : null,
        name: controller.text.isNotEmpty ? controller.text : null,
      ),
    );
    Navigator.of(context).pop();
    if (roomID != null) {
      unawaited(
        Navigator.of(context).push(
          AppRoute.defaultRoute(
            context,
            ChatView(roomID.result),
          ),
        ),
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvitationSelection(
            matrix.client.getRoomById(roomID.result),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).createNewGroup),
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              autofocus: true,
              autocorrect: false,
              textInputAction: TextInputAction.go,
              onSubmitted: (s) => submitAction(context),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: L10n.of(context).optionalGroupName,
                  prefixIcon: Icon(Icons.people_outlined),
                  hintText: L10n.of(context).enterAGroupName),
            ),
          ),
          SwitchListTile(
            title: Text(L10n.of(context).groupIsPublic),
            value: publicGroup,
            onChanged: (bool b) => setState(() => publicGroup = b),
          ),
          Expanded(
            child: Image.asset('assets/new_group_wallpaper.png'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => submitAction(context),
        child: Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
