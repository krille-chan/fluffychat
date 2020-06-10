import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:famedlysdk/matrix_api.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

import 'chat_list.dart';

class InvitationSelection extends StatefulWidget {
  final Room room;
  const InvitationSelection(this.room, {Key key}) : super(key: key);

  @override
  _InvitationSelectionState createState() => _InvitationSelectionState();
}

class _InvitationSelectionState extends State<InvitationSelection> {
  TextEditingController controller = TextEditingController();
  String currentSearchTerm;
  bool loading = false;
  List<Profile> foundProfiles = [];
  Timer coolDown;

  Future<List<User>> getContacts(BuildContext context) async {
    var client2 = Matrix.of(context).client;
    final client = client2;
    var participants = await widget.room.requestParticipants();
    participants.removeWhere(
      (u) => ![Membership.join, Membership.invite].contains(u.membership),
    );
    var contacts = <User>[];
    var userMap = <String, bool>{};
    for (var i = 0; i < client.rooms.length; i++) {
      var roomUsers = client.rooms[i].getParticipants();

      for (var j = 0; j < roomUsers.length; j++) {
        if (userMap[roomUsers[j].id] != true &&
            participants.indexWhere((u) => u.id == roomUsers[j].id) == -1) {
          contacts.add(roomUsers[j]);
        }
        userMap[roomUsers[j].id] = true;
      }
    }
    contacts.sort(
      (a, b) => a.calcDisplayname().toLowerCase().compareTo(
            b.calcDisplayname().toLowerCase(),
          ),
    );
    return contacts;
  }

  void inviteAction(BuildContext context, String id) async {
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      widget.room.invite(id),
    );
    if (success != false) {
      BotToast.showText(text: L10n.of(context).contactHasBeenInvitedToTheGroup);
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
    coolDown?.cancel();
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
    if (response == false || (response?.results == null)) return;
    setState(() {
      foundProfiles = List<Profile>.from(response.results);
      if ('@$text'.isValidMatrixId &&
          foundProfiles.indexWhere((profile) => '@$text' == profile.userId) ==
              -1) {
        setState(() => foundProfiles = [
              Profile.fromJson({'user_id': '@$text'}),
            ]);
      }
      foundProfiles.removeWhere((profile) =>
          widget.room
              .getParticipants()
              .indexWhere((u) => u.id == profile.userId) !=
          -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupName = widget.room.name?.isEmpty ?? false
        ? L10n.of(context).group
        : widget.room.name;
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(activeChat: widget.room.id),
      secondScaffold: Scaffold(
          appBar: AppBar(
            title: Text(L10n.of(context).inviteContact),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(92),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.search,
                  onChanged: (String text) =>
                      searchUserWithCoolDown(context, text),
                  onSubmitted: (String text) => searchUser(context, text),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixText: '@',
                    hintText: L10n.of(context).username,
                    labelText: L10n.of(context).inviteContactToGroup(groupName),
                    suffixIcon: loading
                        ? Container(
                            padding: const EdgeInsets.all(8.0),
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(),
                          )
                        : Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          body: foundProfiles.isNotEmpty
              ? ListView.builder(
                  itemCount: foundProfiles.length,
                  itemBuilder: (BuildContext context, int i) => ListTile(
                    leading: Avatar(
                      foundProfiles[i].avatarUrl,
                      foundProfiles[i].displayname ?? foundProfiles[i].userId,
                    ),
                    title: Text(
                      foundProfiles[i].displayname ??
                          foundProfiles[i].userId.localpart,
                    ),
                    subtitle: Text(foundProfiles[i].userId),
                    onTap: () => inviteAction(context, foundProfiles[i].userId),
                  ),
                )
              : FutureBuilder<List<User>>(
                  future: getContacts(context),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var contacts = snapshot.data;
                    return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (BuildContext context, int i) => ListTile(
                        leading: Avatar(
                          contacts[i].avatarUrl,
                          contacts[i].calcDisplayname(),
                        ),
                        title: Text(contacts[i].calcDisplayname()),
                        subtitle: Text(contacts[i].id),
                        onTap: () => inviteAction(context, contacts[i].id),
                      ),
                    );
                  },
                )),
    );
  }
}
