import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/pages/new_space/new_space_view.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/pages/class_settings/p_class_widgets/room_capacity_button.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/class_chat_power_levels.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/utils/space_code.dart';
import 'package:fluffychat/pangea/widgets/class/add_space_toggles.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
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
  // #Pangea
  // bool publicGroup = false;
  bool publicGroup = true;
  // final GlobalKey<RoomRulesState> rulesEditorKey = GlobalKey<RoomRulesState>();
  final GlobalKey<AddToSpaceState> addToSpaceKey = GlobalKey<AddToSpaceState>();
  // commenting out language settings in spaces for now
  // final GlobalKey<LanguageSettingsState> languageSettingsKey =
  //     GlobalKey<LanguageSettingsState>();
  final GlobalKey<RoomCapacityButtonState> addCapacityKey =
      GlobalKey<RoomCapacityButtonState>();

  //Pangea#
  bool loading = false;
  // #Pangea
  // String? nameError;
  // String? topicError;
  // Pangea#

  Uint8List? avatar;

  Uri? avatarUrl;

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

  void setPublicGroup(bool b) => setState(() => publicGroup = b);

  // #Pangea
  List<StateEvent> get initialState {
    final events = <StateEvent>[];

    events.add(
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
    );

    // commenting out pangea room rules in spaces for now
    // if (rulesEditorKey.currentState?.rules != null) {
    //   events.add(rulesEditorKey.currentState!.rules.toStateEvent);
    // } else {
    //   debugger(when: kDebugMode);
    // }
    // commenting out language settings in spaces for now
    // if (languageSettingsKey.currentState != null) {
    //   events
    //       .add(languageSettingsKey.currentState!.languageSettings.toStateEvent);
    // }

    return events;
  }
  //Pangea#

  void submitAction([_]) async {
    final client = Matrix.of(context).client;
    setState(() {
      // #Pangea
      // nameError = topicError = null;
      // Pangea#
    });
    // #Pangea
    // commenting out pangea room rules in spaces for now
    // if (rulesEditorKey.currentState == null) {
    //   debugger(when: kDebugMode);
    //   return;
    // }
    // commenting out language settings in spaces for now
    // if (languageSettingsKey.currentState != null &&
    //     languageSettingsKey.currentState!.sameLanguages) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(L10n.of(context)!.noIdenticalLanguages),
    //     ),
    //   );
    //   return;
    // }
    // final int? languageLevel =
    //     languageSettingsKey.currentState!.languageSettings.languageLevel;
    // if (languageLevel == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(L10n.of(context)!.languageLevelWarning)),
    //   );
    //   return;
    // }
    // Pangea#
    if (nameController.text.isEmpty) {
      setState(() {
        // #Pangea
        // nameError = L10n.of(context)!.pleaseChoose;
        final String warning = L10n.of(context)!.emptySpaceNameWarning;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(warning)),
        );
        // Pangea#
      });
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      final avatar = this.avatar;
      avatarUrl ??= avatar == null ? null : await client.uploadContent(avatar);
      final classCode = await SpaceCodeUtil.generateSpaceCode(client);
      if (classCode == null) {
        return;
      }
      final spaceId = await client.createRoom(
        // #Pangea
        // preset: publicGroup
        //     ? sdk.CreateRoomPreset.publicChat
        //     : sdk.CreateRoomPreset.privateChat,
        preset: sdk.CreateRoomPreset.publicChat,
        // Pangea#
        creationContent: {'type': RoomCreationTypes.mSpace},
        visibility: publicGroup ? sdk.Visibility.public : null,
        // #Pangea
        // roomAliasName: publicGroup
        //     ? nameController.text.trim().toLowerCase().replaceAll(' ', '_')
        //     : null,
        roomAliasName: classCode,
        // Pangea#
        name: nameController.text.trim(),
        topic: topicController.text.isEmpty ? null : topicController.text,
        // #Pangea
        // powerLevelContentOverride: {'events_default': 100},
        powerLevelContentOverride: addToSpaceKey.currentState != null
            ? await ClassChatPowerLevels.powerLevelOverrideForClassChat(
                context,
                addToSpaceKey.currentState!.parent,
              )
            : null,
        // Pangea#
        initialState: [
          // #Pangea
          ...initialState,
          // Pangea#
          if (avatar != null)
            sdk.StateEvent(
              type: sdk.EventTypes.RoomAvatar,
              content: {'url': avatarUrl.toString()},
            ),
          sdk.StateEvent(
            type: sdk.EventTypes.RoomJoinRules,
            content: {
              'join_rule': 'knock',
              'access_code': classCode,
            },
          ),
        ],
      );
      // #Pangea
      final List<Future<dynamic>> futures = [
        Matrix.of(context).client.waitForRoomInSync(spaceId, join: true),
      ];
      if (addToSpaceKey.currentState != null) {
        futures.add(addToSpaceKey.currentState!.addSpaces(spaceId));
      }
      await Future.wait(futures);

      final capacity = addCapacityKey.currentState?.capacity;
      final space = client.getRoomById(spaceId);
      if (capacity != null && space != null) {
        space.updateRoomCapacity(capacity);
      }

      final Room? room = Matrix.of(context).client.getRoomById(spaceId);
      if (room == null) {
        ErrorHandler.logError(
          e: 'Failed to get new space by id $spaceId',
        );
        MatrixState.pangeaController.classController
            .setActiveSpaceIdInChatListController(spaceId);
        return;
      }

      GoogleAnalytics.createClass(room.name, room.classCode);
      try {
        await room.invite(BotName.byEnvironment);
      } catch (err) {
        ErrorHandler.logError(
          e: "Failed to invite pangea bot to space ${room.id}",
        );
      }
      // Pangea#
      if (!mounted) return;
      // #Pangea
      // context.pop<String>(spaceId);
      MatrixState.pangeaController.classController
          .setActiveSpaceIdInChatListController(spaceId);
      // Pangea#
    } catch (e) {
      setState(() {
        // #Pangea
        // topicError = e.toLocalizedString(context);
        // Pangea#
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
    // TODO: Go to spaces
  }

  @override
  // #Pangea
  // Widget build(BuildContext context) => NewSpaceView(this);
  Widget build(BuildContext context) {
    return NewSpaceView(this);
  }
  // Pangea#
}
