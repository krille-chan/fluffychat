import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/my_analytics_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
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
  MessagePracticeActivityCardState createState() =>
      MessagePracticeActivityCardState();
}

class MessagePracticeActivityCardState extends State<PracticeActivityCard> {
  PracticeActivityEvent? currentActivity;
  PracticeActivityRecordModel? currentCompletionRecord;
  bool fetchingActivity = false;

  List<TokenWithXP> targetTokens = [];

  List<PracticeActivityEvent> get practiceActivities =>
      widget.pangeaMessageEvent.practiceActivities;

  int get practiceEventIndex => practiceActivities.indexWhere(
        (activity) => activity.event.eventId == currentActivity?.event.eventId,
      );

  /// TODO - @ggurdin - how can we start our processes (saving results and getting an activity)
  /// immediately after a correct choice but wait to display until x milliseconds after the choice is made AND
  /// we've received the new activity?
  Duration appropriateTimeForJoy = const Duration(milliseconds: 500);
  bool savoringTheJoy = false;
  Timer? joyTimer;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void updateFetchingActivity(bool value) {
    if (fetchingActivity == value) return;
    setState(() => fetchingActivity = value);
  }

  /// Get an activity to display.
  /// Show an uncompleted activity if there is one.
  /// If not, get a new activity from the server.
  Future<void> initialize() async {
    targetTokens = await getTargetTokens();

    currentActivity = _fetchExistingActivity() ?? await _fetchNewActivity();

    currentActivity == null
        ? widget.overlayController.exitPracticeFlow()
        : widget.overlayController
            .onNewActivity(currentActivity!.practiceActivity);
  }

  // TODO - do more of a check for whether we have an appropropriate activity
  // if the user did the activity before but awhile ago and we don't have any
  // more target tokens, maybe we should give them the same activity again
  PracticeActivityEvent? _fetchExistingActivity() {
    final List<PracticeActivityEvent> incompleteActivities =
        practiceActivities.where((element) => !element.isComplete).toList();

    final PracticeActivityEvent? existingActivity =
        incompleteActivities.isNotEmpty ? incompleteActivities.first : null;

    return existingActivity != null &&
            existingActivity.practiceActivity !=
                currentActivity?.practiceActivity
        ? existingActivity
        : null;
  }

  Future<PracticeActivityEvent?> _fetchNewActivity() async {
    updateFetchingActivity(true);

    if (targetTokens.isEmpty ||
        !pangeaController.languageController.languagesSet) {
      debugger(when: kDebugMode);
      updateFetchingActivity(false);
      return null;
    }

    final ourNewActivity =
        await pangeaController.practiceGenerationController.getPracticeActivity(
      MessageActivityRequest(
        userL1: pangeaController.languageController.userL1!.langCode,
        userL2: pangeaController.languageController.userL2!.langCode,
        messageText: representation!.text,
        tokensWithXP: targetTokens,
        messageId: widget.pangeaMessageEvent.eventId,
      ),
      widget.pangeaMessageEvent,
    );

    /// Removes the target tokens of the new activity from the target tokens list.
    /// This avoids getting activities for the same token again, at least
    /// until the user exists the toolbar and re-enters it. By then, the
    /// analytics stream will have updated and the user will be able to get
    /// activity data for previously targeted tokens. This should then exclude
    /// the tokens that were targeted in previous activities based on xp and lastUsed.
    if (ourNewActivity?.practiceActivity.relevantSpanDisplayDetails != null) {
      targetTokens.removeWhere((token) {
        final RelevantSpanDisplayDetails span =
            ourNewActivity!.practiceActivity.relevantSpanDisplayDetails!;
        return token.token.text.offset >= span.offset &&
            token.token.text.offset + token.token.text.length <=
                span.offset + span.length;
      });
    }

    updateFetchingActivity(false);

    return ourNewActivity;
  }

