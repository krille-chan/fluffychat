import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/multiple_choice_activity_view.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:flutter/material.dart';

class PracticeActivity extends StatefulWidget {
  final PracticeActivityEvent practiceEvent;
  final PangeaMessageEvent pangeaMessageEvent;
  final MessagePracticeActivityCardState controller;

  const PracticeActivity({
    super.key,
    required this.practiceEvent,
    required this.pangeaMessageEvent,
    required this.controller,
  });

  @override
  PracticeActivityContentState createState() => PracticeActivityContentState();
}

class PracticeActivityContentState extends State<PracticeActivity> {
  PracticeActivityEvent get practiceEvent => widget.practiceEvent;
  int? selectedChoiceIndex;
  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    setRecord();
  }

  @override
  void didUpdateWidget(covariant PracticeActivity oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.practiceEvent.event.eventId !=
        widget.practiceEvent.event.eventId) {
      setRecord();
    }
  }

  // sets the record model for the activity
  // either a new record model that will be sent after submitting the
  // activity or the record model from the user's previous response
  void setRecord() {
    if (widget.controller.recordEvent?.record == null) {
      final String question =
          practiceEvent.practiceActivity.multipleChoice!.question;
      widget.controller.recordModel =
          PracticeActivityRecordModel(question: question);
    } else {
      widget.controller.recordModel = widget.controller.recordEvent!.record;

      // Note that only MultipleChoice activities will have this so we
      // probably should move this logic to the MultipleChoiceActivity widget
      selectedChoiceIndex =
          widget.controller.recordModel?.latestResponse != null
              ? widget.practiceEvent.practiceActivity.multipleChoice
                  ?.choiceIndex(widget.controller.recordModel!.latestResponse!)
              : null;
      isSubmitted = widget.controller.recordModel?.latestResponse != null;
    }
    setState(() {});
  }

  void updateChoice(int index) {
    setState(() {
      selectedChoiceIndex = index;
      widget.controller.recordModel!.addResponse(
        text: widget
            .practiceEvent.practiceActivity.multipleChoice!.choices[index],
      );
    });
  }

  Widget get activityWidget {
    switch (widget.practiceEvent.practiceActivity.activityType) {
      case ActivityTypeEnum.multipleChoice:
        return MultipleChoiceActivityView(
          controller: this,
          updateChoice: updateChoice,
          isActive: !isSubmitted,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      "MessagePracticeActivityContentState.build with selectedChoiceIndex: $selectedChoiceIndex",
    );
    return Column(
      children: [
        activityWidget,
        const SizedBox(height: 8),
      ],
    );
  }
}
