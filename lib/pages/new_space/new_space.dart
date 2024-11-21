import 'dart:typed_data';

import 'package:fluffychat/pages/new_space/new_space_view.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/utils/space_code.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

class NewSpace extends StatefulWidget {
  const NewSpace({super.key});

  @override
  NewSpaceController createState() => NewSpaceController();
}

class NewSpaceController extends State<NewSpace> {
  TextEditingController nameController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  bool publicGroup = false;
  // #Pangea
  bool spaceCanBeFound = true;
  // Pangea#
  bool loading = false;
  String? nameError;
  String? topicError;

  Uint8List? avatar;

  Uri? avatarUrl;

  void selectPhoto() async {
    final photo = await selectFiles(
      context,
      type: FileSelectorType.images,
    );
    final bytes = await photo.firstOrNull?.readAsBytes();
    setState(() {
      avatarUrl = null;
      avatar = bytes;
    });
  }

  // #Pangea
  void setSpaceCanBeFound(bool b) => setState(() => spaceCanBeFound = b);
  // Pangea#

  void setPublicGroup(bool b) => setState(() => publicGroup = b);

  // #Pangea
  List<StateEvent> initialState(String joinCode, bool publicGroup) {
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
            Matrix.of(context).client.userID:
                ClassDefaultValues.powerLevelOfAdmin,
          },
        },
      ),
      StateEvent(
        type: sdk.EventTypes.RoomJoinRules,
        content: {
          ModelKey.joinRule: publicGroup
              ? sdk.JoinRules.public.toString().replaceAll('JoinRules.', '')
              : sdk.JoinRules.invite.toString().replaceAll('JoinRules.', ''),
          ModelKey.accessCode: joinCode,
        },
      ),
    ];
  }
  //Pangea#

  void submitAction([_]) async {
    final client = Matrix.of(context).client;
    setState(() {
      nameError = topicError = null;
    });
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = L10n.of(context)!.pleaseChoose;
      });
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      final avatar = this.avatar;
      avatarUrl ??= avatar == null ? null : await client.uploadContent(avatar);
      // #Pangea
      final joinCode = await SpaceCodeUtil.generateSpaceCode(client);
      // Pangea#

      final spaceId = await client.createRoom(
        preset: publicGroup
            ? sdk.CreateRoomPreset.publicChat
            : sdk.CreateRoomPreset.privateChat,
        // #Pangea
        visibility: publicGroup && spaceCanBeFound
            ? sdk.Visibility.public
            : sdk.Visibility.private,
        // Pangea#
        creationContent: {'type': RoomCreationTypes.mSpace},
        roomAliasName: publicGroup
            ? nameController.text.trim().toLowerCase().replaceAll(' ', '_')
            : null,
        name: nameController.text.trim(),
        topic: topicController.text.isEmpty ? null : topicController.text,
        powerLevelContentOverride: {'events_default': 100},
        initialState: [
          // #Pangea
          ...initialState(joinCode, publicGroup),
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
      GoogleAnalytics.createClass(room.name, room.classCode);
      try {
        await room.invite(BotName.byEnvironment);
      } catch (err) {
        ErrorHandler.logError(
          e: "Failed to invite pangea bot to new space",
          data: {"spaceId": spaceId, "error": err},
        );
      }
      MatrixState.pangeaController.classController
          .setActiveSpaceIdInChatListController(spaceId);
      // Pangea#
      context.pop<String>(spaceId);
    } catch (e) {
      setState(() {
        topicError = e.toLocalizedString(context);
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
    // TODO: Go to spaces
  }

  @override
  Widget build(BuildContext context) => NewSpaceView(this);
}
