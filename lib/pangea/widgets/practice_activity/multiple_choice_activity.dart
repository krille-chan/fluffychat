import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_array.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:flutter/material.dart';

/// The multiple choice activity view
class MultipleChoiceActivity extends StatefulWidget {
  final MessagePracticeActivityCardState practiceCardController;
  final PracticeActivityEvent? currentActivity;

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

  bool get isSubmitted =>
      widget.currentActivity?.latestUserRecord?.record.latestResponse != null;

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
    if (widget.currentActivity?.latestUserRecord?.record == null) {
      widget.practiceCardController.setCompletionRecord(
        PracticeActivityRecordModel(
          question:
              widget.currentActivity?.practiceActivity.multipleChoice!.question,
        ),
      );
      selectedChoiceIndex = null;
    } else {
      widget.practiceCardController.setCompletionRecord(
          widget.currentActivity!.latestUserRecord!.record);
      selectedChoiceIndex = widget
          .currentActivity?.practiceActivity.multipleChoice!
          .choiceIndex(currentRecordModel!.latestResponse!.text!);
    }
    setState(() {});
  }

  void updateChoice(String value, int index) {
    if (currentRecordModel?.hasTextResponse(value) ?? false) {
      return;
    }

    final bool isCorrect = widget
        .currentActivity!.practiceActivity.multipleChoice!
        .isCorrect(value, index);

    final ConstructUseTypeEnum useType =
        isCorrect ? ConstructUseTypeEnum.corPA : ConstructUseTypeEnum.incPA;

    currentRecordModel?.addResponse(
      text: value,
      score: isCorrect ? 1 : 0,
    );

    // TODO - add draft uses
    // activities currently pass around tgtConstructs but not the token
    // either we change addDraftUses to take constructs or we get and pass the token
    // MatrixState.pangeaController.myAnalytics.addDraftUses(
    //     widget.currentActivity.practiceActivity.tg,
    //     widget.practiceCardController.widget.pangeaMessageEvent.room.id,
    //     useType,
    //   );

    // If the selected choice is correct, send the record and get the next activity
    if (widget.currentActivity!.practiceActivity.multipleChoice!
        .isCorrect(value, index)) {
      widget.practiceCardController.onActivityFinish();
    }

    setState(
      () => selectedChoiceIndex = index,
    );
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
                    color: currentRecordModel?.hasTextResponse(value) ?? false
                        ? practiceActivity.multipleChoice!.choiceColor(index)
                        : null,
                    isGold: practiceActivity.multipleChoice!
                        .isCorrect(value, index),
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
