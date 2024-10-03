import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/animations/gain_points.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/multiple_choice_activity.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/no_more_practice_card.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/target_tokens_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

/// The wrapper for practice activity content.
/// Handles the activities associated with a message,
/// their navigation, and the management of completion records
class PracticeActivityCard extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overlayController;

  const PracticeActivityCard({
    super.key,
    required this.pangeaMessageEvent,
    required this.overlayController,
  });

  @override
  MessagePracticeActivityCardState createState() =>
      MessagePracticeActivityCardState();
}

class MessagePracticeActivityCardState extends State<PracticeActivityCard> {
  PracticeActivityEvent? currentActivity;
  PracticeActivityRecordModel? currentCompletionRecord;
  bool fetchingActivity = false;

  // tracks the target tokens for the current message
  // in a separate controller to manage the state
  TargetTokensController targetTokensController = TargetTokensController();

  List<PracticeActivityEvent> get practiceActivities =>
      widget.pangeaMessageEvent.practiceActivities;

  // Used to show an animation when the user completes an activity
  // while simultaneously fetching a new activity and not showing the loading spinner
  // until the appropriate time has passed to 'savor the joy'
  Duration appropriateTimeForJoy = const Duration(milliseconds: 1000);
  bool savoringTheJoy = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void _updateFetchingActivity(bool value) {
    if (fetchingActivity == value) return;
    setState(() => fetchingActivity = value);
  }

  void _setPracticeActivity(PracticeActivityEvent? activity) {
    //set elsewhere but just in case
    fetchingActivity = false;

    currentActivity = activity;

    if (activity == null) {
      widget.overlayController.exitPracticeFlow();
      return;
    }

    //make new completion record
    currentCompletionRecord = PracticeActivityRecordModel(
      question: activity.practiceActivity.question,
    );

    widget.overlayController.setSelectedSpan(activity.practiceActivity);
  }

  /// Get an existing activity if there is one.
  /// If not, get a new activity from the server.
  Future<void> initialize() async {
    _setPracticeActivity(
      _fetchExistingIncompleteActivity() ?? await _fetchNewActivity(),
    );
  }

  // if the user did the activity before but awhile ago and we don't have any
  // more target tokens, maybe we should give them the same activity again
  PracticeActivityEvent? _fetchExistingIncompleteActivity() {
    if (practiceActivities.isEmpty) {
      return null;
    }

    final List<PracticeActivityEvent> incompleteActivities =
        practiceActivities.where((element) => !element.isComplete).toList();

    // TODO - maybe check the user's xp for the tgtConstructs and decide if its relevant for them
    // however, maybe we'd like to go ahead and give them the activity to get some data on our xp?
    return incompleteActivities.firstOrNull;
  }

