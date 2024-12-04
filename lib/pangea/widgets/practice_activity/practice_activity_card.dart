import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/controllers/practice_activity_generation_controller.dart';
import 'package:fluffychat/pangea/controllers/put_analytics_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/animations/gain_points.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/chat/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/widgets/chat/tts_controller.dart';
import 'package:fluffychat/pangea/widgets/content_issue_button.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/multiple_choice_activity.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/no_more_practice_card.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

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
  PracticeActivityCardState createState() => PracticeActivityCardState();
}

class PracticeActivityCardState extends State<PracticeActivityCard> {
  PracticeActivityModel? currentActivity;
  Completer<PracticeActivityEvent?>? currentActivityCompleter;

  PracticeActivityRecordModel? currentCompletionRecord;
  bool fetchingActivity = false;

  List<PracticeActivityEvent> get practiceActivities =>
      widget.pangeaMessageEvent.practiceActivities;

  // Used to show an animation when the user completes an activity
  // while simultaneously fetching a new activity and not showing the loading spinner
  // until the appropriate time has passed to 'savor the joy'
  Duration appropriateTimeForJoy = const Duration(milliseconds: 2500);
  bool savoringTheJoy = false;

  TtsController get tts =>
      widget.overlayController.widget.chatController.choreographer.tts;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void _updateFetchingActivity(bool value) {
    if (fetchingActivity == value) return;
    if (mounted) setState(() => fetchingActivity = value);
  }

  void _setPracticeActivity(PracticeActivityModel? activity) {
    //set elsewhere but just in case
    fetchingActivity = false;

    currentActivity = activity;

    if (activity == null) {
      widget.overlayController.exitPracticeFlow();
      return;
    }

    //make new completion record
    currentCompletionRecord = PracticeActivityRecordModel(
      question: activity.question,
    );

    widget.overlayController.setSelectedSpan(activity);
  }

  /// Get an existing activity if there is one.
  /// If not, get a new activity from the server.
  Future<void> initialize() async {
    _setPracticeActivity(
      await _fetchActivity(),
    );
  }

