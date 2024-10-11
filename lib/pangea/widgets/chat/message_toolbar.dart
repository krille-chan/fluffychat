import 'dart:developer';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/message_audio_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/chat/message_speech_to_text_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_translation_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_unsubscribed_card.dart';
import 'package:fluffychat/pangea/widgets/igc/word_data_card.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/widgets/select_to_define.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double minCardHeight = 70;

class MessageToolbar extends StatelessWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overLayController;

  const MessageToolbar({
    super.key,
    required this.pangeaMessageEvent,
    required this.overLayController,
  });

  Widget get toolbarContent {
    final bool subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;

    if (!subscribed) {
      return MessageUnsubscribedCard(
        controller: overLayController,
      );
    }

    switch (overLayController.toolbarMode) {
      case MessageMode.translation:
        return MessageTranslationCard(
          messageEvent: pangeaMessageEvent,
          selection: overLayController.selectedSpan,
        );
      case MessageMode.textToSpeech:
        return MessageAudioCard(
          messageEvent: pangeaMessageEvent,
          overlayController: overLayController,
        );
      case MessageMode.speechToText:
        return MessageSpeechToTextCard(
          messageEvent: pangeaMessageEvent,
        );
      case MessageMode.definition:
        if (!overLayController.isSelection) {
          return const SelectToDefine();
        } else {
          try {
            final selectedText = overLayController.targetText;

            return WordDataCard(
              word: selectedText,
              wordLang: pangeaMessageEvent.messageDisplayLangCode,
              fullText: pangeaMessageEvent.messageDisplayText,
              fullTextLang: pangeaMessageEvent.messageDisplayLangCode,
              hasInfo: true,
              room: overLayController.widget.chatController.room,
            );
          } catch (e, s) {
            debugger(when: kDebugMode);
            ErrorHandler.logError(
              e: "Error in WordDataCard",
              s: s,
              data: {
                "word": overLayController.targetText,
                "fullText": pangeaMessageEvent.messageDisplayText,
              },
            );
            return const SizedBox();
          }
        }
      case MessageMode.practiceActivity:
        return PracticeActivityCard(
          pangeaMessageEvent: pangeaMessageEvent,
          overlayController: overLayController,
        );
      default:
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          e: "Invalid toolbar mode",
          s: StackTrace.current,
          data: {"newMode": overLayController.toolbarMode},
        );
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: MatrixState.pAnyState
          .layerLinkAndKey('${pangeaMessageEvent.eventId}-toolbar')
          .key,
      type: MaterialType.transparency,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConfig.borderRadius),
              ),
            ),
            constraints: const BoxConstraints(
              maxHeight: AppConfig.toolbarMaxHeight,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: AnimatedSize(
                      duration: FluffyThemes.animationDuration,
                      child: toolbarContent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
