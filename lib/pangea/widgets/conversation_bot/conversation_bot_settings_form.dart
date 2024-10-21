import 'package:fluffychat/pangea/constants/bot_mode.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_mode_dynamic_zone.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_mode_select.dart';
import 'package:fluffychat/pangea/widgets/space/language_level_dropdown.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotSettingsForm extends StatefulWidget {
  final BotOptionsModel botOptions;
  final GlobalKey<FormState> formKey;

  final TextEditingController discussionTopicController;
  final TextEditingController discussionKeywordsController;
  final TextEditingController customSystemPromptController;

  const ConversationBotSettingsForm({
    super.key,
    required this.botOptions,
    required this.formKey,
    required this.discussionTopicController,
    required this.discussionKeywordsController,
    required this.customSystemPromptController,
  });

  @override
  ConversationBotSettingsFormState createState() =>
      ConversationBotSettingsFormState();
}

class ConversationBotSettingsFormState
    extends State<ConversationBotSettingsForm> {
  late BotOptionsModel botOptions;

  @override
  void initState() {
    super.initState();
    botOptions = widget.botOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField(
          // Initial Value
          hint: Text(
            L10n.of(context)!.selectBotLanguage,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
          value: botOptions.targetLanguage,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: MatrixState.pangeaController.pLanguageStore.targetOptions
              .map((language) {
            return DropdownMenuItem(
              value: language.langCode,
              child: Text(
                language.getDisplayName(context) ?? language.langCode,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
          onChanged: (String? newValue) => {
            setState(() => botOptions.targetLanguage = newValue!),
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          // Initial Value
          hint: Text(
            L10n.of(context)!.chooseVoice,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
          value: botOptions.targetVoice,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: const [],
          onChanged: (String? newValue) => {
            setState(() => botOptions.targetVoice = newValue!),
          },
        ),
        const SizedBox(height: 12),
        LanguageLevelDropdown(
          initialLevel: botOptions.languageLevel,
          onChanged: (int? newValue) => {
            setState(() {
              botOptions.languageLevel = newValue!;
            }),
          },
          validator: (value) =>
              value == null ? L10n.of(context)!.enterLanguageLevel : null,
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              L10n.of(context)!.conversationBotModeSelectDescription,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ConversationBotModeSelect(
          initialMode: botOptions.mode,
          onChanged: (String? mode) => {
            setState(() {
              botOptions.mode = mode ?? BotMode.discussion;
            }),
          },
        ),
        const SizedBox(height: 12),
        ConversationBotModeDynamicZone(
          initialBotOptions: botOptions,
          discussionTopicController: widget.discussionTopicController,
          discussionKeywordsController: widget.discussionKeywordsController,
          customSystemPromptController: widget.customSystemPromptController,
          formKey: widget.formKey,
        ),
      ],
    );
  }
}