  Future<PracticeActivityModel?> _fetchActivity({
    ActivityQualityFeedback? activityFeedback,
  }) async {
    try {
      debugPrint('Fetching activity');
      _updateFetchingActivity(true);

      // target tokens can be empty if activities have been completed for each
      // it's set on initialization and then removed when each activity is completed
      if (!mounted ||
          !pangeaController.languageController.languagesSet ||
          widget.overlayController.messageAnalyticsEntry == null) {
        debugger(when: kDebugMode);
        _updateFetchingActivity(false);
        return null;
      }

      final nextActivitySpecs =
          widget.overlayController.messageAnalyticsEntry?.nextActivity;
      // the client is going to be choosing the next activity now
      // if nothing is set then it must be done with practice
      if (nextActivitySpecs == null) {
        debugPrint("No next activity set, exiting practice flow");
        _updateFetchingActivity(false);
        return null;
      }

      // check if we already have an activity matching the specs
      final existingActivity = practiceActivities.firstWhereOrNull(
        (activity) =>
            nextActivitySpecs.matchesActivity(activity.practiceActivity),
      );
      if (existingActivity != null) {
        debugPrint('found existing activity');
        _updateFetchingActivity(false);
        existingActivity.practiceActivity.targetTokens =
            nextActivitySpecs.tokens;
        currentActivityCompleter = Completer();
        currentActivityCompleter!.complete(existingActivity);
        return existingActivity.practiceActivity;
      }

      debugPrint(
        "client requesting ${nextActivitySpecs.activityType.string} for: ${nextActivitySpecs.tokens.map((t) => "construct: ${t.lemma.text}:${t.pos} points: ${t.vocabConstruct.points}").join(' ')}",
      );

      // debugger(
      //   when: kDebugMode &&
      //       nextActivitySpecs.tokens
      //               .map((a) => a.vocabConstruct.points)
      //               .reduce((a, b) => a + b) >
      //           30 &&
      //       nextActivitySpecs.activityType == ActivityTypeEnum.wordMeaning,
      // );

      final PracticeActivityModelResponse? activityResponse =
          await pangeaController.practiceGenerationController
              .getPracticeActivity(
        MessageActivityRequest(
          userL1: pangeaController.languageController.userL1!.langCode,
          userL2: pangeaController.languageController.userL2!.langCode,
          messageText: widget.pangeaMessageEvent.messageDisplayText,
          messageTokens: widget.overlayController.tokens!,
          activityQualityFeedback: activityFeedback,
          targetTokens: nextActivitySpecs.tokens,
          targetType: nextActivitySpecs.activityType,
        ),
        widget.pangeaMessageEvent,
      );

      currentActivityCompleter = activityResponse?.eventCompleter;
      _updateFetchingActivity(false);

      if (activityResponse == null || activityResponse.activity == null) {
        debugPrint('No activity found');
        return null;
      }

      activityResponse.activity!.targetTokens = nextActivitySpecs.tokens;

      return activityResponse.activity;
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
    try {
      debugger(when: savoringTheJoy && kDebugMode);

      if (mounted) setState(() => savoringTheJoy = true);

      await Future.delayed(appropriateTimeForJoy);

      if (mounted) setState(() => savoringTheJoy = false);
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        m: 'Failed to savor the joy',
        data: {
          'activity': currentActivity,
          'record': currentCompletionRecord,
        },
      );
    }
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

      widget.overlayController.messageAnalyticsEntry!
          .onActivityComplete(currentActivity!);

      widget.overlayController.onActivityFinish();

      pangeaController.activityRecordController.completeActivity(
        widget.pangeaMessageEvent.eventId,
      );

      // wait for the joy to be savored before resolving the activity
      // and setting it to replace the previous activity
      final Iterable<dynamic> result = await Future.wait([
        _savorTheJoy(),
        _fetchActivity(),
      ]);

      _setPracticeActivity(result.last as PracticeActivityModel?);
    } catch (e, s) {
      _onError();
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'activity': currentActivity,
          'record': currentCompletionRecord,
        },
      );
    }
  }

  void _onError() {
    widget.overlayController.messageAnalyticsEntry?.revealAllTokens();
    _setPracticeActivity(null);
  }

  bool _isActivityRedaction(EventUpdate update, String activityId) {
    return update.content.containsKey('type') &&
        update.content['type'] == 'm.room.redaction' &&
        update.content.containsKey('content') &&
        update.content['content']['redacts'] == activityId;
  }

  /// clear the current activity, record, and selection
  /// fetch a new activity, including the offending activity in the request
  Future<void> submitFeedback(String feedback) async {
    if (currentActivity == null || currentCompletionRecord == null) {
      debugger(when: kDebugMode);
      return;
    }

    if (currentActivityCompleter != null) {
      final activityEvent = await currentActivityCompleter!.future;
      if (activityEvent != null) {
        await activityEvent.event.redactEvent(reason: feedback);
        final eventID = activityEvent.event.eventId;
        await activityEvent.event.room.client.onEvent.stream
            .firstWhere(
              (update) => _isActivityRedaction(update, eventID),
            )
            .timeout(const Duration(milliseconds: 2500));
      }
    } else {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: Exception('No completer found for current activity'),
        data: {
          'activity': currentActivity,
          'record': currentCompletionRecord,
          'feedback': feedback,
        },
      );
    }

    _fetchActivity(
      activityFeedback: ActivityQualityFeedback(
        feedbackText: feedback,
        badActivity: currentActivity!,
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

      // clear the current activity and record
      currentActivity = null;
      currentCompletionRecord = null;

      widget.overlayController.exitPracticeFlow();
    });
  }

  PangeaController get pangeaController => MatrixState.pangeaController;

  /// The widget that displays the current activity.
  /// If there is no current activity, the widget returns a sizedbox with a height of 80.
  /// If the activity type is multiple choice, the widget returns a MultipleChoiceActivity.
  /// If the activity type is unknown, the widget logs an error and returns a text widget with an error message.
  Widget? get activityWidget {
    switch (currentActivity?.activityType) {
      case null:
        return null;
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
      case ActivityTypeEnum.wordMeaning:
        return MultipleChoiceActivity(
          practiceCardController: this,
          currentActivity: currentActivity!,
          event: widget.pangeaMessageEvent.event,
          onError: _onError,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!fetchingActivity && currentActivity == null) {
      return const GamifiedTextWidget();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Main content
        const Positioned(
          child: PointsGainedAnimation(
            origin: AnalyticsUpdateOrigin.practiceActivity,
          ),
        ),
        if (activityWidget != null) activityWidget!,
        // Conditionally show the darkening and progress indicator based on the loading state
        if (!savoringTheJoy && fetchingActivity) ...[
          // Circular progress indicator in the center
          const ToolbarContentLoadingIndicator(),
        ],
        // Flag button in the top right corner
        Positioned(
          top: 0,
          right: 0,
          child: ContentIssueButton(
            isActive: currentActivity != null,
            submitFeedback: submitFeedback,
          ),
        ),
      ],
    );
  }
}
