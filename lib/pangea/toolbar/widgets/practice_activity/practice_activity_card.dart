import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/gain_points_animation.dart';
import 'package:fluffychat/pangea/analytics_misc/message_analytics_controller.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/card_error_widget.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/toolbar/models/message_activity_request.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_model.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/toolbar/repo/practice_repo.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/multiple_choice_activity.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/word_zoom_widget.dart';
import 'package:fluffychat/widgets/matrix.dart';

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
  String? _error;

  String? activityQuestion;

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
    _error = null;
    if (!mounted ||
        !pangeaController.languageController.languagesSet ||
        widget.overlayController.messageAnalyticsEntry == null) {
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
        question: mounted
            ? currentActivity?.question(context, widget.morphFeature)
            : currentActivity?.content.question,
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
      _error = e.toString();
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
        final sameActivity =
            activity.practiceActivity.content.choices.toSet().containsAll(
                      activity.practiceActivity.content.answers.toSet(),
                    ) &&
                activity.practiceActivity.targetTokens != null &&
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
      context,
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

  final Duration _savorTheJoyDuration = const Duration(seconds: 1);

  Future<void> _savorTheJoy() async {
    try {
      debugger(when: savoringTheJoy && kDebugMode);

      if (mounted) setState(() => savoringTheJoy = true);
      await Future.delayed(_savorTheJoyDuration);
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

      widget.wordDetailsController?.onActivityFinish(
        savorTheJoyDuration: _savorTheJoyDuration,
      );

      pangeaController.activityRecordController.completeActivity(
        widget.pangeaMessageEvent.eventId,
      );

      await _savorTheJoy();

      // wait for savor the joy before popping from the activity queue
      // to keep the completed activity on screen for a moment
      widget.overlayController.onActivityFinish(currentActivity!.activityType);
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
      case ActivityTypeEnum.messageMeaning:
        final selectedChoice =
            currentActivity?.activityType == ActivityTypeEnum.emoji &&
                    (currentActivity?.targetTokens?.isNotEmpty ?? false)
                ? currentActivity?.targetTokens?.first.getEmoji()
                : null;
        return MultipleChoiceActivity(
          practiceCardController: this,
          currentActivity: currentActivity!,
          event: widget.pangeaMessageEvent.event,
          onError: _onError,
          overlayController: widget.overlayController,
          initialSelectedChoice: selectedChoice,
          clearResponsesOnUpdate:
              currentActivity?.activityType == ActivityTypeEnum.emoji,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      debugger(when: kDebugMode);
      return CardErrorWidget(
        error: _error!,
        maxWidth: 500,
      );
    }

    if (!fetchingActivity && currentActivity == null) {
      debugPrint("don't think we should be here");
      debugger(when: kDebugMode);
      return CardErrorWidget(
        error: _error!,
        maxWidth: 500,
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
