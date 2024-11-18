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
import 'package:fluffychat/pangea/widgets/chat/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/widgets/chat/tts_controller.dart';
import 'package:fluffychat/pangea/widgets/igc/card_error_widget.dart';
import 'package:fluffychat/pangea/widgets/igc/word_data_card.dart';
import 'package:fluffychat/pangea/widgets/message_display_card.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

const double minCardHeight = 70;

class MessageToolbar extends StatelessWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overLayController;
  final TtsController ttsController;

  const MessageToolbar({
    super.key,
    required this.pangeaMessageEvent,
    required this.overLayController,
    required this.ttsController,
  });

  Widget toolbarContent(BuildContext context) {
    final bool subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;

    if (!subscribed) {
      return MessageUnsubscribedCard(
        controller: overLayController,
      );
    }

    if (!overLayController.initialized) {
      return const ToolbarContentLoadingIndicator();
    }

    // Check if the message is in the user's second language
    final bool messageInUserL2 = pangeaMessageEvent.messageDisplayLangCode ==
        MatrixState.pangeaController.languageController.userL2?.langCode;

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
          selection: overLayController.selectedSpan,
          tts: ttsController,
          setIsPlayingAudio: overLayController.setIsPlayingAudio,
        );
      case MessageMode.speechToText:
        return MessageSpeechToTextCard(
          messageEvent: pangeaMessageEvent,
        );
      case MessageMode.definition:
        if (!overLayController.isSelection) {
          return FutureBuilder(
            //TODO - convert this to synchronous if possible
            future: Future.value(
              pangeaMessageEvent.messageDisplayRepresentation?.tokens,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const ToolbarContentLoadingIndicator();
              } else if (snapshot.hasError ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8),
                  child: CardErrorWidget(
                    error: "No tokens available",
                    maxWidth: AppConfig.toolbarMinWidth,
                  ),
                );
              } else {
                return MessageDisplayCard(
                  displayText: L10n.of(context)!.selectToDefine,
                );
              }
            },
          );
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
        // If not in the target language show specific messsage
        if (!messageInUserL2) {
          return MessageDisplayCard(
            displayText: L10n.of(context)!
                .messageNotInTargetLang, // Pass the display text,
          );
        }
        return PracticeActivityCard(
          pangeaMessageEvent: pangeaMessageEvent,
          overlayController: overLayController,
          ttsController: ttsController,
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
    return Container(
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
    );
  }
}
