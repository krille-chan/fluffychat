import 'dart:async';

import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class NewPrivateChat extends StatefulWidget {
  @override
  _NewPrivateChatState createState() => _NewPrivateChatState();
}

class _NewPrivateChatState extends State<NewPrivateChat> {
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
    controller.text = controller.text.replaceAll('@', '').trim();
    if (controller.text.isEmpty) return;
    if (!_formKey.currentState.validate()) return;
    final matrix = Matrix.of(context);

    if ('@' + controller.text == matrix.client.userID) return;

    final user = User(
      '@' + controller.text,
      room: Room(id: '', client: matrix.client),
    );
    final roomID = await showFutureLoadingDialog(
      context: context,
      future: () => user.startDirectChat(),
    );

    if (roomID.error == null) {
      await AdaptivePageLayout.of(context)
          .popAndPushNamed('/rooms/${roomID.result}');
    }
  }

  void searchUserWithCoolDown(BuildContext context) async {
    coolDown?.cancel();
    coolDown = Timer(
      Duration(milliseconds: 500),
      () => searchUser(context, controller.text),
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
    UserSearchResult response;
    try {
      response = await matrix.client.searchUser(text, limit: 10);
    } catch (_) {}
    setState(() => loading = false);
    if (response?.results?.isEmpty ?? true) return;
    setState(() {
      foundProfiles = List<Profile>.from(response.results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).newPrivateChat),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: controller,
                autofocus: true,
                autocorrect: false,
                onChanged: (String text) => searchUserWithCoolDown(context),
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
                          : Icon(Icons.account_circle_outlined),
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
              trailing: Icon(Icons.share_outlined),
              onTap: () => FluffyShare.share(
                  L10n.of(context).inviteText(Matrix.of(context).client.userID,
                      'https://matrix.to/#/${Matrix.of(context).client.userID}'),
                  context),
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
        child: Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