  /// From the tokens in the message, do a preliminary filtering of which to target
  /// Then get the construct uses for those tokens
  Future<List<TokenWithXP>> getTargetTokens() async {
    if (!mounted) {
      ErrorHandler.logError(
        m: 'getTargetTokens called when not mounted',
        s: StackTrace.current,
      );
      return [];
    }

    // we're just going to set this once per session
    // we remove the target tokens when we get a new activity
    if (targetTokens.isNotEmpty) return targetTokens;

    if (representation == null) {
      debugger(when: kDebugMode);
      return [];
    }
    final tokens = await representation?.tokensGlobal(context);

    if (tokens == null || tokens.isEmpty) {
      debugger(when: kDebugMode);
      return [];
    }

    var constructUses =
        MatrixState.pangeaController.analytics.analyticsStream.value;

    if (constructUses == null || constructUses.isEmpty) {
      constructUses = [];
      //@gurdin - this is happening for me with a brand-new user. however, in this case, constructUses should be empty list
      debugger(when: kDebugMode);
    }

    final ConstructListModel constructList = ConstructListModel(
      uses: constructUses,
      type: null,
    );

    final List<TokenWithXP> tokenCounts = [];

    // TODO - add morph constructs to this list as well
    for (int i = 0; i < tokens.length; i++) {
      //don't bother with tokens that we don't save to vocab
      if (!tokens[i].lemma.saveVocab) {
        continue;
      }

      tokenCounts.add(tokens[i].emptyTokenWithXP);

      for (final construct in tokenCounts.last.constructs) {
        final constructUseModel = constructList.getConstructUses(
          construct.id.lemma,
          construct.id.type,
        );
        if (constructUseModel != null) {
          construct.xp = constructUseModel.points;
        }
      }
    }

    tokenCounts.sort((a, b) => a.xp.compareTo(b.xp));

    return tokenCounts;
  }

  void setCompletionRecord(PracticeActivityRecordModel? recordModel) {
    currentCompletionRecord = recordModel;
  }

  /// future that simply waits for the appropriate time to savor the joy
  Future<void> savorTheJoy() async {
    joyTimer?.cancel();
    if (savoringTheJoy) return;
    savoringTheJoy = true;
    joyTimer = Timer(appropriateTimeForJoy, () {
      savoringTheJoy = false;
      joyTimer?.cancel();
    });
  }

  /// Sends the current record model and activity to the server.
  /// If either the currentRecordModel or currentActivity is null, the method returns early.
  /// If the currentActivity is the last activity, the method sets the appropriate flag to true.
  /// If the currentActivity is not the last activity, the method fetches a new activity.
  void onActivityFinish() async {
    try {
      if (currentCompletionRecord == null || currentActivity == null) {
        debugger(when: kDebugMode);
        return;
      }

      // start joy timer
      savorTheJoy();

      // if this is the last activity, set the flag to true
      // so we can give them some kudos
      if (widget.overlayController.activitiesLeftToComplete == 1) {
        widget.overlayController.finishedActivitiesThisSession = true;
      }

      final Event? event = await MatrixState
          .pangeaController.activityRecordController
          .send(currentCompletionRecord!, currentActivity!);

      MatrixState.pangeaController.myAnalytics.setState(
        AnalyticsStream(
          eventId: widget.pangeaMessageEvent.eventId,
          eventType: PangeaEventTypes.activityRecord,
          roomId: event!.room.id,
          practiceActivity: currentActivity!,
          recordModel: currentCompletionRecord!,
        ),
      );

      if (!widget.overlayController.finishedActivitiesThisSession) {
        currentActivity = await _fetchNewActivity();

        currentActivity == null
            ? widget.overlayController.exitPracticeFlow()
            : widget.overlayController
                .onNewActivity(currentActivity!.practiceActivity);
      } else {
        updateFetchingActivity(false);
        widget.overlayController.setState(() {});
      }
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        m: 'Failed to send record for activity',
        data: {
          'activity': currentActivity,
          'record': currentCompletionRecord,
        },
      );
      widget.overlayController.exitPracticeFlow();
    }
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
