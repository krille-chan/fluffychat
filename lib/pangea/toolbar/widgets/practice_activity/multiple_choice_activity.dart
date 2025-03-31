import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_array.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_record.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
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

  PracticeRecord? get currentRecordModel =>
      widget.practiceCardController.currentCompletionRecord;

  @override
  void initState() {
    super.initState();
    if (widget.currentActivity.multipleChoiceContent == null) {
      throw Exception(
        "MultipleChoiceActivityState: currentActivity.multipleChoiceContent is null",
      );
    }
    if (widget.initialSelectedChoice != null) {
      currentRecordModel?.addResponse(
        target: widget.currentActivity.practiceTarget,
        cId: widget.currentActivity.morphFeature == null
            ? widget.currentActivity.targetTokens.first.vocabConstructID
            : widget.currentActivity.targetTokens.first
                .morphIdByFeature(widget.currentActivity.morphFeature!)!,
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
        widget.currentActivity.multipleChoiceContent!.isCorrect(value, index);

    if (currentRecordModel?.hasTextResponse(value) ?? false) {
      return;
    }

    if (widget.clearResponsesOnUpdate) {
      currentRecordModel?.clearResponses();
    }

    currentRecordModel?.addResponse(
      target: widget.currentActivity.practiceTarget,
      cId: widget.currentActivity.morphFeature == null
          ? widget.currentActivity.targetTokens.first.vocabConstructID
          : widget.currentActivity.targetTokens.first
              .morphIdByFeature(widget.currentActivity.morphFeature!)!,
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
      ),
    );

    // If the selected choice is correct, send the record
    if (widget.currentActivity.multipleChoiceContent!.isCorrect(value, index)) {
      // If the activity is an emoji activity, set the emoji value

      // TODO: this widget is deprecated for use with emoji activities
      // if (widget.currentActivity.activityType == ActivityTypeEnum.emoji) {
      //   if (widget.currentActivity.targetTokens?.length != 1) {
      //     debugger(when: kDebugMode);
      //   } else {
      //     widget.currentActivity.targetTokens!.first.setEmoji(value);
      //   }
      // }

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
    final activity = widget.currentActivity.multipleChoiceContent;
    final List<Choice> choices = [];
    for (int i = 0; i < activity!.choices.length; i++) {
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
    final morphFeature = widget
        .practiceCardController.widget.targetTokensAndActivityType.morphFeature;
    if (morphFeature == null) return value;

    return getGrammarCopy(
          category: morphFeature.name,
          lemma: value,
          context: context,
        ) ??
        value;
  }

  @override
  Widget build(BuildContext context) {
    final PracticeActivityModel practiceActivity = widget.currentActivity;
    final question = practiceActivity.multipleChoiceContent!.question;

    // if (ActivityTypeEnum.emoji == practiceActivity.activityType) {
    //   return WordEmojiChoiceRow(
    //     activity: practiceActivity,
    //     selectedChoiceIndex: selectedChoiceIndex,
    //     onTap: updateChoice,
    //   );
    // }

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
            text: practiceActivity.multipleChoiceContent!.answers.first,
          ),
        if (practiceActivity.activityType ==
            ActivityTypeEnum.hiddenWordListening)
          MessageAudioCard(
            messageEvent:
                widget.practiceCardController.widget.pangeaMessageEvent,
            overlayController: widget.overlayController,
            setIsPlayingAudio: widget.overlayController.setIsPlayingAudio,
            onError: widget.onError,
          ),
        ChoicesArray(
          isLoading: false,
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

    return ConstrainedBox(
      constraints: const BoxConstraints(
        // see https://github.com/pangeachat/client/issues/1422
        maxWidth: AppConfig.toolbarMinWidth,
        maxHeight: AppConfig.toolbarMaxHeight,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: content,
        ),
      ),
    );
  }
}
