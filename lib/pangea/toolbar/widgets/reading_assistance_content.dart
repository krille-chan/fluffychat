import 'dart:math';

import 'package:flutter/material.dart';

import 'package:matrix/matrix_api_lite/model/message_types.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_unsubscribed_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/word_zoom_widget.dart';
import 'package:fluffychat/widgets/matrix.dart';

const double minCardHeight = 70;

class ReadingAssistanceContent extends StatefulWidget {
  final MessageOverlayController overlayController;
  final Duration animationDuration;

  const ReadingAssistanceContent({
    super.key,
    required this.overlayController,
    this.animationDuration = FluffyThemes.animationDuration,
  });

  @override
  ReadingAssistanceContentState createState() =>
      ReadingAssistanceContentState();
}

class ReadingAssistanceContentState extends State<ReadingAssistanceContent> {
  Widget? toolbarContent(BuildContext context) {
    final bool? subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;

    if (subscribed != null && !subscribed) {
      return const MessageUnsubscribedCard();
    }

    if (widget.overlayController.practiceSelection?.hasHiddenWordActivity ??
        false) {
      return PracticeActivityCard(
        overlayController: widget.overlayController,
        targetTokensAndActivityType: widget.overlayController.practiceSelection!
            .nextActivity(ActivityTypeEnum.hiddenWordListening)!,
      );
    }

    if (widget.overlayController.practiceSelection?.hasMessageMeaningActivity ??
        false) {
      return PracticeActivityCard(
        overlayController: widget.overlayController,
        targetTokensAndActivityType: widget.overlayController.practiceSelection!
            .nextActivity(ActivityTypeEnum.messageMeaning)!,
      );
    }

    if (!widget.overlayController.initialized) {
      return const ToolbarContentLoadingIndicator();
    }

    // final unlocked = widget.overlayController.toolbarMode
    //     .isUnlocked(widget.overlayController);

    // if (!unlocked) {
    //   return MessageModeLockedCard(controller: widget.overlayController);
    // }

    switch (widget.overlayController.toolbarMode) {
      case MessageMode.messageTranslation:
      // return MessageTranslationCard(
      //   messageEvent: widget.pangeaMessageEvent,
      // );
      case MessageMode.messageSpeechToText:
      // return MessageSpeechToTextCard(
      //   messageEvent: widget.pangeaMessageEvent,
      // );
      case MessageMode.noneSelected:
      // return Padding(
      //   padding: const EdgeInsets.all(8),
      //   child: Text(
      //     L10n.of(context).clickWordsInstructions,
      //     textAlign: TextAlign.center,
      //   ),
      // );
      case MessageMode.messageMeaning:
      // return MessageMeaningCard(controller: widget.overlayController);
      case MessageMode.listening:
      // return MessageAudioCard(
      //     messageEvent: widget.overlayController.pangeaMessageEvent!,
      //     overlayController: widget.overlayController,
      //     setIsPlayingAudio: widget.overlayController.setIsPlayingAudio);
      case MessageMode.practiceActivity:
      case MessageMode.wordZoom:
      case MessageMode.wordEmoji:
      case MessageMode.wordMorph:
      case MessageMode.wordMeaning:
        if (widget.overlayController.selectedToken == null) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              L10n.of(context).clickWordsInstructions,
              textAlign: TextAlign.center,
            ),
          );
        }
        return WordZoomWidget(
          key: MatrixState.pAnyState
              .layerLinkAndKey(
                "word-zoom-card-${widget.overlayController.selectedToken!.text.uniqueKey}",
              )
              .key,
          token: widget.overlayController.selectedToken!.text,
          construct: widget.overlayController.selectedToken!.vocabConstructID,
          event: widget.overlayController.event,
          wordIsNew: widget.overlayController
              .isNewToken(widget.overlayController.selectedToken!),
          onClose: () => widget.overlayController.updateSelectedSpan(null),
          langCode: widget
              .overlayController.pangeaMessageEvent.messageDisplayLangCode,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (![MessageTypes.Text, MessageTypes.Audio].contains(
      widget.overlayController.pangeaMessageEvent.event.messageType,
    )) {
      return const SizedBox();
    }

    return Material(
      type: MaterialType.transparency,
      child: SelectionArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 4.0,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppConfig.borderRadius),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: min(
              AppConfig.toolbarMinWidth,
              widget.overlayController.maxWidth,
            ),
            maxWidth: widget.overlayController.maxWidth,
          ),
          height: AppConfig.toolbarMaxHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSize(
                duration: widget.animationDuration,
                child: toolbarContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
