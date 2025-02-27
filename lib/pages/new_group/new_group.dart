import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/new_group/new_group_view.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/pangea/spaces/utils/space_code.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewGroup extends StatefulWidget {
  final CreateGroupType createGroupType;
  const NewGroup({
    this.createGroupType = CreateGroupType.group,
    super.key,
  });

  @override
  NewGroupController createState() => NewGroupController();
}

class NewGroupController extends State<NewGroup> {
  TextEditingController nameController = TextEditingController();

  // #Pangea
  bool requiredCodeToJoin = false;
  // bool publicGroup = false;
  // Pangea#
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

  // #Pangea
  // void setPublicGroup(bool b) =>
  //     setState(() => publicGroup = groupCanBeFound = b);
  void setRequireCode(bool b) => setState(() => requiredCodeToJoin = b);
  // Pangea#

  void setGroupCanBeFound(bool b) => setState(() => groupCanBeFound = b);

  void selectPhoto() async {
    final photo = await selectFiles(
      context,
      type: FileSelectorType.images,
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
    final roomId = await Matrix.of(context).client.createGroupChat(
          // #Pangea
          // visibility:
          //     groupCanBeFound ? sdk.Visibility.public : sdk.Visibility.private,
          // preset: publicGroup
          //     ? sdk.CreateRoomPreset.publicChat
          //     : sdk.CreateRoomPreset.privateChat,
          preset: sdk.CreateRoomPreset.publicChat,
          visibility: sdk.Visibility.private,
          // Pangea#
          groupName:
              nameController.text.isNotEmpty ? nameController.text : null,
          initialState: [
            if (avatar != null)
              sdk.StateEvent(
                type: sdk.EventTypes.RoomAvatar,
                content: {'url': avatarUrl.toString()},
              ),
          ],
          // #Pangea
          enableEncryption: false,
          // Pangea#
        );
    if (!mounted) return;
    // #Pangea
    // if a timeout happened, don't redirect to the chat
    if (error != null) return;
    // Pangea#
    context.go('/rooms/$roomId/invite');
  }

  Future<void> _createSpace() async {
    if (!mounted) return;
    // #Pangea
    final client = Matrix.of(context).client;
    final joinCode = await SpaceCodeUtil.generateSpaceCode(client);
    // Pangea#
    final spaceId = await Matrix.of(context).client.createRoom(
          // #Pangea
          // preset: publicGroup
          //     ? sdk.CreateRoomPreset.publicChat
          //     : sdk.CreateRoomPreset.privateChat,
          // Pangea#
          creationContent: {'type': RoomCreationTypes.mSpace},
          // #Pangea
          // visibility: publicGroup ? sdk.Visibility.public : null,
          visibility:
              groupCanBeFound ? sdk.Visibility.public : sdk.Visibility.private,
          // roomAliasName: publicGroup
          //     ? nameController.text.trim().toLowerCase().replaceAll(' ', '_')
          //     : null,
          // Pangea#
          name: nameController.text.trim(),
          powerLevelContentOverride: {'events_default': 100},
          initialState: [
            // #Pangea
            ..._spaceInitialState(joinCode),
            // Pangea#
            if (avatar != null)
              sdk.StateEvent(
                type: sdk.EventTypes.RoomAvatar,
                content: {'url': avatarUrl.toString()},
              ),
          ],
        );
    if (!mounted) return;
    // #Pangea
    Room? room = client.getRoomById(spaceId);
    if (room == null) {
      await Matrix.of(context).client.waitForRoomInSync(spaceId);
      room = client.getRoomById(spaceId);
    }
    if (room == null) return;
    GoogleAnalytics.createClass(room.name, room.classCode(context));
    try {
      await room.invite(BotName.byEnvironment);
    } catch (err) {
      ErrorHandler.logError(
        e: "Failed to invite pangea bot to new space",
        data: {"spaceId": spaceId, "error": err},
      );
    }

    // if a timeout happened, don't redirect to the space
    if (error != null) return;
    MatrixState.pangeaController.classController
        .setActiveSpaceIdInChatListController(spaceId);
    // Pangea#
    context.pop<String>(spaceId);
  }

  // #Pangea
  List<StateEvent> _spaceInitialState(String joinCode) {
    return [
      StateEvent(
        type: EventTypes.RoomPowerLevels,
        stateKey: '',
        content: {
          'events': {
            EventTypes.SpaceChild: 0,
          },
          'users_default': 0,
          'users': {
            Matrix.of(context).client.userID: SpaceConstants.powerLevelOfAdmin,
          },
        },
      ),
      StateEvent(
        type: sdk.EventTypes.RoomJoinRules,
        content: {
          ModelKey.joinRule: requiredCodeToJoin
              ? sdk.JoinRules.knock.toString().replaceAll('JoinRules.', '')
              : sdk.JoinRules.public.toString().replaceAll('JoinRules.', ''),
          ModelKey.accessCode: joinCode,
        },
      ),
    ];
  }
  //Pangea#

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

      switch (createGroupType) {
        case CreateGroupType.group:
          // #Pangea
          // await _createGroup();
          await _createGroup().timeout(
            const Duration(
              seconds: AppConfig.roomCreationTimeoutSeconds,
            ),
          );
        // Pangea#
        case CreateGroupType.space:
          // #Pangea
          // await _createSpace();
          await _createSpace().timeout(
            const Duration(
              seconds: AppConfig.roomCreationTimeoutSeconds,
            ),
          );
        // Pangea#
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
  Widget build(BuildContext context) => NewGroupView(this);
}

enum CreateGroupType { group, space }
