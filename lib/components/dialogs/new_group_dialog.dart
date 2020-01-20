import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:fluffychat/views/invitation_selection.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

import '../matrix.dart';

class NewGroupDialog extends StatefulWidget {
  @override
  _NewGroupDialogState createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<NewGroupDialog> {
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
    final String roomID = await matrix.tryRequestWithLoadingDialog(
      matrix.client.createRoom(params: params),
    );
    Navigator.of(context).pop();
    if (roomID != null) {
      unawaited(
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Chat(roomID);
          }),
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
    return AlertDialog(
      title: Text(I18n.of(context).createNewGroup),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: controller,
            autocorrect: false,
            textInputAction: TextInputAction.go,
            onSubmitted: (s) => submitAction(context),
            decoration: InputDecoration(
                labelText: I18n.of(context).optionalGroupName,
                icon: Icon(Icons.people),
                hintText: I18n.of(context).enterAGroupName),
          ),
          SwitchListTile(
            title: Text(I18n.of(context).groupIsPublic),
            value: publicGroup,
            onChanged: (bool b) => setState(() => publicGroup = b),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(I18n.of(context).close.toUpperCase(),
              style: TextStyle(color: Colors.blueGrey)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(I18n.of(context).create.toUpperCase()),
          onPressed: () => submitAction(context),
        ),
      ],
    );
  }
}
