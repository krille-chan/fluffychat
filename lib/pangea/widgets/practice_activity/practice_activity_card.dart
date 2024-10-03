import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/controllers/my_analytics_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/animations/gain_points.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/multiple_choice_activity.dart';
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

  TargetTokensController targetTokensController = TargetTokensController();

  List<PracticeActivityEvent> get practiceActivities =>
      widget.pangeaMessageEvent.practiceActivities;

  // Used to show an animation when the user completes an activity
  // while simultaneously fetching a new activity and not showing the loading spinner
  // until the appropriate time has passed to 'savor the joy'
  Duration appropriateTimeForJoy = const Duration(milliseconds: 500);
  bool savoringTheJoy = false;
  Timer? joyTimer;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    joyTimer?.cancel();
    super.dispose();
  }

  void _updateFetchingActivity(bool value) {
    if (fetchingActivity == value) return;
    setState(() => fetchingActivity = value);
  }

  void _setPracticeActivity(PracticeActivityEvent? activity) {
    if (activity == null) {
      widget.overlayController.exitPracticeFlow();
      return;
    }

    currentActivity = activity;

    currentCompletionRecord = PracticeActivityRecordModel(
      question: activity.practiceActivity.question,
    );

    widget.overlayController.setSelectedSpan(currentActivity!.practiceActivity);
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

  Future<PracticeActivityEvent?> _fetchNewActivity() async {
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

  void setCompletionRecord(PracticeActivityRecordModel? recordModel) {
    currentCompletionRecord = recordModel;
  }

  /// future that simply waits for the appropriate time to savor the joy
  Future<void> _savorTheJoy() async {
    joyTimer?.cancel();
    if (savoringTheJoy) return;
    savoringTheJoy = true;
    joyTimer = Timer(appropriateTimeForJoy, () {
      savoringTheJoy = false;
      joyTimer?.cancel();
    });
  }

  /// Called when the user finishes an activity.
  /// Saves the completion record and sends it to the server.
  /// Fetches a new activity if there are any left to complete.
  /// Exits the practice flow if there are no more activities.
  void onActivityFinish() async {
    // try {
    if (currentCompletionRecord == null || currentActivity == null) {
      debugger(when: kDebugMode);
      return;
    }

    // start joy timer
    _savorTheJoy();

    final uses = currentCompletionRecord!.uses(
      currentActivity!.practiceActivity,
      ConstructUseMetaData(
        roomId: widget.pangeaMessageEvent.room.id,
        timeStamp: DateTime.now(),
      ),
    );

    // update the target tokens with the new construct uses
    await targetTokensController.updateTokensWithConstructs(
      uses,
      context,
      widget.pangeaMessageEvent,
    );

    MatrixState.pangeaController.myAnalytics.setState(
      AnalyticsStream(
        // note - this maybe should be the activity event id
        eventId: widget.pangeaMessageEvent.eventId,
        roomId: widget.pangeaMessageEvent.room.id,
        constructs: uses,
      ),
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

    _setPracticeActivity(await _fetchNewActivity());

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
    //   widget.overlayController.exitPracticeFlow();
    // }
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
    // if the user has finished all the activities to unlock the toolbar in this session
    if (widget.overlayController.finishedActivitiesThisSession) {
      return "Boom! Tools unlocked!";

      // if we have no activities to show
    } else if (!fetchingActivity && currentActivity == null) {
      return L10n.of(context)!.noActivitiesFound;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (userMessage != null) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 80,
          ),
          child: Text(
            userMessage!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
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
      ],
    );
  }
}

/// Seperated out the target tokens from the practice activity card
/// in order to control the state of the target tokens
class TargetTokensController {
  List<TokenWithXP>? _targetTokens;

  TargetTokensController();

  /// From the tokens in the message, do a preliminary filtering of which to target
  /// Then get the construct uses for those tokens
  Future<List<TokenWithXP>> targetTokens(
    BuildContext context,
    PangeaMessageEvent pangeaMessageEvent,
  ) async {
    if (_targetTokens != null) {
      return _targetTokens!;
    }

    _targetTokens = await _initialize(context, pangeaMessageEvent);

    await updateTokensWithConstructs(
      MatrixState.pangeaController.analytics.analyticsStream.value ?? [],
      context,
      pangeaMessageEvent,
    );

    return _targetTokens!;
  }

  Future<List<TokenWithXP>> _initialize(
    BuildContext context,
    PangeaMessageEvent pangeaMessageEvent,
  ) async {
    if (!context.mounted) {
      ErrorHandler.logError(
        m: 'getTargetTokens called when not mounted',
        s: StackTrace.current,
      );
      return _targetTokens = [];
    }

    final tokens = await pangeaMessageEvent
        .representationByLanguage(pangeaMessageEvent.messageDisplayLangCode)
        ?.tokensGlobal(context);

    if (tokens == null || tokens.isEmpty) {
      debugger(when: kDebugMode);
      return _targetTokens = [];
    }

    _targetTokens = [];
    for (int i = 0; i < tokens.length; i++) {
      //don't bother with tokens that we don't save to vocab
      if (!tokens[i].lemma.saveVocab) {
        continue;
      }

      _targetTokens!.add(tokens[i].emptyTokenWithXP);
    }

    return _targetTokens!;
  }

  Future<void> updateTokensWithConstructs(
    List<OneConstructUse> constructUses,
    context,
    pangeaMessageEvent,
  ) async {
    final ConstructListModel constructList = ConstructListModel(
      uses: constructUses,
      type: null,
    );

    _targetTokens ??= await _initialize(context, pangeaMessageEvent);

    for (final token in _targetTokens!) {
      for (final construct in token.constructs) {
        final constructUseModel = constructList.getConstructUses(
          construct.id.lemma,
          construct.id.type,
        );
        if (constructUseModel != null) {
          construct.xp = constructUseModel.points;
          construct.lastUsed = constructUseModel.lastUsed;
        }
      }
    }
  }
}
