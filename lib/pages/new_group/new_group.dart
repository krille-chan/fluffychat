import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/pages/new_group/new_group_view.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/chat_topic_model.dart';
import 'package:fluffychat/pangea/models/lemma.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/class_chat_power_levels.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/widgets/class/add_space_toggles.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_settings.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;

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

  // #Pangea
  PangeaController pangeaController = MatrixState.pangeaController;
  final GlobalKey<AddToSpaceState> addToSpaceKey = GlobalKey<AddToSpaceState>();
  final GlobalKey<ConversationBotSettingsState> addConversationBotKey =
      GlobalKey<ConversationBotSettingsState>();

  ChatTopic chatTopic = ChatTopic.empty;

  void setVocab(List<Lemma> vocab) => setState(() => chatTopic.vocab = vocab);

  String? get activeSpaceId =>
      GoRouterState.of(context).pathParameters['spaceid'];
  // Pangea#

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
    // #Pangea
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.emptyChatNameWarning),
        ),
      );
      return;
    }
    // Pangea#
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
        // #Pangea
        // visibility:
        //     publicGroup ? sdk.Visibility.public : sdk.Visibility.private,
        // preset: publicGroup
        //     ? sdk.CreateRoomPreset.publicChat
        //     : sdk.CreateRoomPreset.privateChat,
        // groupName: nameController.text.isNotEmpty ? nameController.text : null,
        // initialState: [
        //   if (topicController.text.isNotEmpty)
        //     sdk.StateEvent(
        //       type: sdk.EventTypes.RoomTopic,
        //       content: {'topic': topicController.text},
        //     ),
        //   if (avatar != null)
        //     sdk.StateEvent(
        //       type: sdk.EventTypes.RoomAvatar,
        //       content: {'url': avatarUrl.toString()},
        //     ),
        // ],
        groupName: nameController.text,
        preset: sdk.CreateRoomPreset.publicChat,
        powerLevelContentOverride:
            await ClassChatPowerLevels.powerLevelOverrideForClassChat(
          context,
          addToSpaceKey.currentState!.parents
              .map((suggestionStatus) => suggestionStatus.room)
              .toList(),
        ),
        invite: [
          if (addConversationBotKey.currentState?.addBot ?? false)
            BotName.byEnvironment,
        ],
        // Pangea#
      );
      if (!mounted) return;
      if (publicGroup && groupCanBeFound) {
        await client.setRoomVisibilityOnDirectory(
          roomId,
          visibility: sdk.Visibility.public,
        );
      }
      //#Pangea
      GoogleAnalytics.createChat(roomId);
      await addToSpaceKey.currentState!.addSpaces(roomId);
      //Pangea#
      context.go('/rooms/$roomId/invite');
    } catch (e, s) {
      sdk.Logs().d('Unable to create group', e, s);
      setState(() {
        error = e;
        loading = false;
      });
    }
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
