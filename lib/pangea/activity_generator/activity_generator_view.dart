import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/activity_generator/activity_generator.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_card.dart';
import 'package:fluffychat/pangea/activity_planner/suggestion_form_field.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_constants.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/p_language_dropdown.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityGeneratorView extends StatelessWidget {
  final ActivityGeneratorState controller;

  const ActivityGeneratorView(
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    Widget? body;

    if (controller.loading) {
      body = const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (controller.error != null) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.oopsSomethingWentWrong),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.generate,
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      );
    } else if (controller.activities != null &&
        controller.activities!.isNotEmpty) {
      body = ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.activities!.length,
        itemBuilder: (context, index) {
          return ActivityPlanCard(
            activity: controller.activities![index],
            room: controller.room,
            onEdit: (updatedActivity) =>
                controller.onEdit(index, updatedActivity),
            onChange: controller.update,
            initialFilename: controller.filename,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).makeYourOwnActivity),
      ),
      body: body ??
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: controller.formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const InstructionsInlineTooltip(
                      instructionsEnum:
                          InstructionsEnum.activityPlannerOverview,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.center,
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              "${AppConfig.assetsBaseURL}/${ActivitySuggestionsConstants.makeActivityAssetPath}",
                          placeholder: (context, url) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorWidget: (context, url, error) =>
                              const SizedBox(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PLanguageDropdown(
                      languages: MatrixState
                          .pangeaController.pLanguageStore.baseOptions,
                      onChange: (val) => controller
                          .setSelectedLanguageOfInstructions(val.langCode),
                      initialLanguage:
                          controller.selectedLanguageOfInstructions != null
                              ? PLanguageStore.byLangCode(
                                  controller.selectedLanguageOfInstructions!,
                                )
                              : MatrixState
                                  .pangeaController.languageController.userL1,
                      isL2List: false,
                      decorationText:
                          L10n.of(context).languageOfInstructionsLabel,
                    ),
                    const SizedBox(height: 16.0),
                    PLanguageDropdown(
                      languages: MatrixState
                          .pangeaController.pLanguageStore.targetOptions,
                      onChange: (val) =>
                          controller.setSelectedTargetLanguage(val.langCode),
                      initialLanguage: controller.selectedTargetLanguage != null
                          ? PLanguageStore.byLangCode(
                              controller.selectedTargetLanguage!,
                            )
                          : MatrixState
                              .pangeaController.languageController.userL2,
                      decorationText: L10n.of(context).targetLanguageLabel,
                      isL2List: true,
                    ),
                    const SizedBox(height: 16.0),
                    SuggestionFormField(
                      suggestions: controller.topicItems,
                      validator: controller.validateNotNull,
                      label: l10n.topicLabel,
                      placeholder: l10n.topicPlaceholder,
                      controller: controller.topicController,
                    ),
                    const SizedBox(height: 16.0),
                    SuggestionFormField(
                      suggestions: controller.objectiveItems,
                      validator: controller.validateNotNull,
                      label: l10n.learningObjectiveLabel,
                      placeholder: l10n.learningObjectivePlaceholder,
                      controller: controller.objectiveController,
                    ),
                    const SizedBox(height: 16.0),
                    SuggestionFormField(
                      suggestions: controller.modeItems,
                      validator: controller.validateNotNull,
                      label: l10n.modeLabel,
                      placeholder: l10n.modePlaceholder,
                      controller: controller.modeController,
                    ),
                    const SizedBox(height: 16.0),
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
                        if (controller.formKey.currentState?.validate() ??
                            false) {
                          controller.generate();
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              onPressed: controller.clearSelections,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Symbols.reset_focus),
                                  const SizedBox(width: 8),
                                  Text(L10n.of(context).clear),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ElevatedButton(
                              onPressed: controller.randomizeSelections,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shuffle),
                                  const SizedBox(width: 8),
                                  Text(L10n.of(context).randomize),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.formKey.currentState?.validate() ??
                            false) {
                          controller.generate();
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
