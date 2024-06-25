import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_array.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_content.dart';
import 'package:flutter/material.dart';

class MultipleChoiceActivity extends StatelessWidget {
  final MessagePracticeActivityContentState card;
  final Function(int) updateChoice;
  final bool isActive;

  const MultipleChoiceActivity({
    super.key,
    required this.card,
    required this.updateChoice,
    required this.isActive,
  });

  PracticeActivityEvent get practiceEvent => card.practiceEvent;

  int? get selectedChoiceIndex => card.selectedChoiceIndex;

  bool get submitted => card.recordSubmittedThisSession;

  @override
  Widget build(BuildContext context) {
    final PracticeActivityModel practiceActivity =
        practiceEvent.practiceActivity;

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
                    color: (selectedChoiceIndex == index ||
                                practiceActivity.multipleChoice!
                                    .isCorrect(index)) &&
                            submitted
                        ? practiceActivity.multipleChoice!.choiceColor(index)
                        : null,
                    isGold: practiceActivity.multipleChoice!.isCorrect(index),
                  ),
                )
                .toList(),
            isActive: isActive,
          ),
        ],
      ),
    );
  }
}
