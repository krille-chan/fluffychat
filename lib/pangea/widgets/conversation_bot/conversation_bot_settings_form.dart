import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_mode_dynamic_zone.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_mode_select.dart';
import 'package:fluffychat/pangea/widgets/space/language_level_dropdown.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotSettingsForm extends StatelessWidget {
  final BotOptionsModel botOptions;

  final TextEditingController discussionTopicController;
  final TextEditingController discussionKeywordsController;
  final TextEditingController customSystemPromptController;

  final bool enabled;
  final bool hasUpdatedMode;

  final void Function(String?) onUpdateBotMode;
  final void Function(String?) onUpdateBotLanguage;
  final void Function(String?) onUpdateBotVoice;
  final void Function(int?) onUpdateBotLanguageLevel;

  const ConversationBotSettingsForm({
    super.key,
    required this.botOptions,
    required this.discussionTopicController,
    required this.discussionKeywordsController,
    required this.customSystemPromptController,
    required this.onUpdateBotMode,
    required this.onUpdateBotLanguage,
    required this.onUpdateBotVoice,
    required this.onUpdateBotLanguageLevel,
    this.enabled = true,
    this.hasUpdatedMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField2(
          dropdownStyleData: const DropdownStyleData(
            padding: EdgeInsets.zero,
          ),
          hint: Text(
            L10n.of(context)!.selectBotLanguage,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
          value: botOptions.targetLanguage,
          isExpanded: true,
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
          onChanged: enabled ? onUpdateBotLanguage : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField2<String>(
          hint: Text(
            L10n.of(context)!.chooseVoice,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
          value: botOptions.targetVoice,
          isExpanded: true,
          items: const [],
          onChanged: enabled ? onUpdateBotVoice : null,
        ),
        const SizedBox(height: 12),
        LanguageLevelDropdown(
          initialLevel: botOptions.languageLevel,
          onChanged: onUpdateBotLanguageLevel,
          validator: (value) => enabled && value == null
              ? L10n.of(context)!.enterLanguageLevel
              : null,
          enabled: enabled,
        ),
        const SizedBox(height: 12),
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
        ConversationBotModeSelect(
          initialMode: hasUpdatedMode ? botOptions.mode : null,
          onChanged: onUpdateBotMode,
          enabled: enabled,
          validator: (value) {
            return value == null ? L10n.of(context)!.botModeValidation : null;
          },
        ),
        const SizedBox(height: 12),
        ConversationBotModeDynamicZone(
          discussionTopicController: discussionTopicController,
          discussionKeywordsController: discussionKeywordsController,
          customSystemPromptController: customSystemPromptController,
          enabled: enabled,
          mode: hasUpdatedMode ? botOptions.mode : null,
        ),
      ],
    );
  }
}
