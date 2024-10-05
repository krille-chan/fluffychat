import 'dart:developer';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/message_audio_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/chat/message_speech_to_text_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar_buttons.dart';
import 'package:fluffychat/pangea/widgets/chat/message_translation_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_unsubscribed_card.dart';
import 'package:fluffychat/pangea/widgets/igc/word_data_card.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/widgets/select_to_define.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double minCardHeight = 70;

class MessageToolbar extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overLayController;

  const MessageToolbar({
    super.key,
    required this.pangeaMessageEvent,
    required this.overLayController,
  });

  @override
  MessageToolbarState createState() => MessageToolbarState();
}

class MessageToolbarState extends State<MessageToolbar> {
  @override
  void initState() {
    super.initState();
  }

  Widget get toolbarContent {
    final bool subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;

    if (!subscribed) {
      return MessageUnsubscribedCard(
        controller: widget.overLayController,
      );
    }

    switch (widget.overLayController.toolbarMode) {
      case MessageMode.translation:
        return MessageTranslationCard(
          messageEvent: widget.pangeaMessageEvent,
          selection: widget.overLayController.selectedSpan,
        );
      case MessageMode.textToSpeech:
        return MessageAudioCard(
          messageEvent: widget.pangeaMessageEvent,
          overlayController: widget.overLayController,
        );
      case MessageMode.speechToText:
        return MessageSpeechToTextCard(
          messageEvent: widget.pangeaMessageEvent,
        );
      case MessageMode.definition:
        if (!widget.overLayController.isSelection) {
          return const SelectToDefine();
        } else {
          try {
            final selectedText = widget.overLayController.targetText;

            return WordDataCard(
              word: selectedText,
              wordLang: widget.pangeaMessageEvent.messageDisplayLangCode,
              fullText: widget.pangeaMessageEvent.messageDisplayText,
              fullTextLang: widget.pangeaMessageEvent.messageDisplayLangCode,
              hasInfo: true,
              room: widget.overLayController.widget.chatController.room,
            );
          } catch (e, s) {
            debugger(when: kDebugMode);
            ErrorHandler.logError(
              e: "Error in WordDataCard",
              s: s,
              data: {
                "word": widget.overLayController.targetText,
                "fullText": widget.pangeaMessageEvent.messageDisplayText,
              },
            );
            return const SizedBox();
          }
        }
      case MessageMode.practiceActivity:
        return PracticeActivityCard(
          pangeaMessageEvent: widget.pangeaMessageEvent,
          overlayController: widget.overLayController,
        );
      default:
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          e: "Invalid toolbar mode",
          s: StackTrace.current,
          data: {"newMode": widget.overLayController.toolbarMode},
        );
        return const SizedBox();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: MatrixState.pAnyState
          .layerLinkAndKey('${widget.pangeaMessageEvent.eventId}-toolbar')
          .key,
      type: MaterialType.transparency,
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(
              maxHeight: AppConfig.toolbarMaxHeight,
              maxWidth: 350,
              minWidth: 350,
            ),
            padding: const EdgeInsets.all(0),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
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
          const SizedBox(height: 6),
          ToolbarButtons(
            overlayController: widget.overLayController,
            width: 250,
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
