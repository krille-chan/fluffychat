import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix_api_lite/model/message_types.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_audio_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_meaning_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_mode_locked_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_speech_to_text_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_translation_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_unsubscribed_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/word_zoom_widget.dart';
import 'package:fluffychat/widgets/matrix.dart';

const double minCardHeight = 70;

class MessageToolbar extends StatelessWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overlayController;

  const MessageToolbar({
    super.key,
    required this.pangeaMessageEvent,
    required this.overlayController,
  });

  TtsController get ttsController =>
      overlayController.widget.chatController.choreographer.tts;

  Widget? toolbarContent(BuildContext context) {
    final bool subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;

    if (!subscribed) {
      return MessageUnsubscribedCard(
        controller: overlayController,
      );
    }

    if ((overlayController.messageAnalyticsEntry?.hasHiddenWordActivity ??
            false) ||
        (overlayController.messageAnalyticsEntry?.hasMessageMeaningActivity ??
            false)) {
      return PracticeActivityCard(
        pangeaMessageEvent: pangeaMessageEvent,
        overlayController: overlayController,
        targetTokensAndActivityType:
            overlayController.messageAnalyticsEntry!.nextActivity!,
      );
    }

    if (!overlayController.initialized) {
      return const ToolbarContentLoadingIndicator();
    }

    final unlocked = overlayController.toolbarMode.isUnlocked(
      overlayController.pangeaMessageEvent!.proportionOfActivitiesCompleted,
      overlayController.isPracticeComplete,
    );

    if (!unlocked) {
      return MessageModeLockedCard(controller: overlayController);
    }

    switch (overlayController.toolbarMode) {
      case MessageMode.translation:
        return MessageTranslationCard(
          messageEvent: pangeaMessageEvent,
          selection: overlayController.selectedSpan,
        );
      case MessageMode.textToSpeech:
        return MessageAudioCard(
          messageEvent: pangeaMessageEvent,
          overlayController: overlayController,
          selection: overlayController.selectedSpan,
          tts: ttsController,
          setIsPlayingAudio: overlayController.setIsPlayingAudio,
        );
      case MessageMode.speechToText:
        return MessageSpeechToTextCard(
          messageEvent: pangeaMessageEvent,
        );
      case MessageMode.noneSelected:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            L10n.of(context).clickWordsInstructions,
            textAlign: TextAlign.center,
          ),
        );
      case MessageMode.messageMeaning:
        return MessageMeaningCard(controller: overlayController);
      case MessageMode.practiceActivity:
      case MessageMode.wordZoom:
        if (overlayController.selectedToken == null) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              L10n.of(context).clickWordsInstructions,
              textAlign: TextAlign.center,
            ),
          );
        }
        return WordZoomWidget(
          token: overlayController.selectedToken!,
          messageEvent: overlayController.pangeaMessageEvent!,
          tts: ttsController,
          overlayController: overlayController,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (![MessageTypes.Text, MessageTypes.Audio].contains(
      pangeaMessageEvent.event.messageType,
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
              duration: FluffyThemes.animationDuration,
              child: toolbarContent(context),
            ),
          ],
        ),
      ),
    );
  }
}
