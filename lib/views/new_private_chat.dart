import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:famedlysdk/matrix_api.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'chat.dart';
import 'chat_list.dart';

class NewPrivateChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(),
      secondScaffold: _NewPrivateChat(),
    );
  }
}

class _NewPrivateChat extends StatefulWidget {
  @override
  _NewPrivateChatState createState() => _NewPrivateChatState();
}

class _NewPrivateChatState extends State<_NewPrivateChat> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String currentSearchTerm;
  List<Profile> foundProfiles = [];
  Timer coolDown;
  Profile get foundProfile =>
      foundProfiles.firstWhere((user) => user.userId == '@$currentSearchTerm',
          orElse: () => null);
  bool get correctMxId =>
      foundProfiles
          .indexWhere((user) => user.userId == '@$currentSearchTerm') !=
      -1;

  void submitAction(BuildContext context) async {
    if (controller.text.isEmpty) return;
    if (!_formKey.currentState.validate()) return;
    final matrix = Matrix.of(context);

    if ('@' + controller.text.trim() == matrix.client.userID) return;

    final user = User(
      '@' + controller.text.trim(),
      room: Room(id: '', client: matrix.client),
    );
    final String roomID = await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(user.startDirectChat());
    Navigator.of(context).pop();

    if (roomID != null) {
      await Navigator.of(context).push(
        AppRoute.defaultRoute(
          context,
          ChatView(roomID),
        ),
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
        foundProfiles = [];
      });
    }
    currentSearchTerm = text;
    if (currentSearchTerm.isEmpty) return;
    if (loading) return;
    setState(() => loading = true);
    final matrix = Matrix.of(context);
    final response = await SimpleDialogs(context).tryRequestWithErrorToast(
      matrix.client.api.searchUser(text, limit: 10),
    );
    setState(() => loading = false);
    if (response == false || (response?.results?.isEmpty ?? true)) return;
    setState(() {
      foundProfiles = List<Profile>.from(response.results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).newPrivateChat),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: controller,
                autofocus: true,
                autocorrect: false,
                onChanged: (String text) =>
                    searchUserWithCoolDown(context, text),
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (s) => submitAction(context),
                validator: (value) {
                  if (value.isEmpty) {
                    return L10n.of(context).pleaseEnterAMatrixIdentifier;
                  }
                  final matrix = Matrix.of(context);
                  var mxid = '@' + controller.text.trim();
                  if (mxid == matrix.client.userID) {
                    return L10n.of(context).youCannotInviteYourself;
                  }
                  if (!mxid.contains('@')) {
                    return L10n.of(context).makeSureTheIdentifierIsValid;
                  }
                  if (!mxid.contains(':')) {
                    return L10n.of(context).makeSureTheIdentifierIsValid;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: L10n.of(context).enterAUsername,
                  prefixIcon: loading
                      ? Container(
                          padding: const EdgeInsets.all(8.0),
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(),
                        )
                      : correctMxId
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Avatar(
                                foundProfile.avatarUrl,
                                foundProfile.displayname ?? foundProfile.userId,
                                size: 12,
                              ),
                            )
                          : Icon(Icons.account_circle),
                  prefixText: '@',
                  hintText: '${L10n.of(context).username.toLowerCase()}',
                ),
              ),
            ),
          ),
          Divider(height: 1),
          if (foundProfiles.isNotEmpty && !correctMxId)
            Expanded(
              child: ListView.builder(
                itemCount: foundProfiles.length,
                itemBuilder: (BuildContext context, int i) {
                  var foundProfile = foundProfiles[i];
                  return ListTile(
                    onTap: () {
                      setState(() {
                        controller.text = currentSearchTerm =
                            foundProfile.userId.substring(1);
                      });
                    },
                    leading: Avatar(
                      foundProfile.avatarUrl,
                      foundProfile.displayname ?? foundProfile.userId,
                      //size: 24,
                    ),
                    title: Text(
                      foundProfile.displayname ?? foundProfile.userId.localpart,
                      style: TextStyle(),
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      foundProfile.userId,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (foundProfiles.isEmpty || correctMxId)
            ListTile(
              trailing: Icon(
                Icons.share,
                size: 16,
              ),
              onTap: () => Share.share(L10n.of(context).inviteText(
                  Matrix.of(context).client.userID,
                  'https://matrix.to/#/${Matrix.of(context).client.userID}')),
              title: Text(
                '${L10n.of(context).yourOwnUsername}:',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              subtitle: Text(
                Matrix.of(context).client.userID,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          Divider(height: 1),
          if (foundProfiles.isEmpty || correctMxId)
            Expanded(
              child: Image.asset('assets/private_chat_wallpaper.png'),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => submitAction(context),
        child: Icon(Icons.arrow_forward),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
