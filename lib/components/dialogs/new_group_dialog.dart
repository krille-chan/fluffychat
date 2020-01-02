import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';

import '../matrix.dart';

class NewGroupDialog extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  void submitAction(BuildContext context) async {
    final MatrixState matrix = Matrix.of(context);
    Map<String, dynamic> params = {};
    if (controller.text.isNotEmpty) params["name"] = controller.text;
    final String roomID = await matrix.tryRequestWithLoadingDialog(
      matrix.client.createRoom(params: params),
    );
    Navigator.of(context).pop();
    if (roomID != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Chat(roomID)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create new group"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: controller,
            autofocus: true,
            autocorrect: false,
            textInputAction: TextInputAction.go,
            onSubmitted: (s) => submitAction(context),
            decoration: InputDecoration(
                labelText: "Group name",
                icon: Icon(Icons.people),
                hintText: "Enter a group name"),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Close".toUpperCase(),
              style: TextStyle(color: Colors.blueGrey)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Create".toUpperCase()),
          onPressed: () => submitAction(context),
        ),
      ],
    );
  }
}
