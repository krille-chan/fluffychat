import 'package:flutter/material.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/settings_stories/settings_stories_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/matrix_sdk_extensions/client_stories_extension.dart';

class SettingsStories extends StatefulWidget {
  const SettingsStories({Key? key}) : super(key: key);

  @override
  SettingsStoriesController createState() => SettingsStoriesController();
}

class SettingsStoriesController extends State<SettingsStories> {
  final Map<User, bool> users = {};

  Room? _storiesRoom;

  Future<void>? loadUsers;

  bool noStoriesRoom = false;

  Future<void> toggleUser(User user) async {
    final room = _storiesRoom;
    if (room == null) return;

    if (users[user] ?? false) {
      // Kick user from stories room and add to block list
      final blockList = room.client.storiesBlockList;
      blockList.add(user.id);
      await showFutureLoadingDialog(
        context: context,
        future: () async {
          await user.kick();
          await room.client.setStoriesBlockList(blockList.toSet().toList());
          setState(() {
            users[user] = false;
          });
        },
      );
      return;
    }

    // Invite user to stories room and remove from block list
    final blockList = room.client.storiesBlockList;
    blockList.remove(user.id);
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        await room.client.setStoriesBlockList(blockList);
        await room.invite(user.id);
        setState(() {
          users[user] = true;
        });
      },
    );
    return;
  }

  Future<void> _loadUsers() async {
    final room =
        _storiesRoom = await Matrix.of(context).client.getStoriesRoom(context);
    if (room == null) {
      noStoriesRoom = true;
      return;
    }
    final users = await room.requestParticipants();
    users.removeWhere((u) => u.id == room.client.userID);
    final contacts = Matrix.of(context)
        .client
        .contacts
        .where((contact) => !users.any((u) => u.id == contact.id));
    for (final user in contacts) {
      this.users[user] = false;
    }
    for (final user in users) {
      this.users[user] = true;
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        loadUsers = _loadUsers();
      });
    });
  }

  @override
  Widget build(BuildContext context) => SettingsStoriesView(this);
}
