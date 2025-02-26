import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_array.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_model.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_audio_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// The multiple choice activity view
class MultipleChoiceActivity extends StatefulWidget {
  final PracticeActivityCardState practiceCardController;
  final PracticeActivityModel currentActivity;
  final Event event;
  final VoidCallback? onError;
  final MessageOverlayController overlayController;
  final String? initialSelectedChoice;
  final bool clearResponsesOnUpdate;

  const MultipleChoiceActivity({
    super.key,
    required this.practiceCardController,
    required this.currentActivity,
    required this.event,
    required this.overlayController,
    this.initialSelectedChoice,
    this.clearResponsesOnUpdate = false,
    this.onError,
  });

  @override
  MultipleChoiceActivityState createState() => MultipleChoiceActivityState();
}

class MultipleChoiceActivityState extends State<MultipleChoiceActivity> {
  int? selectedChoiceIndex;

  PracticeActivityRecordModel? get currentRecordModel =>
      widget.practiceCardController.currentCompletionRecord;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedChoice != null) {
      currentRecordModel?.addResponse(
        text: widget.initialSelectedChoice,
        score: 1,
      );
    }
  }

  @override
  void didUpdateWidget(covariant MultipleChoiceActivity oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentActivity.hashCode != oldWidget.currentActivity.hashCode) {
      setState(() => selectedChoiceIndex = null);
    }
  }

  TtsController get tts =>
      widget.overlayController.widget.chatController.choreographer.tts;

  void updateChoice(String value, int index) {
    final bool isCorrect =
        widget.currentActivity.content.isCorrect(value, index);

    // // If the activity is not set to include TTS on click, and the choice is correct, speak the target tokens
    // // We have to check if tokens
    // if (!widget.currentActivity.activityType.includeTTSOnClick &&
    //     isCorrect &&
    //     mounted) {
    //   // should be set by now but just in case we make a mistake
    //   if (widget.practiceCardController.currentActivity?.targetTokens == null) {
    //     debugger(when: kDebugMode);
    //     ErrorHandler.logError(
    //       e: "Missing target tokens in multiple choice activity",
    //       data: {
    //         "currentActivity": widget.practiceCardController.currentActivity,
    //       },
    //     );
    //   } else {
    //     tts.tryToSpeak(
    //       PangeaToken.reconstructText(
    //         widget.practiceCardController.currentActivity!.targetTokens!,
    //       ),
    //       context,
    //       null,
    //     );
    //   }
    // }

    if (currentRecordModel?.hasTextResponse(value) ?? false) {
      return;
    }

    if (widget.clearResponsesOnUpdate) {
      currentRecordModel?.clearResponses();
    }

    currentRecordModel?.addResponse(
      text: value,
      score: isCorrect ? 1 : 0,
    );

    if (currentRecordModel == null ||
        currentRecordModel?.latestResponse == null ||
        widget.practiceCardController.currentActivity == null) {
      ErrorHandler.logError(
        e: "Missing necessary information to send analytics in multiple choice activity",
        data: {
          "currentRecordModel": currentRecordModel,
          "latestResponse": currentRecordModel?.latestResponse,
          "currentActivity": widget.practiceCardController.currentActivity,
        },
      );
      debugger(when: kDebugMode);
      return;
    }

    MatrixState.pangeaController.putAnalytics.setState(
      AnalyticsStream(
        // note - this maybe should be the activity event id
        eventId:
            widget.practiceCardController.widget.pangeaMessageEvent.eventId,
        roomId: widget.practiceCardController.widget.pangeaMessageEvent.room.id,
        constructs: currentRecordModel!.latestResponse!.toUses(
          widget.practiceCardController.currentActivity!,
          widget.practiceCardController.metadata,
        ),
        origin: AnalyticsUpdateOrigin.practiceActivity,
      ),
    );

    // If the selected choice is correct, send the record and get the next activity
    if (widget.currentActivity.content.isCorrect(value, index)) {
      // If the activity is an emoji activity, set the emoji value
      if (widget.currentActivity.activityType == ActivityTypeEnum.emoji) {
        if (widget.currentActivity.targetTokens?.length != 1) {
          debugger(when: kDebugMode);
        } else {
          widget.currentActivity.targetTokens!.first.setEmoji(value);
        }
      }

      // The next entry in the analytics stream should be from the above putAnalytics.setState.
      // So we can wait for the stream to update before calling onActivityFinish.
      final streamFuture = MatrixState
          .pangeaController.getAnalytics.analyticsStream.stream.first;
      streamFuture.then((_) {
        widget.practiceCardController.onActivityFinish();
      });
    }

    if (mounted) {
      setState(
        () => selectedChoiceIndex = index,
      );
    }
  }

  List<Choice> choices(BuildContext context) {
    final activity = widget.currentActivity.content;
    final List<Choice> choices = [];
    for (int i = 0; i < activity.choices.length; i++) {
      final String value = activity.choices[i];
      final color = currentRecordModel?.hasTextResponse(value) ?? false
          ? activity.choiceColor(i)
          : null;
      final isGold = activity.isCorrect(value, i);
      choices.add(
        Choice(
          text: value,
          color: color,
          isGold: isGold,
        ),
      );
    }
    return choices;
  }

  String _getDisplayCopy(String value) {
    if (widget.currentActivity.activityType != ActivityTypeEnum.morphId) {
      return value;
    }
    final morphFeature = widget.practiceCardController.widget.morphFeature;
    if (morphFeature == null) return value;
    return getGrammarCopy(
          category: morphFeature,
          lemma: value,
          context: context,
        ) ??
        value;
  }

  @override
  Widget build(BuildContext context) {
    final PracticeActivityModel practiceActivity = widget.currentActivity;
    final question = practiceActivity.content.question;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (question.isNotEmpty)
          Text(
            question,
            textAlign: TextAlign.center,
            style: AppConfig.messageTextStyle(
              widget.event,
              Theme.of(context).colorScheme.primary,
            ).merge(const TextStyle(fontStyle: FontStyle.italic)),
          ),
        if (question.isNotEmpty) const SizedBox(height: 8.0),
        const SizedBox(height: 8),
        if (practiceActivity.activityType ==
            ActivityTypeEnum.wordFocusListening)
          WordAudioButton(
            text: practiceActivity.content.answers.first,
            ttsController: tts,
          ),
        if (practiceActivity.activityType ==
            ActivityTypeEnum.hiddenWordListening)
          MessageAudioCard(
            messageEvent:
                widget.practiceCardController.widget.pangeaMessageEvent,
            overlayController: widget.overlayController,
            tts: tts,
            setIsPlayingAudio: widget.overlayController.setIsPlayingAudio,
            onError: widget.onError,
          ),
        ChoicesArray(
          isLoading: false,
          uniqueKeyForLayerLink: (index) => "multiple_choice_$index",
          originalSpan: "placeholder",
          onPressed: updateChoice,
          selectedChoiceIndex: selectedChoiceIndex,
          choices: choices(context),
          isActive: true,
          id: currentRecordModel?.hashCode.toString(),
          tts: practiceActivity.activityType.includeTTSOnClick ? tts : null,
          enableAudio: !widget.overlayController.isPlayingAudio,
          getDisplayCopy: _getDisplayCopy,
          enableMultiSelect:
              widget.currentActivity.activityType == ActivityTypeEnum.emoji,
        ),
      ],
    );

    return practiceActivity.activityType ==
                ActivityTypeEnum.hiddenWordListening ||
            practiceActivity.activityType == ActivityTypeEnum.messageMeaning
        ? ConstrainedBox(
            constraints: const BoxConstraints(
              // see https://github.com/pangeachat/client/issues/1422
              maxWidth: AppConfig.toolbarMinWidth,
              maxHeight: AppConfig.toolbarMaxHeight,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: content,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(20),
            child: content,
          );
  }
}
