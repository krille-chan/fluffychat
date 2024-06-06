// stateful widget that displays a card with a practice activity of type multiple choice

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_array.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:flutter/material.dart';

class MultipleChoiceActivity extends StatefulWidget {
  final PracticeActivityModel practiceActivity;

  const MultipleChoiceActivity({
    super.key,
    required this.practiceActivity,
  });

  @override
  MultipleChoiceActivityState createState() => MultipleChoiceActivityState();
}

//parameters for the stateful widget
// practiceActivity: the practice activity to display
// show the question text and choices
// use the ChoiceArray widget to display the choices
class MultipleChoiceActivityState extends State<MultipleChoiceActivity> {
  int? selectedChoiceIndex;

  late MultipleChoiceActivityCompletionRecord? completionRecord;

  @override
  initState() {
    super.initState();
    selectedChoiceIndex = null;
    completionRecord = MultipleChoiceActivityCompletionRecord(
      question: widget.practiceActivity.multipleChoice!.question,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            widget.practiceActivity.multipleChoice!.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ChoicesArray(
            isLoading: false,
            uniqueKeyForLayerLink: (index) => "multiple_choice_$index",
            onLongPress: null,
            onPressed: (index) {
              selectedChoiceIndex = index;
              completionRecord!.selectedOptions
                  .add(widget.practiceActivity.multipleChoice!.choices[index]);
              setState(() {});
            },
            originalSpan: "placeholder",
            selectedChoiceIndex: selectedChoiceIndex,
            choices: widget.practiceActivity.multipleChoice!.choices
                .mapIndexed(
                  (int index, String value) => Choice(
                    text: value,
                    color: null,
                    isGold:
                        widget.practiceActivity.multipleChoice!.correctAnswer ==
                            value,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
