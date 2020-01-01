import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';

import '../matrix.dart';

class NewPrivateChatDialog extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  void submitAction(BuildContext context) async {
    if (controller.text.isEmpty) return;
    final MatrixState matrix = Matrix.of(context);
    final User user = User(
      "@" + controller.text,
      room: Room(id: "", client: matrix.client),
    );
    final String roomID =
        await matrix.tryRequestWithLoadingDialog(user.startDirectChat());
    Navigator.of(context).pop();

    if (roomID != null)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Chat(roomID)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New private chat"),
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
                labelText: "Enter a username",
                icon: Icon(Icons.account_circle),
                prefixText: "@",
                hintText: "username:homeserver"),
          ),
          SizedBox(height: 16),
          Text(
            "Your username is ${Matrix.of(context).client.userID}",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
            ),
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
          child: Text("Continue".toUpperCase()),
          onPressed: () => submitAction(context),
        ),
      ],
    );
  }
}
