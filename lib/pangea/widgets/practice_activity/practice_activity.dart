import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/multiple_choice_activity_view.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:flutter/material.dart';

/// Practice activity content
class PracticeActivity extends StatefulWidget {
  final PracticeActivityEvent practiceEvent;
  final MessagePracticeActivityCardState controller;

  const PracticeActivity({
    super.key,
    required this.practiceEvent,
    required this.controller,
  });

  @override
  PracticeActivityContentState createState() => PracticeActivityContentState();
}

class PracticeActivityContentState extends State<PracticeActivity> {
  Widget get activityWidget {
    switch (widget.practiceEvent.practiceActivity.activityType) {
      case ActivityTypeEnum.multipleChoice:
        return MultipleChoiceActivity(
          controller: widget.controller,
          currentActivity: widget.practiceEvent,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        activityWidget,
        const SizedBox(height: 8),
      ],
    );
  }
}
