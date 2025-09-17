import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_animation.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_choice.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/practice_match_item.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_audio_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class MatchActivityCard extends StatelessWidget {
  final PracticeActivityModel currentActivity;
  final MessageOverlayController overlayController;

  const MatchActivityCard({
    super.key,
    required this.currentActivity,
    required this.overlayController,
  });

  PracticeActivityModel get activity => currentActivity;

  ActivityTypeEnum get activityType => currentActivity.activityType;

  Widget choiceDisplayContent(
    String choice,
    double? fontSize,
  ) {
    switch (activityType) {
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.wordMeaning:
        return Text(
          choice,
          style: TextStyle(fontSize: fontSize),
          textAlign: TextAlign.center,
        );
      case ActivityTypeEnum.wordFocusListening:
        return Icon(
          Icons.volume_up,
          size: fontSize,
        );
      default:
        debugger(when: kDebugMode);
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = (FluffyThemes.isColumnMode(context)
            ? Theme.of(context).textTheme.titleLarge?.fontSize
            : Theme.of(context).textTheme.titleMedium?.fontSize) ??
        26;

    if (overlayController.toolbarMode == MessageMode.listening ||
        overlayController.toolbarMode == MessageMode.wordEmoji) {
      fontSize = fontSize * 1.5;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      spacing: 4.0,
      children: [
        if (overlayController.toolbarMode == MessageMode.listening)
          MessageAudioCard(
            overlayController: overlayController,
          ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4.0,
          runSpacing: 4.0,
          children: activity.matchContent!.choices.map(
            (PracticeChoice cf) {
              final bool? wasCorrect =
                  currentActivity.practiceTarget.wasCorrectMatch(cf);
              return ChoiceAnimationWidget(
                isSelected: overlayController.selectedChoice == cf,
                isCorrect: wasCorrect,
                child: PracticeMatchItem(
                  token: currentActivity.practiceTarget.tokens.firstWhereOrNull(
                    (t) => t.vocabConstructID == cf.form.cId,
                  ),
                  isSelected: overlayController.selectedChoice == cf,
                  isCorrect: wasCorrect,
                  constructForm: cf,
                  content: choiceDisplayContent(cf.choiceContent, fontSize),
                  audioContent:
                      activityType == ActivityTypeEnum.wordFocusListening
                          ? cf.choiceContent
                          : null,
                  overlayController: overlayController,
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
