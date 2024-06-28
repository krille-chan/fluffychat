import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_record_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/multiple_choice_activity.dart';
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
  MessagePracticeActivityContentState createState() =>
      MessagePracticeActivityContentState();
}

class MessagePracticeActivityContentState extends State<PracticeActivity> {
  int? selectedChoiceIndex;
  PracticeActivityRecordModel? recordModel;
  bool recordSubmittedThisSession = false;
  bool recordSubmittedPreviousSession = false;

  PracticeActivityEvent get practiceEvent => widget.practiceEvent;

  @override
  void initState() {
    super.initState();
    initalizeActivity();
  }

  @override
  void didUpdateWidget(covariant PracticeActivity oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.practiceEvent.event.eventId !=
        widget.practiceEvent.event.eventId) {
      initalizeActivity();
    }
  }

  void initalizeActivity() {
    final PracticeActivityRecordEvent? recordEvent =
        widget.practiceEvent.userRecord;
    if (recordEvent?.record == null) {
      recordModel = PracticeActivityRecordModel(
        question:
            widget.practiceEvent.practiceActivity.multipleChoice!.question,
      );
    } else {
      recordModel = recordEvent!.record;

      //Note that only MultipleChoice activities will have this so we probably should move this logic to the MultipleChoiceActivity widget
      selectedChoiceIndex = recordModel?.latestResponse?.text != null
          ? widget.practiceEvent.practiceActivity.multipleChoice
              ?.choiceIndex(recordModel!.latestResponse!.text!)
          : null;

      recordSubmittedPreviousSession = true;
      recordSubmittedThisSession = true;
    }
    setState(() {});
  }

  void updateChoice(int index) {
    setState(() {
      selectedChoiceIndex = index;
      recordModel!.addResponse(
        score: widget.practiceEvent.practiceActivity.multipleChoice!
                .isCorrect(index)
            ? 1
            : 0,
        text: widget
            .practiceEvent.practiceActivity.multipleChoice!.choices[index],
      );
    });
  }

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
