import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
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
        PLanguageDropdown(
          decorationText: L10n.of(context).targetLanguage,
          languages: MatrixState.pangeaController.pLanguageStore.targetOptions,
          onChange: (lang) => hasPermission && enabled
              ? onUpdateBotLanguage(lang.langCode)
              : null,
          initialLanguage: botOptions.targetLanguage != null
              ? PLanguageStore.byLangCode(botOptions.targetLanguage!)
              : null,
          enabled: enabled && hasPermission,
        ),
        const SizedBox(height: 12),
        LanguageLevelDropdown(
          initialLevel: botOptions.languageLevel,
          onChanged: hasPermission && enabled
              ? (value) =>
                  onUpdateBotLanguageLevel(value as LanguageLevelTypeEnum?)
              : null,
          validator: (value) => enabled && value == null
              ? L10n.of(context).enterLanguageLevel
              : null,
          enabled: enabled && hasPermission,
        ),
      ],
    );
  }
}
