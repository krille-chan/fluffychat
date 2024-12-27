import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/controllers/message_analytics_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/controllers/put_analytics_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/repo/practice/practice_repo.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/animations/gain_points.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/chat/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/multiple_choice_activity.dart';
import 'package:fluffychat/pangea/widgets/word_zoom/word_zoom_widget.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The wrapper for practice activity content.
/// Handles the activities associated with a message,
/// their navigation, and the management of completion records
class PracticeActivityCard extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final TargetTokensAndActivityType targetTokensAndActivityType;
  final MessageOverlayController overlayController;
  final WordZoomWidgetState? wordDetailsController;

  final String? morphFeature;

  //TODO - modifications
  // 1) Future<PracticeActivityEvent> and Future<PracticeActivityModel> as parameters
  // 2) onFinish callback as parameter
  // 3) take out logic fetching activity

  const PracticeActivityCard({
    super.key,
    required this.pangeaMessageEvent,
    required this.targetTokensAndActivityType,
    required this.overlayController,
    this.morphFeature,
    this.wordDetailsController,
  });

  @override
  PracticeActivityCardState createState() => PracticeActivityCardState();
}

class PracticeActivityCardState extends State<PracticeActivityCard> {
  PracticeActivityModel? currentActivity;
  bool fetchingActivity = false;
  bool savoringTheJoy = false;

  PracticeActivityRecordModel? currentCompletionRecord;
  Completer<PracticeActivityEvent?>? currentActivityCompleter;

  PracticeGenerationController practiceGenerationController =
      PracticeGenerationController();

  PangeaController get pangeaController => MatrixState.pangeaController;

  @override
  void initState() {
    super.initState();
    _fetchActivity();
  }

  @override
  void didUpdateWidget(PracticeActivityCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetTokensAndActivityType !=
            widget.targetTokensAndActivityType ||
        oldWidget.morphFeature != widget.morphFeature) {
      _fetchActivity();
    }
  }

  @override
  void dispose() {
    practiceGenerationController.dispose();
    super.dispose();
  }

  void _updateFetchingActivity(bool value) {
    if (fetchingActivity == value) return;
    if (mounted) setState(() => fetchingActivity = value);
  }

  Future<void> _fetchActivity({
    ActivityQualityFeedback? activityFeedback,
  }) async {
    if (!mounted ||
        !pangeaController.languageController.languagesSet ||
        widget.overlayController.messageAnalyticsEntry == null) {
      debugger(when: kDebugMode);
      _updateFetchingActivity(false);
      return;
    }

    try {
      _updateFetchingActivity(true);
      final activity = await _fetchActivityModel(
        activityFeedback: activityFeedback,
      );

      currentActivity = activity;
      if (activity == null) {
        widget.overlayController.exitPracticeFlow();
        return;
      }

      currentCompletionRecord = PracticeActivityRecordModel(
        question: activity.question,
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'activity': currentActivity?.toJson(),
          'record': currentCompletionRecord?.toJson(),
          'targetTokens': widget.targetTokensAndActivityType.tokens
              .map((token) => token.toJson())
              .toList(),
          'activityType': widget.targetTokensAndActivityType.activityType,
          'morphFeature': widget.morphFeature,
        },
      );
      debugger(when: kDebugMode);
    } finally {
      _updateFetchingActivity(false);
    }
  }

  Future<PracticeActivityModel?> _fetchActivityModel({
    ActivityQualityFeedback? activityFeedback,
  }) async {
    debugPrint(
      "fetching activity model of type: ${widget.targetTokensAndActivityType.activityType}",
    );
    // check if we already have an activity matching the specs
    final tokens = widget.targetTokensAndActivityType.tokens;
    final type = widget.targetTokensAndActivityType.activityType;

    final existingActivity =
        widget.pangeaMessageEvent.practiceActivities.firstWhereOrNull(
      (activity) {
        final sameActivity = activity.practiceActivity.targetTokens != null &&
            activity.practiceActivity.activityType == type &&
            activity.practiceActivity.targetTokens!
                .map((t) => t.vocabConstructID.string)
                .toSet()
                .containsAll(
                  tokens.map((t) => t.vocabConstructID.string).toSet(),
                );
        if (type != ActivityTypeEnum.morphId || sameActivity == false) {
          return sameActivity;
        }

        return widget.morphFeature ==
            activity.practiceActivity.tgtConstructs
                .firstWhereOrNull(
                  (c) => c.type == ConstructTypeEnum.morph,
                )
                ?.category;
      },
    );

    if (existingActivity != null &&
        existingActivity.practiceActivity.content.answers.isNotEmpty &&
        !(existingActivity.practiceActivity.content.answers.length == 1 &&
            existingActivity.practiceActivity.content.answers.first.isEmpty)) {
      currentActivityCompleter = Completer();
      currentActivityCompleter!.complete(existingActivity);
      existingActivity.practiceActivity.targetTokens = tokens;
      return existingActivity.practiceActivity;
    }

    final req = MessageActivityRequest(
      userL1: MatrixState.pangeaController.languageController.userL1!.langCode,
      userL2: MatrixState.pangeaController.languageController.userL2!.langCode,
      messageText: widget.pangeaMessageEvent.messageDisplayText,
      messageTokens: widget.overlayController.tokens!,
      activityQualityFeedback: activityFeedback,
      targetTokens: tokens,
      targetType: type,
      targetMorphFeature: widget.morphFeature,
    );

    final PracticeActivityModelResponse activityResponse =
        await practiceGenerationController.getPracticeActivity(
      req,
      widget.pangeaMessageEvent,
    );

    if (activityResponse.activity == null) return null;

    currentActivityCompleter = activityResponse.eventCompleter;
    activityResponse.activity!.targetTokens = tokens;
    return activityResponse.activity;
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
      await Future.delayed(const Duration(seconds: 1));
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
  void onActivityFinish({String? correctAnswer}) async {
    try {
      if (currentCompletionRecord == null || currentActivity == null) {
        debugger(when: kDebugMode);
        return;
      }

      widget.overlayController.onActivityFinish();
      pangeaController.activityRecordController.completeActivity(
        widget.pangeaMessageEvent.eventId,
      );

      await _savorTheJoy();
      widget.wordDetailsController?.onActivityFinish(
        activityType: currentActivity!.activityType,
        correctAnswer: correctAnswer,
      );
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
    currentActivity = null;
    widget.overlayController.exitPracticeFlow();
  }

  // /// The widget that displays the current activity.
  // /// If there is no current activity, the widget returns a sizedbox with a height of 80.
  // /// If the activity type is multiple choice, the widget returns a MultipleChoiceActivity.
  // /// If the activity type is unknown, the widget logs an error and returns a text widget with an error message.
  Widget? get activityWidget {
    switch (currentActivity?.activityType) {
      case null:
        return null;
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.lemmaId:
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.morphId:
        return MultipleChoiceActivity(
          practiceCardController: this,
          currentActivity: currentActivity!,
          event: widget.pangeaMessageEvent.event,
          onError: _onError,
          overlayController: widget.overlayController,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!fetchingActivity && currentActivity == null) {
      debugPrint("don't think we should be here");
      debugger(when: kDebugMode);
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
        // Positioned(
        //   top: 0,
        //   right: 0,
        //   child: ContentIssueButton(
        //     isActive: currentActivity != null,
        //     submitFeedback: submitFeedback,
        //   ),
        // ),
      ],
    );
  }
}
