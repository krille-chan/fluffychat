import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';

import '../matrix.dart';

class NewPrivateChatDialog extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void submitAction(BuildContext context) async {
    if (controller.text.isEmpty) return;
    if (!_formKey.currentState.validate()) return;
    final MatrixState matrix = Matrix.of(context);

    if ("@" + controller.text.trim() == matrix.client.userID) return;

    final User user = User(
      "@" + controller.text.trim(),
      room: Room(id: "", client: matrix.client),
    );
    final String roomID =
        await matrix.tryRequestWithLoadingDialog(user.startDirectChat());
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
      title: Text("New private chat"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              autocorrect: false,
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (s) => submitAction(context),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a matrix identifier';
                }
                final MatrixState matrix = Matrix.of(context);
                String mxid = "@" + controller.text.trim();
                if (mxid == matrix.client.userID) {
                  return "You cannot invite yourself";
                }
                if(!mxid.contains("@")) {
                  return "Make sure the identifier is valid";
                }
                if(!mxid.contains(":")) {
                  return "Make sure the identifier is valid";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Enter a username",
                icon: Icon(Icons.account_circle),
                prefixText: "@",
                hintText: "username:homeserver",
              ),
            ),
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
