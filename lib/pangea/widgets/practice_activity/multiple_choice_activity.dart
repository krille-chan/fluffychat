import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_array.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/word_audio_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The multiple choice activity view
class MultipleChoiceActivity extends StatefulWidget {
  final PracticeActivityCardState practiceCardController;
  final PracticeActivityModel currentActivity;

  const MultipleChoiceActivity({
    super.key,
    required this.practiceCardController,
    required this.currentActivity,
  });

  @override
  MultipleChoiceActivityState createState() => MultipleChoiceActivityState();
}

class MultipleChoiceActivityState extends State<MultipleChoiceActivity> {
  int? selectedChoiceIndex;

  PracticeActivityRecordModel? get currentRecordModel =>
      widget.practiceCardController.currentCompletionRecord;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MultipleChoiceActivity oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.practiceCardController.currentCompletionRecord?.responses
            .isEmpty ??
        false) {
      setState(() => selectedChoiceIndex = null);
    }
  }

  void updateChoice(String value, int index) {
    if (currentRecordModel?.hasTextResponse(value) ?? false) {
      return;
    }

    final bool isCorrect =
        widget.currentActivity.content.isCorrect(value, index);

    currentRecordModel?.addResponse(
      text: value,
      score: isCorrect ? 1 : 0,
    );

    if (currentRecordModel == null ||
        currentRecordModel!.latestResponse == null) {
      debugger(when: kDebugMode);
      return;
    }

    // #freeze-activity
    // MatrixState.pangeaController.myAnalytics.setState(
    //   AnalyticsStream(
    //     // note - this maybe should be the activity event id
    //     eventId:
    //         widget.practiceCardController.widget.pangeaMessageEvent.eventId,
    //     roomId: widget.practiceCardController.widget.pangeaMessageEvent.room.id,
    //     constructs: currentRecordModel!.latestResponse!.toUses(
    //       widget.practiceCardController.currentActivity!,
    //       widget.practiceCardController.metadata,
    //     ),
    //   ),
    // );

    // If the selected choice is correct, send the record and get the next activity
    if (widget.currentActivity.content.isCorrect(value, index)) {
      widget.practiceCardController.onActivityFinish();
    }

    if (mounted) {
      setState(
        () => selectedChoiceIndex = index,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PracticeActivityModel practiceActivity = widget.currentActivity;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            practiceActivity.content.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // #freeze-activity
          if (practiceActivity.activityType ==
              ActivityTypeEnum.wordFocusListening)
            WordAudioButton(text: practiceActivity.content.answer),
          ChoicesArray(
            isLoading: false,
            uniqueKeyForLayerLink: (index) => "multiple_choice_$index",
            originalSpan: "placeholder",
            onPressed: updateChoice,
            selectedChoiceIndex: selectedChoiceIndex,
            choices: practiceActivity.content.choices
                .mapIndexed(
                  (index, value) => Choice(
                    text: value,
                    color: currentRecordModel?.hasTextResponse(value) ?? false
                        ? practiceActivity.content.choiceColor(index)
                        : null,
                    isGold: practiceActivity.content.isCorrect(value, index),
                  ),
                )
                .toList(),
            isActive: true,
          ),
        ],
      ),
    );
  }
}
