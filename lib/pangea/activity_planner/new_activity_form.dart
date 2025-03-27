import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/activity_planner/activity_planner_page.dart';
import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/activity_planner/suggestion_form_field.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/language_level_dropdown.dart';
import 'package:fluffychat/pangea/common/widgets/dropdown_text_button.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/p_language_dropdown.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewActivityForm extends StatelessWidget {
  final ActivityPlannerPageState controller;
  const NewActivityForm(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Expanded(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: controller.formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const InstructionsInlineTooltip(
                  instructionsEnum: InstructionsEnum.activityPlannerOverview,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SuggestionFormField(
                            suggestions: controller.topicItems,
                            validator: controller.validateNotNull,
                            label: l10n.topicLabel,
                            placeholder: l10n.topicPlaceholder,
                            controller: controller.topicController,
                          ),
                          const SizedBox(height: 24),
                          SuggestionFormField(
                            suggestions: controller.objectiveItems,
                            validator: controller.validateNotNull,
                            label: l10n.learningObjectiveLabel,
                            placeholder: l10n.learningObjectivePlaceholder,
                            controller: controller.objectiveController,
                          ),
                          const SizedBox(height: 24),
                          SuggestionFormField(
                            suggestions: controller.modeItems,
                            validator: controller.validateNotNull,
                            label: l10n.modeLabel,
                            placeholder: l10n.modePlaceholder,
                            controller: controller.modeController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shuffle),
                          onPressed: controller.randomizeSelections,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField2<MediaEnum>(
                  customButton: CustomDropdownTextButton(
                    text: controller.selectedMedia
                        .toDisplayCopyUsingL10n(context),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.zero, // Remove default padding
                  ),
                  decoration: InputDecoration(labelText: l10n.mediaLabel),
                  isExpanded: true,
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    ),
                  ),
                  items: MediaEnum.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: DropdownTextButton(
                            text: e.toDisplayCopyUsingL10n(context),
                            isSelected: controller.selectedMedia == e,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: controller.setSelectedMedia,
                  value: controller.selectedMedia,
                ),
                const SizedBox(height: 24),
                LanguageLevelDropdown(
                  initialLevel: controller.selectedCefrLevel,
                  onChanged: controller.setSelectedCefrLevel,
                ),
                const SizedBox(height: 24),
                PLanguageDropdown(
                  languages:
                      MatrixState.pangeaController.pLanguageStore.baseOptions,
                  onChange: (val) => controller
                      .setSelectedLanguageOfInstructions(val.langCode),
                  initialLanguage: controller.selectedLanguageOfInstructions !=
                          null
                      ? PLanguageStore.byLangCode(
                          controller.selectedLanguageOfInstructions!,
                        )
                      : MatrixState.pangeaController.languageController.userL1,
                  isL2List: false,
                  decorationText: L10n.of(context).languageOfInstructionsLabel,
                ),
                const SizedBox(height: 24),
                PLanguageDropdown(
                  languages:
                      MatrixState.pangeaController.pLanguageStore.targetOptions,
                  onChange: (val) =>
                      controller.setSelectedTargetLanguage(val.langCode),
                  initialLanguage: controller.selectedTargetLanguage != null
                      ? PLanguageStore.byLangCode(
                          controller.selectedTargetLanguage!,
                        )
                      : MatrixState.pangeaController.languageController.userL2,
                  decorationText: L10n.of(context).targetLanguageLabel,
                  isL2List: true,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: l10n.numberOfLearners,
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.mustBeInteger;
                    }
                    final n = int.tryParse(value);
                    if (n == null || n <= 0) {
                      return l10n.mustBeInteger;
                    }
                    return null;
                  },
                  onChanged: (val) => controller
                      .setSelectedNumberOfParticipants(int.tryParse(val)),
                  initialValue:
                      controller.selectedNumberOfParticipants?.toString(),
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  onFieldSubmitted: (_) {
                    if (controller.formKey.currentState?.validate() ?? false) {
                      controller.generateActivities();
                    }
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (controller.formKey.currentState?.validate() ?? false) {
                      controller.generateActivities();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lightbulb_outline),
                      const SizedBox(width: 8),
                      Text(l10n.generateActivitiesButton),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
