import 'dart:developer';

import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/common/bot_face_svg.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_settings_form.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

class ConversationBotSettings extends StatefulWidget {
  final Room room;
  final String? activeSpaceId;

  const ConversationBotSettings({
    super.key,
    required this.room,
    this.activeSpaceId,
  });

  @override
  ConversationBotSettingsState createState() => ConversationBotSettingsState();
}

class ConversationBotSettingsState extends State<ConversationBotSettings> {
  late BotOptionsModel botOptions;
  bool addBot = false;

  ConversationBotSettingsState({Key? key});

  final TextEditingController discussionTopicController =
      TextEditingController();
  final TextEditingController discussionKeywordsController =
      TextEditingController();
  final TextEditingController customSystemPromptController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    botOptions = widget.room.botOptions != null
        ? BotOptionsModel.fromJson(widget.room.botOptions?.toJson())
        : BotOptionsModel();

    widget.room.botIsInRoom.then((bool isBotRoom) {
      setState(() => addBot = isBotRoom);
    });

    discussionKeywordsController.text = botOptions.discussionKeywords ?? "";
    discussionTopicController.text = botOptions.discussionTopic ?? "";
    customSystemPromptController.text = botOptions.customSystemPrompt ?? "";
  }

  Future<void> setBotOption() async {
    try {
      await Matrix.of(context).client.setRoomStateWithKey(
            widget.room.id,
            PangeaEventTypes.botOptions,
            '',
            botOptions.toJson(),
          );
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack);
    }
  }

  Future<void> updateBotOption(void Function() makeLocalChange) async {
    makeLocalChange();
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        try {
          await setBotOption();
        } catch (err, stack) {
          debugger(when: kDebugMode);
          ErrorHandler.logError(e: err, s: stack);
        }
        setState(() {});
      },
    );
  }

  void updateFromTextControllers() {
    botOptions.discussionTopic = discussionTopicController.text;
    botOptions.discussionKeywords = discussionKeywordsController.text;
    botOptions.customSystemPrompt = customSystemPromptController.text;
  }

  Future<void> showBotOptionsDialog() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Dialog(
            child: Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(
                  maxWidth: 450,
                  maxHeight: 725,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: ConversationBotSettingsDialog(
                    addBot: addBot,
                    botOptions: botOptions,
                    formKey: formKey,
                    updateAddBot: (bool value) =>
                        setState(() => addBot = value),
                    discussionKeywordsController: discussionKeywordsController,
                    discussionTopicController: discussionTopicController,
                    customSystemPromptController: customSystemPromptController,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (confirm == true) {
      updateFromTextControllers();
      updateBotOption(() => botOptions = botOptions);

      final bool isBotRoomMember = await widget.room.botIsInRoom;
      if (addBot && !isBotRoomMember) {
        await widget.room.invite(BotName.byEnvironment);
      } else if (!addBot && isBotRoomMember) {
        await widget.room.kick(BotName.byEnvironment);
      }
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              L10n.of(context)!.botConfig,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
              child: const BotFace(
                width: 30.0,
                expression: BotExpression.idle,
              ),
            ),
            trailing: const Icon(Icons.settings),
            onTap: showBotOptionsDialog,
          ),
        ],
      ),
    );
  }
}

class ConversationBotSettingsDialog extends StatelessWidget {
  final bool addBot;
  final BotOptionsModel botOptions;
  final GlobalKey<FormState> formKey;

  final void Function(bool) updateAddBot;

  final TextEditingController discussionTopicController;
  final TextEditingController discussionKeywordsController;
  final TextEditingController customSystemPromptController;

  const ConversationBotSettingsDialog({
    super.key,
    required this.addBot,
    required this.botOptions,
    required this.formKey,
    required this.updateAddBot,
    required this.discussionTopicController,
    required this.discussionKeywordsController,
    required this.customSystemPromptController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Text(
              L10n.of(context)!.botConfig,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        SwitchListTile(
          title: Text(
            L10n.of(context)!.conversationBotStatus,
          ),
          value: addBot,
          onChanged: updateAddBot,
          contentPadding: const EdgeInsets.all(4),
        ),
        if (addBot)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ConversationBotSettingsForm(
                    botOptions: botOptions,
                    formKey: formKey,
                    discussionKeywordsController: discussionKeywordsController,
                    discussionTopicController: discussionTopicController,
                    customSystemPromptController: customSystemPromptController,
                  ),
                ],
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(L10n.of(context)!.cancel),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {
                final isValid = formKey.currentState!.validate();
                if (!isValid) return;
                Navigator.of(context).pop(true);
              },
              child: Text(L10n.of(context)!.confirm),
            ),
          ],
        ),
      ],
    );
  }
}
