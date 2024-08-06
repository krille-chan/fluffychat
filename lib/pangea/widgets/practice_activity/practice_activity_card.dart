import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_content.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

/// The wrapper for practice activity content.
/// Handles the activities assosiated with a message,
/// their navigation, and the management of completion records
class PracticeActivityCard extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;

  const PracticeActivityCard({
    super.key,
    required this.pangeaMessageEvent,
  });

  @override
  MessagePracticeActivityCardState createState() =>
      MessagePracticeActivityCardState();
}

class MessagePracticeActivityCardState extends State<PracticeActivityCard> {
  PracticeActivityEvent? currentActivity;
  PracticeActivityRecordModel? currentRecordModel;
  bool sending = false;

  List<PracticeActivityEvent> get practiceActivities =>
      widget.pangeaMessageEvent.practiceActivities;

  int get practiceEventIndex => practiceActivities.indexWhere(
        (activity) => activity.event.eventId == currentActivity?.event.eventId,
      );

  bool get isPrevEnabled =>
      practiceEventIndex > 0 &&
      practiceActivities.length > (practiceEventIndex - 1);

  bool get isNextEnabled =>
      practiceEventIndex >= 0 &&
      practiceEventIndex < practiceActivities.length - 1;

  @override
  void initState() {
    super.initState();
    setCurrentActivity();
  }

  /// Initalizes the current activity.
  /// If the current activity hasn't been set yet, show the first
  /// uncompleted activity if there is one.
  /// If not, show the first activity
  void setCurrentActivity() {
    if (practiceActivities.isEmpty) return;
    final List<PracticeActivityEvent> incompleteActivities =
        practiceActivities.where((element) => !element.isComplete).toList();
    currentActivity ??= incompleteActivities.isNotEmpty
        ? incompleteActivities.first
        : practiceActivities.first;
    setState(() {});
  }

  void setCurrentModel(PracticeActivityRecordModel? recordModel) {
    currentRecordModel = recordModel;
  }

  /// Sets the current acitivity based on the given [direction].
  void navigateActivities(Direction direction) {
    final bool enableNavigation = (direction == Direction.f && isNextEnabled) ||
        (direction == Direction.b && isPrevEnabled);
    if (enableNavigation) {
      currentActivity = practiceActivities[direction == Direction.f
          ? practiceEventIndex + 1
          : practiceEventIndex - 1];
      setState(() {});
    }
  }

  /// Sends the current record model and activity to the server.
  /// If either the currentRecordModel or currentActivity is null, the method returns early.
  /// Sets the [sending] flag to true before sending the record and activity.
  /// Logs any errors that occur during the send operation.
  /// Sets the [sending] flag to false when the send operation is complete.
  void sendRecord() {
    if (currentRecordModel == null || currentActivity == null) return;
    setState(() => sending = true);
    MatrixState.pangeaController.activityRecordController
        .send(currentRecordModel!, currentActivity!)
        .catchError((error) {
      ErrorHandler.logError(
        e: error,
        s: StackTrace.current,
        data: {
          'recordModel': currentRecordModel?.toJson(),
          'practiceEvent': currentActivity?.event.toJson(),
        },
      );
      return null;
    }).then((event) {
      // The record event is processed into construct uses for learning analytics, so if the
      // event went through without error, send it to analytics to be processed
      if (event != null && currentActivity != null) {
        MatrixState.pangeaController.myAnalytics.setState(
          data: {
            'eventID': widget.pangeaMessageEvent.eventId,
            'eventType': PangeaEventTypes.activityRecord,
            'roomID': event.room.id,
            'practiceActivity': currentActivity!,
            'recordModel': currentRecordModel!,
          },
        );
      }
    }).whenComplete(() => setState(() => sending = false));
  }

  @override
  Widget build(BuildContext context) {
    final Widget navigationButtons = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Opacity(
          opacity: isPrevEnabled ? 1.0 : 0,
          child: IconButton(
            onPressed:
                isPrevEnabled ? () => navigateActivities(Direction.b) : null,
            icon: const Icon(Icons.keyboard_arrow_left_outlined),
            tooltip: L10n.of(context)!.previous,
          ),
        ),
        Expanded(
          child: Opacity(
            opacity: currentActivity?.userRecord == null ? 1.0 : 0.5,
            child: sending
                ? const CircularProgressIndicator.adaptive()
                : TextButton(
                    onPressed:
                        currentActivity?.userRecord == null ? sendRecord : null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        AppConfig.primaryColor,
                      ),
                    ),
                    child: Text(L10n.of(context)!.submit),
                  ),
          ),
        ),
        Opacity(
          opacity: isNextEnabled ? 1.0 : 0,
          child: IconButton(
            onPressed:
                isNextEnabled ? () => navigateActivities(Direction.f) : null,
            icon: const Icon(Icons.keyboard_arrow_right_outlined),
            tooltip: L10n.of(context)!.next,
          ),
        ),
      ],
    );

    if (currentActivity == null || practiceActivities.isEmpty) {
      return Text(
        L10n.of(context)!.noActivitiesFound,
        style: BotStyle.text(context),
      );
      // return GeneratePracticeActivityButton(
      //   pangeaMessageEvent: widget.pangeaMessageEvent,
      //   onActivityGenerated: updatePracticeActivity,
      // );
    }
    return Column(
      children: [
        PracticeActivity(
          practiceEvent: currentActivity!,
          controller: this,
        ),
        navigationButtons,
      ],
    );
  }
}
