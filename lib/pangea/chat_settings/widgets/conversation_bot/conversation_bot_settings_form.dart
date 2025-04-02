import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/conversation_bot/conversation_bot_no_permission_dialog.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/language_level_dropdown.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/p_language_dropdown.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ConversationBotSettingsForm extends StatelessWidget {
  final BotOptionsModel botOptions;

  final TextEditingController discussionTopicController;
  final TextEditingController discussionKeywordsController;
  final TextEditingController customSystemPromptController;

  final bool enabled;
  final bool hasUpdatedMode;
  final bool hasPermission;

  final void Function(String?) onUpdateBotMode;
  final void Function(String?) onUpdateBotLanguage;
  final void Function(String?) onUpdateBotVoice;
  final void Function(LanguageLevelTypeEnum?) onUpdateBotLanguageLevel;

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
    required this.hasPermission,
    this.enabled = true,
    this.hasUpdatedMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: hasPermission ? null : () => showNoPermissionDialog(context),
          child: PLanguageDropdown(
            decorationText: L10n.of(context).targetLanguage,
            languages:
                MatrixState.pangeaController.pLanguageStore.targetOptions,
            onChange: (lang) => hasPermission && enabled
                ? onUpdateBotLanguage(lang.langCode)
                : null,
            initialLanguage: botOptions.targetLanguage != null
                ? PLanguageStore.byLangCode(botOptions.targetLanguage!)
                : null,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: hasPermission ? null : () => showNoPermissionDialog(context),
          child: LanguageLevelDropdown(
            initialLevel: botOptions.languageLevel,
            onChanged: hasPermission && enabled
                ? (value) =>
                    onUpdateBotLanguageLevel(value as LanguageLevelTypeEnum?)
                : null,
            validator: (value) => enabled && value == null
                ? L10n.of(context).enterLanguageLevel
                : null,
            enabled: enabled,
          ),
        ),
        // const SizedBox(height: 12),
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 12),
        //     child: Text(
        //       L10n.of(context).conversationBotModeSelectDescription,
        //       style: Theme.of(context).textTheme.titleLarge,
        //     ),
        //   ),
        // ),
        // InkWell(
        //   onTap: hasPermission ? null : () => showNoPermissionDialog(context),
        //   child: ConversationBotModeSelect(
        //     initialMode: hasUpdatedMode ? botOptions.mode : null,
        //     onChanged: hasPermission && enabled ? onUpdateBotMode : null,
        //     enabled: enabled,
        //     validator: (value) {
        //       return value == null && enabled
        //           ? L10n.of(context).botModeValidation
        //           : null;
        //     },
        //   ),
        // ),
        // const SizedBox(height: 12),
        // ConversationBotModeDynamicZone(
        //   discussionTopicController: discussionTopicController,
        //   discussionKeywordsController: discussionKeywordsController,
        //   customSystemPromptController: customSystemPromptController,
        //   enabled: enabled,
        //   hasPermission: hasPermission,
        //   mode: hasUpdatedMode ? botOptions.mode : null,
        // ),
      ],
    );
  }
}
