import 'dart:developer';

import 'package:fluffychat/pages/new_group/new_group_view.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/chat_topic_model.dart';
import 'package:fluffychat/pangea/models/lemma.dart';
import 'package:fluffychat/pangea/utils/class_chat_power_levels.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/widgets/class/add_space_toggles.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;

class NewGroup extends StatefulWidget {
  const NewGroup({super.key});

  @override
  NewGroupController createState() => NewGroupController();
}

class NewGroupController extends State<NewGroup> {
  TextEditingController controller = TextEditingController();
  bool publicGroup = false;

  //#Pangea
  PangeaController pangeaController = MatrixState.pangeaController;
  final GlobalKey<AddToSpaceState> addToSpaceKey = GlobalKey<AddToSpaceState>();

  ChatTopic chatTopic = ChatTopic.empty;

  void setVocab(List<Lemma> vocab) => setState(() => chatTopic.vocab = vocab);
  String? get activeSpaceId =>
      GoRouterState.of(context).pathParameters['spaceid'];
  // Pangea#

  void setPublicGroup(bool b) => setState(() => publicGroup = b);

  void submitAction([_]) async {
    // #Pangea
    if (controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.emptyChatNameWarning),
        ),
      );
      return;
    }
    // Pangea#
    final client = Matrix.of(context).client;
    final roomID = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final roomId = await client.createGroupChat(
          // #Pangea
          // visibility:
          //     publicGroup ? sdk.Visibility.public : sdk.Visibility.private,
          // preset: publicGroup
          //     ? sdk.CreateRoomPreset.publicChat
          //     : sdk.CreateRoomPreset.privateChat,
          preset: sdk.CreateRoomPreset.publicChat,
          groupName: controller.text.isNotEmpty ? controller.text : null,
          powerLevelContentOverride:
              await ClassChatPowerLevels.powerLevelOverrideForClassChat(
            context,
            addToSpaceKey.currentState!.parents
                .map((suggestionStatus) => suggestionStatus.room)
                .toList(),
          ),
          // Pangea#
        );
        return roomId;
      },
      // #Pangea
      onError: (exception) {
        ErrorHandler.logError(e: exception, s: StackTrace.current);
        return exception.toString();
      },
      // Pangea#
    );
    if (roomID.error == null) {
      //#Pangea
      GoogleAnalytics.createChat(roomID.result!);
      await addToSpaceKey.currentState!.addSpaces(roomID.result!);
      //Pangea#
      context.go('/rooms/${roomID.result!}/invite');
      //#Pangea
    } else {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: roomID.error, s: StackTrace.current);
    }
    //Pangea#
  }

  //#Pangea
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      chatTopic.langCode =
          pangeaController.languageController.activeL2Code(roomID: null) ??
              pangeaController.pLanguageStore.targetOptions.first.langCode;
      setState(() {});
    });

    super.initState();
  }
  //Pangea#

  @override
  Widget build(BuildContext context) => NewGroupView(this);
}
