import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix_api_lite/model/message_types.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_unsubscribed_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/word_zoom_widget.dart';
import 'package:fluffychat/widgets/matrix.dart';

const double minCardHeight = 70;

class ReadingAssistanceContent extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overlayController;
  final Duration animationDuration;

  const ReadingAssistanceContent({
    super.key,
    required this.pangeaMessageEvent,
    required this.overlayController,
    this.animationDuration = FluffyThemes.animationDuration,
  });

  @override
  ReadingAssistanceContentState createState() =>
      ReadingAssistanceContentState();
}

class ReadingAssistanceContentState extends State<ReadingAssistanceContent> {
  TtsController get ttsController =>
      widget.overlayController.widget.chatController.choreographer.tts;

  Widget? toolbarContent(BuildContext context) {
    final bool? subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;

    if (subscribed != null && !subscribed) {
      return MessageUnsubscribedCard(
        controller: widget.overlayController,
      );
    }

    if (widget.overlayController.practiceSelection?.hasHiddenWordActivity ??
        false) {
      return PracticeActivityCard(
        pangeaMessageEvent: widget.pangeaMessageEvent,
        overlayController: widget.overlayController,
        targetTokensAndActivityType: widget.overlayController.practiceSelection!
            .nextActivity(ActivityTypeEnum.hiddenWordListening)!,
      );
    }

    if (widget.overlayController.practiceSelection?.hasMessageMeaningActivity ??
        false) {
      return PracticeActivityCard(
        pangeaMessageEvent: widget.pangeaMessageEvent,
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
          token: widget.overlayController.selectedToken!,
          messageEvent: widget.overlayController.pangeaMessageEvent!,
          tts: ttsController,
          overlayController: widget.overlayController,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (![MessageTypes.Text, MessageTypes.Audio].contains(
      widget.pangeaMessageEvent.event.messageType,
    )) {
      return const SizedBox();
    }

    return SelectionArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppConfig.borderRadius),
          ),
        ),
        constraints: const BoxConstraints(
          maxHeight: AppConfig.toolbarMaxHeight,
          minWidth: AppConfig.toolbarMinWidth,
          minHeight: AppConfig.toolbarMinHeight,
          // maxWidth is set by MessageSelectionOverlay
        ),
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
    );
  }
}
