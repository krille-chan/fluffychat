import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_array.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:flutter/material.dart';

/// The multiple choice activity view
class MultipleChoiceActivity extends StatefulWidget {
  final MessagePracticeActivityCardState controller;
  final PracticeActivityEvent? currentActivity;

  const MultipleChoiceActivity({
    super.key,
    required this.controller,
    required this.currentActivity,
  });

  @override
  MultipleChoiceActivityState createState() => MultipleChoiceActivityState();
}

class MultipleChoiceActivityState extends State<MultipleChoiceActivity> {
  int? selectedChoiceIndex;

  PracticeActivityRecordModel? get currentRecordModel =>
      widget.controller.currentRecordModel;

  bool get isSubmitted =>
      widget.currentActivity?.userRecord?.record?.latestResponse != null;

  @override
  void initState() {
    super.initState();
    setCompletionRecord();
  }

  @override
  void didUpdateWidget(covariant MultipleChoiceActivity oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentActivity?.event.eventId !=
        widget.currentActivity?.event.eventId) {
      setCompletionRecord();
    }
  }

  /// Sets the completion record for the multiple choice activity.
  /// If the user record is null, it creates a new record model with the question
  /// from the current activity and sets the selected choice index to null.
  /// Otherwise, it sets the current model to the user record's record and
  /// determines the selected choice index.
  void setCompletionRecord() {
    if (widget.currentActivity?.userRecord?.record == null) {
      widget.controller.setCurrentModel(
        PracticeActivityRecordModel(
          question:
              widget.currentActivity?.practiceActivity.multipleChoice!.question,
        ),
      );
      selectedChoiceIndex = null;
    } else {
      widget.controller
          .setCurrentModel(widget.currentActivity!.userRecord!.record);
      selectedChoiceIndex = widget
          .currentActivity?.practiceActivity.multipleChoice!
          .choiceIndex(currentRecordModel!.latestResponse!);
    }
    setState(() {});
  }

  void updateChoice(int index) {
    currentRecordModel?.addResponse(
      text: widget.controller.currentActivity?.practiceActivity.multipleChoice!
          .choices[index],
    );
    setState(() => selectedChoiceIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final PracticeActivityModel? practiceActivity =
        widget.currentActivity?.practiceActivity;

    if (practiceActivity == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            practiceActivity.multipleChoice!.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ChoicesArray(
            isLoading: false,
            uniqueKeyForLayerLink: (index) => "multiple_choice_$index",
            originalSpan: "placeholder",
            onPressed: updateChoice,
            selectedChoiceIndex: selectedChoiceIndex,
            choices: practiceActivity.multipleChoice!.choices
                .mapIndexed(
                  (index, value) => Choice(
                    text: value,
                    color: selectedChoiceIndex == index
                        ? practiceActivity.multipleChoice!.choiceColor(index)
                        : null,
                    isGold: practiceActivity.multipleChoice!.isCorrect(index),
                  ),
                )
                .toList(),
            isActive: !isSubmitted,
          ),
        ],
      ),
    );
  }
}
