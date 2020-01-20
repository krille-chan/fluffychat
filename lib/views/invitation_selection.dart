import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'chat_list.dart';

class InvitationSelection extends StatelessWidget {
  final Room room;
  const InvitationSelection(this.room, {Key key}) : super(key: key);

  Future<List<User>> getContacts(BuildContext context) async {
    final Client client = Matrix.of(context).client;
    List<User> participants = await room.requestParticipants();
    List<User> contacts = [];
    Map<String, bool> userMap = {};
    for (int i = 0; i < client.rooms.length; i++) {
      List<User> roomUsers = client.rooms[i].getParticipants();
      for (int j = 0; j < roomUsers.length; j++) {
        if (userMap[roomUsers[j].id] != true &&
            participants.indexWhere((u) => u.id == roomUsers[j].id) == -1) {
          contacts.add(roomUsers[j]);
        }
        userMap[roomUsers[j].id] = true;
      }
    }
    contacts.sort((a, b) => a
        .calcDisplayname()
        .toLowerCase()
        .compareTo(b.calcDisplayname().toLowerCase()));
    return contacts;
  }

  void inviteAction(BuildContext context, String id) async {
    final success = await Matrix.of(context).tryRequestWithLoadingDialog(
      room.invite(id),
    );
    if (success != false) {
      Toast.show(
        I18n.of(context).contactHasBeenInvitedToTheGroup,
        context,
        duration: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String groupName =
        room.name?.isEmpty ?? false ? I18n.of(context).group : room.name;
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(activeChat: room.id),
      secondScaffold: Scaffold(
          appBar: AppBar(
            title: Text(I18n.of(context).inviteContactToGroup(groupName)),
          ),
          body: FutureBuilder<List<User>>(
            future: getContacts(context),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<User> contacts = snapshot.data;
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
