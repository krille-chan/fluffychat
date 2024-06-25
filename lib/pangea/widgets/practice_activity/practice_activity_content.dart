import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_acitivity_record_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/multiple_choice_activity.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class PracticeActivityContent extends StatefulWidget {
  final PracticeActivityEvent practiceEvent;
  final PangeaMessageEvent pangeaMessageEvent;

  const PracticeActivityContent({
    super.key,
    required this.practiceEvent,
    required this.pangeaMessageEvent,
  });

  @override
  MessagePracticeActivityContentState createState() =>
      MessagePracticeActivityContentState();
}

class MessagePracticeActivityContentState
    extends State<PracticeActivityContent> {
  int? selectedChoiceIndex;
  PracticeActivityRecordModel? recordModel;
  bool recordSubmittedThisSession = false;
  bool recordSubmittedPreviousSession = false;

  PracticeActivityEvent get practiceEvent => widget.practiceEvent;

  @override
  void initState() {
    super.initState();
    final PracticeActivityRecordEvent? recordEvent =
        widget.practiceEvent.userRecords.firstOrNull;
    if (recordEvent?.record == null) {
      recordModel = PracticeActivityRecordModel(
        question:
            widget.practiceEvent.practiceActivity.multipleChoice!.question,
      );
    } else {
      recordModel = recordEvent!.record;
      selectedChoiceIndex = recordModel!.latestResponseIndex;
      recordSubmittedPreviousSession = true;
      recordSubmittedThisSession = true;
    }
  }

  void updateChoice(int index) {
    setState(() {
      selectedChoiceIndex = index;
      recordModel!.addResponse(
        text: widget
            .practiceEvent.practiceActivity.multipleChoice!.choices[index],
      );
    });
  }

  Widget get activityWidget {
    switch (widget.practiceEvent.practiceActivity.activityType) {
      case ActivityTypeEnum.multipleChoice:
        return MultipleChoiceActivity(
          card: this,
          updateChoice: updateChoice,
          isActive:
              !recordSubmittedPreviousSession && !recordSubmittedThisSession,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void sendRecord() {
    MatrixState.pangeaController.activityRecordController
        .send(
      recordModel!,
      widget.practiceEvent,
    )
        .catchError((error) {
      ErrorHandler.logError(
        e: error,
        s: StackTrace.current,
        data: {
          'recordModel': recordModel?.toJson(),
          'practiceEvent': widget.practiceEvent.event.toJson(),
        },
      );
      return null;
    });

    setState(() {
      recordSubmittedThisSession = true;
    });
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: selectedChoiceIndex != null &&
                      !recordSubmittedThisSession &&
                      !recordSubmittedPreviousSession
                  ? 1.0
                  : 0.5,
              child: TextButton(
                onPressed: () {
                  if (recordSubmittedThisSession ||
                      recordSubmittedPreviousSession) {
                    return;
                  }
                  selectedChoiceIndex != null ? sendRecord() : null;
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    AppConfig.primaryColor,
                  ),
                ),
                child: Text(L10n.of(context)!.submit),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
