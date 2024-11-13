import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/controllers/message_analytics_controller.dart';
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
import 'package:flutter_gen/gen_l10n/l10n.dart';

/// The wrapper for practice activity content.
/// Handles the activities associated with a message,
/// their navigation, and the management of completion records
class PracticeActivityCard extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overlayController;
  final TtsController ttsController;

  const PracticeActivityCard({
    super.key,
    required this.pangeaMessageEvent,
    required this.overlayController,
    required this.ttsController,
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

  MessageAnalyticsEntry? get messageAnalyticsEntry =>
      MatrixState.pangeaController.getAnalytics.perMessage
          .get(widget.pangeaMessageEvent, false);

  PracticeActivityEvent? get existingActivityMatchingNeeds {
    if (messageAnalyticsEntry?.nextActivityToken == null) {
      debugger(when: kDebugMode);
      return null;
    }

    for (final existingActivity in practiceActivities) {
      for (final c in messageAnalyticsEntry!.nextActivityToken!.constructs) {
        if (existingActivity.practiceActivity.tgtConstructs
                .any((tc) => tc == c.id) &&
            existingActivity.practiceActivity.activityType ==
                messageAnalyticsEntry!.nextActivityType) {
          debugPrint('found existing activity');
          return existingActivity;
        }
      }
    }

    return null;
  }

  // Used to show an animation when the user completes an activity
  // while simultaneously fetching a new activity and not showing the loading spinner
  // until the appropriate time has passed to 'savor the joy'
  Duration appropriateTimeForJoy = const Duration(milliseconds: 1500);
  bool savoringTheJoy = false;

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

  Future<PracticeActivityModel?> _fetchActivity([
    ActivityQualityFeedback? activityFeedback,
  ]) async {
    // temporary
    // try {
    debugPrint('Fetching activity');
    // debugger();
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

    if (widget.pangeaMessageEvent.messageDisplayRepresentation == null) {
      debugger(when: kDebugMode);
      _updateFetchingActivity(false);
      ErrorHandler.logError(
        e: Exception('No original message found in _fetchNewActivity'),
        data: {
          'event': widget.pangeaMessageEvent.event.toJson(),
        },
      );
      return null;
    }

    if (widget.pangeaMessageEvent.messageDisplayRepresentation?.tokens ==
        null) {
      debugger(when: kDebugMode);
      _updateFetchingActivity(false);
      return null;
    }

    // the client is going to be choosing the next activity now
    // if nothing is set then it must be done with practice
    if (messageAnalyticsEntry?.nextActivityToken == null ||
        messageAnalyticsEntry?.nextActivityType == null) {
      debugger(when: kDebugMode);
      _updateFetchingActivity(false);
      return null;
    }

    final existingActivity = existingActivityMatchingNeeds;

    if (existingActivity != null) {
      return existingActivity.practiceActivity;
    }

    debugPrint(
      "client requesting activity type: ${messageAnalyticsEntry?.nextActivityType}",
    );
    debugPrint(
      "client requesting token: ${messageAnalyticsEntry?.nextActivityToken?.token.text.content}",
    );

    final PracticeActivityModelResponse? activityResponse =
        await pangeaController.practiceGenerationController.getPracticeActivity(
      MessageActivityRequest(
        userL1: pangeaController.languageController.userL1!.langCode,
        userL2: pangeaController.languageController.userL2!.langCode,
        messageText: widget.pangeaMessageEvent.originalSent!.text,
        tokensWithXP: messageAnalyticsEntry!.tokensWithXp,
        messageId: widget.pangeaMessageEvent.eventId,
        existingActivities: practiceActivities
            .map((activity) => activity.activityRequestMetaData)
            .toList(),
        activityQualityFeedback: activityFeedback,
        clientCompatibleActivities: widget
                .ttsController.isLanguageFullySupported
            ? ActivityTypeEnum.values
            : ActivityTypeEnum.values
                .where((type) => type != ActivityTypeEnum.wordFocusListening)
                .toList(),
        clientTokenRequest: messageAnalyticsEntry!.nextActivityToken!,
        clientTypeRequest: messageAnalyticsEntry!.nextActivityType!,
      ),
      widget.pangeaMessageEvent,
    );

    currentActivityCompleter = activityResponse?.eventCompleter;
    _updateFetchingActivity(false);

    return activityResponse?.activity;
    // } catch (e, s) {
    //   debugger(when: kDebugMode);
    //   ErrorHandler.logError(
    //     e: e,
    //     s: s,
    //     m: 'Failed to get new activity',
    //     data: {
    //       'activity': currentActivity,
    //       'record': currentCompletionRecord,
    //     },
    //   );
    //   return null;
    // }
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

      // update the target tokens with the new construct uses
      // NOTE - multiple choice activity is handling adding these to analytics

      // previously we would update the tokens with the constructs
      // now the tokens themselves calculate their own points using the analytics
      // we're going to see if this creates performance issues
      messageAnalyticsEntry?.updateTargetTypesForMessage();

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
    messageAnalyticsEntry?.revealAllTokens();
    _setPracticeActivity(null);
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
      await activityEvent?.event.redactEvent(reason: feedback);
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
      ActivityQualityFeedback(
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
          tts: widget.ttsController,
          eventID: widget.pangeaMessageEvent.eventId,
          onError: _onError,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!fetchingActivity && currentActivity == null) {
      return GamifiedTextWidget(
        userMessage: L10n.of(context)!.noActivitiesFound,
      );
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
        if (activityWidget != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: activityWidget,
          ),
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
