import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_practice/activity_choices_widget.dart';
import 'package:fluffychat/pangea/analytics_practice/activity_content_widget.dart';
import 'package:fluffychat/pangea/analytics_practice/activity_feedback_widget.dart';
import 'package:fluffychat/pangea/analytics_practice/activity_hint_section_widget.dart';
import 'package:fluffychat/pangea/analytics_practice/activity_hints_progress_widget.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_page.dart';
import 'package:fluffychat/pangea/analytics_practice/audio_activity_continue_button_widget.dart';
import 'package:fluffychat/pangea/common/utils/async_state.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_widget.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

class OngoingActivitySessionView extends StatelessWidget {
  final AnalyticsPracticeState controller;

  const OngoingActivitySessionView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);
    TextStyle? titleStyle = isColumnMode
        ? Theme.of(context).textTheme.titleLarge
        : Theme.of(context).textTheme.titleMedium;
    titleStyle = titleStyle?.copyWith(fontWeight: FontWeight.bold);

    return ValueListenableBuilder(
      valueListenable: controller.activityState,
      builder: (context, state, _) {
        final activity = controller.activity;
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.flag_outlined),
                      onPressed: activity != null
                          ? () => controller.flagActivity(activity)
                          : null,
                    ),
                  ),
                  //Hints counter bar for grammar activities only
                  if (controller.widget.type == ConstructTypeEnum.morph)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ActivityHintsProgress(
                        hintsUsed: controller.session.hintsUsed,
                      ),
                    ),
                  //per-activity instructions, add switch statement once there are more types
                  const InstructionsInlineTooltip(
                    instructionsEnum: InstructionsEnum.selectMeaning,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  SizedBox(
                    height: 75.0,
                    child: Builder(
                      builder: (context) {
                        if (activity == null) {
                          return const SizedBox.shrink();
                        }

                        final isAudioActivity =
                            activity.activityType ==
                            ActivityTypeEnum.lemmaAudio;
                        final isVocabType =
                            controller.widget.type == ConstructTypeEnum.vocab;

                        final token = activity.tokens.first;

                        return Column(
                          children: [
                            Text(
                              isAudioActivity && isVocabType
                                  ? L10n.of(context).selectAllWords
                                  : activity.practiceTarget.promptText(context),
                              textAlign: TextAlign.center,
                              style: titleStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (isVocabType && !isAudioActivity)
                              PhoneticTranscriptionWidget(
                                text: token.vocabConstructID.lemma,
                                pos: token.pos,
                                morph: token.morph.map(
                                  (k, v) => MapEntry(k.name, v),
                                ),
                                textLanguage: MatrixState
                                    .pangeaController
                                    .userController
                                    .userL2!,
                                style: const TextStyle(fontSize: 14.0),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  ListenableBuilder(
                    listenable: controller.notifier,
                    builder: (context, _) {
                      final selectedMorphChoice = controller.notifier
                          .selectedMorphChoice(activity);
                      return Column(
                        children: [
                          const SizedBox(height: 16.0),
                          if (activity != null)
                            Center(
                              child: ActivityContent(
                                activity: activity,
                                showHint: controller.notifier.showHint,
                                exampleMessage: controller.exampleMessage,
                                audioFile: controller.data.getAudioFile(
                                  activity,
                                ),
                              ),
                            ),
                          const SizedBox(height: 16.0),
                          if (activity != null)
                            ActivityHintSection(
                              activity: activity,
                              onPressed: controller.onHintPressed,
                              hintPressed: controller.notifier.showHint,
                              enabled: controller.notifier.enableHintPress(
                                activity,
                                controller.session.hintsUsed,
                              ),
                            ),
                          const SizedBox(height: 16.0),
                          switch (state) {
                            AsyncError(error: final error) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //allow try to reload activity in case of error
                                ErrorIndicator(
                                  message: error.toLocalizedString(context),
                                ),
                                const SizedBox(height: 16),
                                TextButton.icon(
                                  onPressed: controller.startSession,
                                  icon: const Icon(Icons.refresh),
                                  label: Text(L10n.of(context).tryAgain),
                                ),
                              ],
                            ),
                            AsyncLoaded(value: final activity) => Builder(
                              builder: (context) {
                                List<InlineSpan>? audioExampleMessage;
                                String? audioTranslation;

                                if (activity
                                    is VocabAudioPracticeActivityModel) {
                                  audioExampleMessage =
                                      activity.exampleMessage.exampleMessage;
                                  audioTranslation = controller.data
                                      .getAudioTranslation(activity);
                                }

                                return ActivityChoices(
                                  activity: activity,
                                  choices: controller.data.filteredChoices(
                                    activity,
                                    controller.widget.type,
                                  ),
                                  type: controller.widget.type,
                                  isComplete: controller.notifier
                                      .activityComplete(activity),
                                  showHint: controller.notifier.showHint,
                                  onSelectChoice: controller.onSelectChoice,
                                  audioExampleMessage: audioExampleMessage,
                                  audioTranslation: audioTranslation,
                                );
                              },
                            ),
                            _ => Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                          },
                          const SizedBox(height: 16.0),
                          if (activity != null && selectedMorphChoice != null)
                            ActivityFeedback(
                              activity: activity,
                              selectedChoice: selectedMorphChoice,
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            if (activity is VocabAudioPracticeActivityModel)
              ListenableBuilder(
                listenable: controller.notifier,
                builder: (context, _) => Container(
                  alignment: Alignment.bottomCenter,
                  child: AudioContinueButton(
                    activity: activity,
                    onContinue: controller.startNextActivity,
                    activityComplete: controller.notifier.activityComplete(
                      activity,
                    ),
                    correctAnswers: controller.notifier.correctAnswersSelected(
                      activity,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
