//stateful widget that displays a card with a practice activity

import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/widgets/practice_activity_card/multiple_choice_activity.dart';
import 'package:flutter/material.dart';

class PracticeActivityCard extends StatefulWidget {
  final PracticeActivityModel practiceActivity;

  const PracticeActivityCard({
    super.key,
    required this.practiceActivity,
  });

  @override
  MessagePracticeActivityCardState createState() =>
      MessagePracticeActivityCardState();
}

//parameters for the stateful widget
// practiceActivity: the practice activity to display
// use a switch statement based on the type of the practice activity to display the appropriate content
// just use different widgets for the different types, don't define in this file
// for multiple choice, use the MultipleChoiceActivity widget
// for the rest, just return SizedBox.shrink() for now
class MessagePracticeActivityCardState extends State<PracticeActivityCard> {
  @override
  Widget build(BuildContext context) {
    switch (widget.practiceActivity.activityType) {
      case ActivityType.multipleChoice:
        return MultipleChoiceActivity(
          practiceActivity: widget.practiceActivity,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
