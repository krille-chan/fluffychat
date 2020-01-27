import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../matrix.dart';

class NewPrivateChatDialog extends StatefulWidget {
  @override
  _NewPrivateChatDialogState createState() => _NewPrivateChatDialogState();
}

class _NewPrivateChatDialogState extends State<NewPrivateChatDialog> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String currentSearchTerm;
  Map<String, dynamic> foundProfile;
  Timer coolDown;
  bool get correctMxId =>
      foundProfile != null && foundProfile["user_id"] == "@$currentSearchTerm";

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
        MaterialPageRoute(builder: (context) => ChatView(roomID)),
      );
    }
  }

  void searchUserWithCoolDown(BuildContext context, String text) async {
    coolDown?.cancel();
    coolDown = Timer(
      Duration(seconds: 1),
      () => searchUser(context, text),
    );
  }

  void searchUser(BuildContext context, String text) async {
    if (text.isEmpty) {
      setState(() {
        foundProfile = null;
      });
    }
    currentSearchTerm = text;
    if (currentSearchTerm.isEmpty) return;
    if (loading) return;
    setState(() => loading = true);
    final MatrixState matrix = Matrix.of(context);
    final response = await matrix.tryRequestWithErrorToast(
      matrix.client.jsonRequest(
          type: HTTPType.POST,
          action: "/client/r0/user_directory/search",
          data: {
            "search_term": text,
            "limit": 1,
          }),
    );
    setState(() => loading = false);
    if (response == false ||
        !(response is Map) ||
        (response["results"]?.isEmpty ?? true)) return;
    setState(() {
      foundProfile = response["results"].first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String defaultDomain = Matrix.of(context).client.userID.split(":")[1];
    return AlertDialog(
      title: Text(I18n.of(context).newPrivateChat),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              autocorrect: false,
              onChanged: (String text) => searchUserWithCoolDown(context, text),
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (s) => submitAction(context),
              validator: (value) {
                if (value.isEmpty) {
                  return I18n.of(context).pleaseEnterAMatrixIdentifier;
                }
                final MatrixState matrix = Matrix.of(context);
                String mxid = "@" + controller.text.trim();
                if (mxid == matrix.client.userID) {
                  return I18n.of(context).youCannotInviteYourself;
                }
                if (!mxid.contains("@")) {
                  return I18n.of(context).makeSureTheIdentifierIsValid;
                }
                if (!mxid.contains(":")) {
                  return I18n.of(context).makeSureTheIdentifierIsValid;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: I18n.of(context).enterAUsername,
                icon: loading
                    ? Container(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 1),
                      )
                    : correctMxId
                        ? Avatar(
                            MxContent(foundProfile["avatar_url"] ?? ""),
                            foundProfile["display_name"] ??
                                foundProfile["user_id"],
                            size: 24,
                          )
                        : Icon(Icons.account_circle),
                prefixText: "@",
                hintText:
                    "${I18n.of(context).username.toLowerCase()}:$defaultDomain",
              ),
            ),
          ),
          if (foundProfile != null && !correctMxId)
            ListTile(
              onTap: () {
                setState(() {
                  controller.text =
                      currentSearchTerm = foundProfile["user_id"].substring(1);
                });
              },
              leading: Avatar(
                MxContent(foundProfile["avatar_url"] ?? ""),
                foundProfile["display_name"] ?? foundProfile["user_id"],
                //size: 24,
              ),
              contentPadding: EdgeInsets.all(0),
              title: Text(
                foundProfile["display_name"] ??
                    foundProfile["user_id"].split(":").first.substring(1),
                style: TextStyle(),
                maxLines: 1,
              ),
              subtitle: Text(
                foundProfile["user_id"],
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          if (foundProfile == null || correctMxId)
            ListTile(
              trailing: Icon(
                Icons.share,
                size: 16,
              ),
              contentPadding: EdgeInsets.all(0),
              onTap: () => Share.share(
                  "https://matrix.to/#/${Matrix.of(context).client.userID}"),
              title: Text(
                "${I18n.of(context).yourOwnUsername}:",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
              ),
              subtitle: Text(
                Matrix.of(context).client.userID,
              ),
            ),
          Divider(height: 1),
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
          child: Text(I18n.of(context).confirm.toUpperCase()),
          onPressed: () => submitAction(context),
        ),
      ],
    );
  }
}
