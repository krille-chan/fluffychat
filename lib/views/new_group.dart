import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:flutter/material.dart';
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
    final MatrixState matrix = Matrix.of(context);
    Map<String, dynamic> params = {};
    if (publicGroup) {
      params["preset"] = "public_chat";
      params["visibility"] = "public";
      if (controller.text.isNotEmpty) {
        params["room_alias_name"] = controller.text;
      }
    } else {
      params["preset"] = "private_chat";
    }
    if (controller.text.isNotEmpty) params["name"] = controller.text;
    final String roomID =
        await SimpleDialogs(context).tryRequestWithLoadingDialog(
      matrix.client.createRoom(params: params),
    );
    Navigator.of(context).pop();
    if (roomID != null) {
      unawaited(
        Navigator.of(context).push(
          AppRoute.defaultRoute(
            context,
            ChatView(roomID),
          ),
        ),
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvitationSelection(
            matrix.client.getRoomById(roomID),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).createNewGroup),
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
                  labelText: I18n.of(context).optionalGroupName,
                  prefixIcon: Icon(Icons.people),
                  hintText: I18n.of(context).enterAGroupName),
            ),
          ),
          SwitchListTile(
            title: Text(I18n.of(context).groupIsPublic),
            value: publicGroup,
            onChanged: (bool b) => setState(() => publicGroup = b),
          ),
          Expanded(
            child: Image.asset("assets/new_group_wallpaper.png"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => submitAction(context),
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
