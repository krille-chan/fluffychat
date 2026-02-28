import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/new_group/new_group_view.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewGroup extends StatefulWidget {
  final CreateGroupType createGroupType;
  final String? spaceId;
  const NewGroup({
    this.createGroupType = CreateGroupType.group,
    this.spaceId,
    super.key,
  });

  @override
  NewGroupController createState() => NewGroupController();
}

class NewGroupController extends State<NewGroup> {
  TextEditingController nameController = TextEditingController();

  bool publicGroup = false;
  bool groupCanBeFound = false;

  Uint8List? avatar;

  Uri? avatarUrl;

  Object? error;

  bool loading = false;

  CreateGroupType get createGroupType =>
      _createGroupType ?? widget.createGroupType;

  CreateGroupType? _createGroupType;

  void setCreateGroupType(Set<CreateGroupType> b) =>
      setState(() => _createGroupType = b.single);

  void setPublicGroup(bool b) =>
      setState(() => publicGroup = groupCanBeFound = b);

  void setGroupCanBeFound(bool b) => setState(() => groupCanBeFound = b);

  Future<void> selectPhoto() async {
    final photo = await selectFiles(
      context,
      type: FileType.image,
      allowMultiple: false,
    );
    final bytes = await photo.singleOrNull?.readAsBytes();

    setState(() {
      avatarUrl = null;
      avatar = bytes;
    });
  }

  Future<void> _createGroup() async {
    if (!mounted) return;
    final client = Matrix.of(context).client;

    final roomId = await client.createGroupChat(
      visibility: groupCanBeFound
          ? sdk.Visibility.public
          : sdk.Visibility.private,
      preset: publicGroup
          ? sdk.CreateRoomPreset.publicChat
          : sdk.CreateRoomPreset.privateChat,
      groupName: nameController.text.isNotEmpty ? nameController.text : null,
      initialState: [
        if (avatar != null)
          sdk.StateEvent(
            type: sdk.EventTypes.RoomAvatar,
            content: {'url': avatarUrl.toString()},
          ),
      ],
    );
    await _addToSpace(roomId);
    if (!mounted) return;

    context.go('/rooms/$roomId/invite');
  }

  Future<void> _createSpace() async {
    if (!mounted) return;
    final spaceId = await Matrix.of(context).client.createRoom(
      preset: publicGroup
          ? sdk.CreateRoomPreset.publicChat
          : sdk.CreateRoomPreset.privateChat,
      creationContent: {'type': RoomCreationTypes.mSpace},
      visibility: publicGroup ? sdk.Visibility.public : null,
      roomAliasName: publicGroup
          ? nameController.text.trim().toLowerCase().replaceAll(' ', '_')
          : null,
      name: nameController.text.trim(),
      powerLevelContentOverride: {'events_default': 100},
      initialState: [
        if (avatar != null)
          sdk.StateEvent(
            type: sdk.EventTypes.RoomAvatar,
            content: {'url': avatarUrl.toString()},
          ),
      ],
    );
    await _addToSpace(spaceId);
    if (!mounted) return;
    context.pop<String>(spaceId);
  }

  Future<void> _addToSpace(String roomId) async {
    final spaceId = widget.spaceId;
    if (spaceId != null) {
      final activeSpace = Matrix.of(context).client.getRoomById(spaceId);
      if (activeSpace == null) {
        throw Exception('Can not add group to space: Space not found $spaceId');
      }
      await activeSpace.postLoad();
      await activeSpace.setSpaceChild(roomId);
    }
  }

  Future<void> submitAction([_]) async {
    final client = Matrix.of(context).client;

    try {
      if (nameController.text.trim().isEmpty &&
          createGroupType == CreateGroupType.space) {
        setState(() => error = L10n.of(context).pleaseFillOut);
        return;
      }

      setState(() {
        loading = true;
        error = null;
      });

      final avatar = this.avatar;
      avatarUrl ??= avatar == null ? null : await client.uploadContent(avatar);

      if (!mounted) return;

      switch (createGroupType) {
        case CreateGroupType.group:
          await _createGroup();
        case CreateGroupType.space:
          await _createSpace();
      }
    } catch (e, s) {
      sdk.Logs().d('Unable to create group', e, s);
      setState(() {
        error = e;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    final spaceId = widget.spaceId;
    if (spaceId != null) {
      final space = Matrix.of(context).client.getRoomById(spaceId);
      publicGroup = space?.joinRules == JoinRules.public;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => NewGroupView(this);
}

enum CreateGroupType { group, space }