  Future<PracticeActivityEvent?> _fetchNewActivity([
    ActivityQualityFeedback? activityFeedback,
  ]) async {
    try {
      debugPrint('Fetching new activity');

      _updateFetchingActivity(true);

      // target tokens can be empty if activities have been completed for each
      // it's set on initialization and then removed when each activity is completed
      if (!pangeaController.languageController.languagesSet) {
        debugger(when: kDebugMode);
        _updateFetchingActivity(false);
        return null;
      }

      if (!mounted) {
        debugger(when: kDebugMode);
        _updateFetchingActivity(false);
        return null;
      }

      final PracticeActivityEvent? ourNewActivity = await pangeaController
          .practiceGenerationController
          .getPracticeActivity(
        MessageActivityRequest(
          userL1: pangeaController.languageController.userL1!.langCode,
          userL2: pangeaController.languageController.userL2!.langCode,
          messageText: representation!.text,
          tokensWithXP: await targetTokensController.targetTokens(
            context,
            widget.pangeaMessageEvent,
          ),
          messageId: widget.pangeaMessageEvent.eventId,
          existingActivities: practiceActivities
              .map((activity) => activity.activityRequestMetaData)
              .toList(),
          activityQualityFeedback: activityFeedback,
        ),
        widget.pangeaMessageEvent,
      );

      _updateFetchingActivity(false);

      return ourNewActivity;
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        m: 'Failed to get new activity',
        data: {
          'activity': currentActivity,
          'record': currentCompletionRecord,
        },
      );
      return null;
    }
  }

  ConstructUseMetaData get metadata => ConstructUseMetaData(
        eventId: widget.pangeaMessageEvent.eventId,
        roomId: widget.pangeaMessageEvent.room.id,
        timeStamp: DateTime.now(),
      );

  Future<void> _savorTheJoy() async {
    if (savoringTheJoy) {
      //should not happen
      debugger(when: kDebugMode);
    }
    savoringTheJoy = true;

    debugPrint('Savoring the joy');

    await Future.delayed(appropriateTimeForJoy);

    savoringTheJoy = false;

    debugPrint('Savoring the joy is over');
  }

  /// Called when the user finishes an activity.
  /// Saves the completion record and sends it to the server.
  /// Fetches a new activity if there are any left to complete.
  /// Exits the practice flow if there are no more activities.
  void onActivityFinish() async {
    try {
      if (currentCompletionRecord == null || currentActivity == null) {
        debugger(when: kDebugMode);
        return;
      }

      // update the target tokens with the new construct uses
      // NOTE - multiple choice activity is handling adding these to analytics
      await targetTokensController.updateTokensWithConstructs(
        currentCompletionRecord!.usesForAllResponses(
          currentActivity!.practiceActivity,
          metadata,
        ),
        context,
        widget.pangeaMessageEvent,
      );

      // save the record without awaiting to avoid blocking the UI
      // send a copy of the activity record to make sure its not overwritten by
      // the new activity
      MatrixState.pangeaController.activityRecordController
          .send(currentCompletionRecord!, currentActivity!)
          .catchError(
            (e, s) => ErrorHandler.logError(
              e: e,
              s: s,
              m: 'Failed to save record',
              data: {
                'record': currentCompletionRecord?.toJson(),
                'activity': currentActivity?.practiceActivity.toJson(),
              },
            ),
          );

      widget.overlayController.onActivityFinish();

      final Iterable<dynamic> result = await Future.wait([
        _savorTheJoy(),
        _fetchNewActivity(),
      ]);

      _setPracticeActivity(result.last as PracticeActivityEvent?);
    } catch (e, s) {
      _setPracticeActivity(null);
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        m: 'Failed to get new activity',
        data: {
          'activity': currentActivity,
          'record': currentCompletionRecord,
        },
      );
    }
  }

  void onFlagClick(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(L10n.of(context)!.reportContentIssueTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(L10n.of(context)!.reportContentIssueDescription),
              const SizedBox(height: 10),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText: L10n.of(context)!.feedback,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(L10n.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                // Call the additional callback function
                submitFeedback(feedbackController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(L10n.of(context)!.submit),
            ),
          ],
        );
      },
    );
  }

  /// clear the current activity, record, and selection
  /// fetch a new activity, including the offending activity in the request
  void submitFeedback(String feedback) {
    if (currentActivity == null) {
      debugger(when: kDebugMode);
      return;
    }

    _fetchNewActivity(
      ActivityQualityFeedback(
        feedbackText: feedback,
        badActivity: currentActivity!.practiceActivity,
      ),
    ).then((activity) {
      _setPracticeActivity(activity);
    }).catchError((onError) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: onError,
        m: 'Failed to get new activity',
        data: {
          'activity': currentActivity,
          'record': currentCompletionRecord,
        },
      );
      widget.overlayController.exitPracticeFlow();
    });

    // clear the current activity and record
    currentActivity = null;
    currentCompletionRecord = null;
  }

  RepresentationEvent? get representation =>
      widget.pangeaMessageEvent.originalSent;

  String get messsageText => representation!.text;

  PangeaController get pangeaController => MatrixState.pangeaController;

  /// The widget that displays the current activity.
  /// If there is no current activity, the widget returns a sizedbox with a height of 80.
  /// If the activity type is multiple choice, the widget returns a MultipleChoiceActivity.
  /// If the activity type is unknown, the widget logs an error and returns a text widget with an error message.
  Widget get activityWidget {
    if (currentActivity == null) {
      // return sizedbox with height of 80
      return const SizedBox(height: 80);
    }
    switch (currentActivity!.practiceActivity.activityType) {
      case ActivityTypeEnum.multipleChoice:
        return MultipleChoiceActivity(
          practiceCardController: this,
          currentActivity: currentActivity,
        );
      default:
        ErrorHandler.logError(
          e: Exception('Unknown activity type'),
          m: 'Unknown activity type',
          data: {
            'activityType': currentActivity!.practiceActivity.activityType,
          },
        );
        return Text(
          L10n.of(context)!.oopsSomethingWentWrong,
          style: BotStyle.text(context),
        );
    }
  }

  String? get userMessage {
    if (!fetchingActivity && currentActivity == null) {
      return L10n.of(context)!.noActivitiesFound;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (userMessage != null) {
      return GamifiedTextWidget(userMessage: userMessage!);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Main content
        const Positioned(
          child: PointsGainedAnimation(),
        ),
        Column(
          children: [
            activityWidget,
            // navigationButtons,
          ],
        ),
        // Conditionally show the darkening and progress indicator based on the loading state
        if (!savoringTheJoy && fetchingActivity) ...[
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Darkening effect
          ),
          // Circular progress indicator in the center
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
        // Flag button in the top right corner
        Positioned(
          top: 0,
          right: 0,
          child: Opacity(
            opacity: 0.8, // Slight opacity
            child: Tooltip(
              message: L10n.of(context)!.reportContentIssueTitle,
              child: IconButton(
                icon: const Icon(Icons.flag),
                onPressed: () =>
                    currentActivity == null ? null : onFlagClick(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
