import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;

import 'package:fluffychat/pages/new_group/new_group_view.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewGroup extends StatefulWidget {
  const NewGroup({super.key});

  @override
  NewGroupController createState() => NewGroupController();
}

class NewGroupController extends State<NewGroup> {
  TextEditingController nameController = TextEditingController();

  TextEditingController topicController = TextEditingController();

  bool publicGroup = false;
  bool groupCanBeFound = true;

  Uint8List? avatar;

  Uri? avatarUrl;

  Object? error;

  bool loading = false;

  void setPublicGroup(bool b) => setState(() => publicGroup = b);

  void setGroupCanBeFound(bool b) => setState(() => groupCanBeFound = b);

  void selectPhoto() async {
    final photo = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    setState(() {
      avatarUrl = null;
      avatar = photo?.files.singleOrNull?.bytes;
    });
  }

  void submitAction([_]) async {
    final client = Matrix.of(context).client;

    try {
      setState(() {
        loading = true;
        error = null;
      });

      final avatar = this.avatar;
      avatarUrl ??= avatar == null ? null : await client.uploadContent(avatar);

      if (!mounted) return;

      final roomId = await client.createGroupChat(
        visibility:
            publicGroup ? sdk.Visibility.public : sdk.Visibility.private,
        preset: publicGroup
            ? sdk.CreateRoomPreset.publicChat
            : sdk.CreateRoomPreset.privateChat,
        groupName: nameController.text.isNotEmpty ? nameController.text : null,
        initialState: [
          if (topicController.text.isNotEmpty)
            sdk.StateEvent(
              type: sdk.EventTypes.RoomTopic,
              content: {'topic': topicController.text},
            ),
          if (avatar != null)
            sdk.StateEvent(
              type: sdk.EventTypes.RoomAvatar,
              content: {'url': avatarUrl.toString()},
            ),
        ],
      );
      if (!mounted) return;
      if (publicGroup && groupCanBeFound) {
        await client.setRoomVisibilityOnDirectory(
          roomId,
          visibility: sdk.Visibility.public,
        );
      }
      context.go('/rooms/$roomId/invite');
    } catch (e, s) {
      sdk.Logs().d('Unable to create group', e, s);
      setState(() {
        error = e;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => NewGroupView(this);
}
