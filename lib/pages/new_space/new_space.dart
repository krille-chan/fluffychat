import 'dart:developer';

import 'package:fluffychat/pages/new_space/new_space_view.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/pages/class_settings/p_class_widgets/room_rules_editor.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/class_chat_power_levels.dart';
import 'package:fluffychat/pangea/utils/class_code.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/widgets/class/add_space_toggles.dart';
import 'package:fluffychat/pangea/widgets/space/class_settings.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

class NewSpace extends StatefulWidget {
  const NewSpace({super.key});

  @override
  NewSpaceController createState() => NewSpaceController();
}

class NewSpaceController extends State<NewSpace> {
  TextEditingController controller = TextEditingController();
  // #Pangea
  // bool publicGroup = false;
  bool publicGroup = true;
  final GlobalKey<RoomRulesState> rulesEditorKey = GlobalKey<RoomRulesState>();
  final GlobalKey<AddToSpaceState> addToSpaceKey = GlobalKey<AddToSpaceState>();
  final GlobalKey<ClassSettingsState> classSettingsKey =
      GlobalKey<ClassSettingsState>();
  //Pangea#

  void setPublicGroup(bool b) => setState(() => publicGroup = b);

  // #Pangea
  bool newClassMode = true;

  //in initState, set newClassMode to true if parameter "newClass" is true
  //use Vrouter
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      newClassMode =
          GoRouterState.of(context).pathParameters['newexchange'] != 'exchange';
      setState(() {});
    });
  }

  List<StateEvent> get initialState {
    final events = <StateEvent>[];

    events.add(
      StateEvent(
        type: EventTypes.RoomPowerLevels,
        stateKey: '',
        content: {
          'events': {
            PangeaEventTypes.studentAnalyticsSummary: 0,
            EventTypes.spaceChild: 0,
          },
          'users_default': 0,
          'users': {
            Matrix.of(context).client.userID:
                ClassDefaultValues.powerLevelOfAdmin,
          },
        },
      ),
    );

    if (rulesEditorKey.currentState?.rules != null) {
      events.add(rulesEditorKey.currentState!.rules.toStateEvent);
    } else {
      debugger(when: kDebugMode);
    }
    if (classSettingsKey.currentState != null) {
      events.add(classSettingsKey.currentState!.classSettings.toStateEvent);
    } else {
      debugger(when: kDebugMode && newClassMode);
    }

    return events;
  }
  //Pangea#

  void submitAction([_]) async {
    final matrix = Matrix.of(context);
    // #Pangea
    if (rulesEditorKey.currentState == null) {
      debugger(when: kDebugMode);
      return;
    }
    if (classSettingsKey.currentState != null &&
        classSettingsKey.currentState!.sameLanguages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.noIdenticalLanguages),
        ),
      );
      return;
    }
    if (controller.text.isEmpty) {
      final String warning = newClassMode
          ? L10n.of(context)!.emptyClassNameWarning
          : L10n.of(context)!.emptyExchangeNameWarning;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(warning)),
      );
      return;
    }
    if (newClassMode) {
      final int? languageLevel =
          classSettingsKey.currentState!.classSettings.languageLevel;
      if (languageLevel == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context)!.languageLevelWarning)),
        );
        return;
      }
    }
    //Pangea#
    final roomID = await showFutureLoadingDialog(
      context: context,
      // #Pangea
      // future: () async => matrix.client.createRoom(
      future: () async {
        final roomId = await matrix.client.createRoom(
          initialState: initialState,
          //Pangea#
          preset: publicGroup
              ? sdk.CreateRoomPreset.publicChat
              : sdk.CreateRoomPreset.privateChat,
          creationContent: {'type': RoomCreationTypes.mSpace},
          visibility: publicGroup ? sdk.Visibility.public : null,
          // #Pangea
          // roomAliasName: publicGroup && controller.text.isNotEmpty
          //     ? controller.text.trim().toLowerCase().replaceAll(' ', '_')
          //     : null,
          powerLevelContentOverride: addToSpaceKey.currentState != null
              ? await ClassChatPowerLevels.powerLevelOverrideForClassChat(
                  context,
                  addToSpaceKey.currentState!.parents
                      .map((suggestionStatus) => suggestionStatus.room)
                      .toList(),
                )
              : null,
          roomAliasName: ClassCodeUtil.generateClassCode(),
          // Pangea#
          name: controller.text.isNotEmpty ? controller.text : null,
        );
        // #Pangea
        Room? room = Matrix.of(context).client.getRoomById(roomId);

        final List<Future<dynamic>> futures = [
          Matrix.of(context).client.waitForRoomInSync(roomId, join: true),
        ];
        if (addToSpaceKey.currentState != null) {
          futures.add(addToSpaceKey.currentState!.addSpaces(roomId));
        }
        await Future.wait(futures);

        room = Matrix.of(context).client.getRoomById(roomId);

        final newChatRoomId = await Matrix.of(context).client.createGroupChat(
              enableEncryption: false,
              preset: sdk.CreateRoomPreset.publicChat,
              groupName:
                  '${controller.text}: ${L10n.of(context)!.classWelcomeChat}',
            );
        GoogleAnalytics.createChat(newChatRoomId);

        room!.setSpaceChild(newChatRoomId, suggested: true);
        newClassMode
            ? GoogleAnalytics.addParent(
                newChatRoomId,
                room.classCode,
              )
            : GoogleAnalytics.addChatToExchange(
                newChatRoomId,
                room.classCode,
              );

        GoogleAnalytics.createClass(room.name, room.classCode);
        try {
          await room.invite(BotName.byEnvironment);
        } catch (err) {
          ErrorHandler.logError(
            e: "Failed to invite pangea bot to space ${room.id}",
          );
        }

        return roomId;
      },
      title: L10n.of(context)!.creatingSpacePleaseWait,
      onError: (exception) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(e: exception);
        return exception.toString();
      },
      // Pangea#
    );

    // #Pangea
    if (roomID.result == null) return;
    MatrixState.pangeaController.classController
        .setActiveSpaceIdInChatListController(roomID.result!);

    if (roomID.error == null) {
      context.go('/spaces/${roomID.result!}');
    }
    // if (roomID.error == null) {
    //   context.go('/rooms/${roomID.result!}');
    // }
    // Pangea#
  }

  // #Pangea
  //toggle newClassMode
  void toggleClassMode(bool newValue) {
    setState(() => newClassMode = newValue);
  }
  // Pangea#

  @override
  Widget build(BuildContext context) => NewSpaceView(this);
}
