import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/card_error_widget.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/message_activity_request.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_generation_repo.dart';
import 'package:fluffychat/pangea/practice_activities/practice_record.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';
import 'package:fluffychat/pangea/toolbar/event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/message_morph_choice.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/practice_match_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/multiple_choice_activity.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// The wrapper for practice activity content.
/// Handles the activities associated with a message,
/// their navigation, and the management of completion records
class PracticeActivityCard extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final PracticeTarget targetTokensAndActivityType;
  final MessageOverlayController overlayController;

  const PracticeActivityCard({
    super.key,
    required this.pangeaMessageEvent,
    required this.targetTokensAndActivityType,
    required this.overlayController,
  });

  @override
  PracticeActivityCardState createState() => PracticeActivityCardState();
}

class PracticeActivityCardState extends State<PracticeActivityCard> {
  bool fetchingActivity = false;
  bool savoringTheJoy = false;

  Completer<PracticeActivityEvent?>? currentActivityCompleter;

  PracticeRepo practiceGenerationController = PracticeRepo();

  PangeaController get pangeaController => MatrixState.pangeaController;
  String? _error;

  PracticeActivityModel? get currentActivity =>
      widget.overlayController.activity;

  PracticeRecord? get currentCompletionRecord => currentActivity?.record;

  @override
  void initState() {
    _fetchActivity();
    super.initState();
  }

  @override
  void didUpdateWidget(PracticeActivityCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetTokensAndActivityType !=
        widget.targetTokensAndActivityType) {
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
        widget.overlayController.practiceSelection == null) {
      _updateFetchingActivity(false);
      return;
    }

    try {
      _updateFetchingActivity(true);
      final activity = await _fetchActivityModel(
        activityFeedback: activityFeedback,
      );

      if (activity == null) {
        widget.overlayController.exitPracticeFlow();
        return;
      }

      widget.overlayController
          .setState(() => widget.overlayController.activity = activity);
    } catch (e, s) {
      debugPrint(
        "Error fetching activity: $e",
      );
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
          'morphFeature': widget.targetTokensAndActivityType.morphFeature,
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
    debugger(when: kDebugMode);
    // check if we already have an activity matching the specs
    final tokens = widget.targetTokensAndActivityType.tokens;
    final type = widget.targetTokensAndActivityType.activityType;
    final morph = widget.targetTokensAndActivityType.morphFeature;

    // final existingActivity =
    //     widget.pangeaMessageEvent.practiceActivities.firstWhereOrNull(
    //   (activity) =>
    //       activity.practiceActivity.activityType == type &&
    //       const ListEquality()
    //           .equals(widget.targetTokensAndActivityType.tokens, tokens) &&
    //       activity.practiceActivity.morphFeature == morph,
    // );

    // if (existingActivity != null) {
    //   currentActivityCompleter = Completer();
    //   currentActivityCompleter!.complete(existingActivity);
    //   existingActivity.practiceActivity.targetTokens = tokens;
    //   return existingActivity.practiceActivity;
    // }

    final req = MessageActivityRequest(
      userL1: MatrixState.pangeaController.languageController.userL1!.langCode,
      userL2: MatrixState.pangeaController.languageController.userL2!.langCode,
      messageText: widget.pangeaMessageEvent.messageDisplayText,
      messageTokens:
          widget.pangeaMessageEvent.messageDisplayRepresentation?.tokens ?? [],
      activityQualityFeedback: activityFeedback,
      targetTokens: tokens,
      targetType: type,
      targetMorphFeature: morph,
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

      await _savorTheJoy();

      // wait for savor the joy before popping from the activity queue
      // to keep the completed activity on screen for a moment
      widget.overlayController
          .onActivityFinish(currentActivity!.activityType, null);

      widget.overlayController.widget.chatController.choreographer.tts.stop();
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
    // widget.overlayController.practiceSelection?.revealAllTokens();
    // widget.overlayController.activity = null;
    // widget.overlayController.exitPracticeFlow();
  }

  // /// The widget that displays the current activity.
  // /// If there is no current activity, the widget returns a sizedbox with a height of 80.
  // /// If the activity type is multiple choice, the widget returns a MultipleChoiceActivity.
  // /// If the activity type is unknown, the widget logs an error and returns a text widget with an error message.
  Widget? get activityWidget {
    if (currentActivity == null) {
      return null;
    }
    if (currentActivity!.multipleChoiceContent != null) {
      if (currentActivity!.activityType == ActivityTypeEnum.morphId) {
        return MessageMorphInputBarContent(
          overlayController: widget.overlayController,
          activity: currentActivity!,
          pangeaMessageEvent: widget.overlayController.pangeaMessageEvent!,
        );
      }
      return MultipleChoiceActivity(
        practiceCardController: this,
        currentActivity: currentActivity!,
        event: widget.pangeaMessageEvent.event,
        onError: _onError,
        overlayController: widget.overlayController,
        // initialSelectedChoice: selectedChoice,
        initialSelectedChoice: null,
        clearResponsesOnUpdate:
            currentActivity?.activityType == ActivityTypeEnum.emoji,
      );
    }
    if (currentActivity!.matchContent != null) {
      return MatchActivityCard(
        currentActivity: currentActivity!,
        overlayController: widget.overlayController,
      );
    }
    debugger(when: kDebugMode);
    return const Text("No activity found");
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (activityWidget != null && !fetchingActivity) activityWidget!,
        // Conditionally show the darkening and progress indicator based on the loading state
        if (!savoringTheJoy && fetchingActivity) ...[
          // Circular progress indicator in the center
          const ToolbarContentLoadingIndicator(
            height: 40,
          ),
        ],
      ],
    );
  }
}
