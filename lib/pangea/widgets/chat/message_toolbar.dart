import 'dart:async';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/message_audio_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_speech_to_text_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_text_selection.dart';
import 'package:fluffychat/pangea/widgets/chat/message_translation_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_unsubscribed_card.dart';
import 'package:fluffychat/pangea/widgets/igc/word_data_card.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class MessageToolbar extends StatefulWidget {
  final MessageTextSelection textSelection;
  final PangeaMessageEvent pangeaMessageEvent;
  final ChatController controller;
  final MessageMode? initialMode;

  final StreamController completeAnimationStream;

  const MessageToolbar({
    super.key,
    required this.textSelection,
    required this.pangeaMessageEvent,
    required this.controller,
    required this.completeAnimationStream,
    this.initialMode,
  });

  @override
  MessageToolbarState createState() => MessageToolbarState();
}

class MessageToolbarState extends State<MessageToolbar> {
  Widget? toolbarContent;
  MessageMode? currentMode;
  bool updatingMode = false;
  late StreamSubscription<String?> selectionStream;

  void updateMode(MessageMode newMode) {
    //Early exit from the function if the widget has been unmounted to prevent updates on an inactive widget.
    if (!mounted) return;
    if (updatingMode) return;
    debugPrint("updating toolbar mode");
    final bool subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;

    if (!newMode.isValidMode(widget.pangeaMessageEvent.event)) {
      ErrorHandler.logError(
        e: "Invalid mode for event",
        s: StackTrace.current,
        data: {
          "newMode": newMode,
          "event": widget.pangeaMessageEvent.event,
        },
      );
      return;
    }

    // if there is an uncompleted activity, then show that
    // we don't want the user to user the tools to get the answer :P
    if (widget.pangeaMessageEvent.hasUncompletedActivity) {
      newMode = MessageMode.practiceActivity;
    }

    if (mounted) {
      setState(() {
        currentMode = newMode;
        updatingMode = true;
      });
    }

    if (!subscribed) {
      toolbarContent = MessageUnsubscribedCard(
        languageTool: newMode.title(context),
        mode: newMode,
        controller: this,
      );
    } else {
      switch (currentMode) {
        case MessageMode.translation:
          showTranslation();
          break;
        case MessageMode.textToSpeech:
          showTextToSpeech();
          break;
        case MessageMode.speechToText:
          showSpeechToText();
          break;
        case MessageMode.definition:
          showDefinition();
          break;
        case MessageMode.practiceActivity:
          showPracticeActivity();
          break;
        default:
          ErrorHandler.logError(
            e: "Invalid toolbar mode",
            s: StackTrace.current,
            data: {"newMode": newMode},
          );
          break;
      }
    }
    if (mounted) {
      setState(() {
        updatingMode = false;
      });
    }
  }

  void showTranslation() {
    debugPrint("show translation");
    toolbarContent = MessageTranslationCard(
      messageEvent: widget.pangeaMessageEvent,
      immersionMode: widget.controller.choreographer.immersionMode,
      selection: widget.textSelection,
    );
  }

  void showTextToSpeech() {
    debugPrint("show text to speech");
    toolbarContent = MessageAudioCard(
      messageEvent: widget.pangeaMessageEvent,
    );
  }

  void showSpeechToText() {
    debugPrint("show speech to text");
    toolbarContent = MessageSpeechToTextCard(
      messageEvent: widget.pangeaMessageEvent,
    );
  }

  void showDefinition() {
    debugPrint("show definition");
    if (widget.textSelection.selectedText == null ||
        widget.textSelection.selectedText!.isEmpty) {
      toolbarContent = const SelectToDefine();
      return;
    }

    toolbarContent = WordDataCard(
      word: widget.textSelection.selectedText!,
      wordLang: widget.pangeaMessageEvent.messageDisplayLangCode,
      fullText: widget.textSelection.messageText,
      fullTextLang: widget.pangeaMessageEvent.messageDisplayLangCode,
      hasInfo: true,
      room: widget.controller.room,
    );
  }

  void showPracticeActivity() {
    toolbarContent = PracticeActivityCard(
      pangeaMessageEvent: widget.pangeaMessageEvent,
    );
  }

  void showImage() {}

  void spellCheck() {}

  @override
  void initState() {
    super.initState();
    widget.textSelection.selectedText = null;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.pangeaMessageEvent.isAudioMessage) {
        updateMode(MessageMode.speechToText);
        return;
      }

      if (widget.initialMode != null) {
        updateMode(widget.initialMode!);
      } else {
        MatrixState.pangeaController.userController.profile.userSettings
                .autoPlayMessages
            ? updateMode(MessageMode.textToSpeech)
            : updateMode(MessageMode.translation);
      }
    });

    Timer? timer;
    selectionStream =
        widget.textSelection.selectionStream.stream.listen((value) {
      timer?.cancel();
      timer = Timer(const Duration(milliseconds: 500), () {
        if (value != null && value.isNotEmpty) {
          final MessageMode newMode = currentMode == MessageMode.definition
              ? MessageMode.definition
              : MessageMode.translation;
          updateMode(newMode);
        } else if (currentMode != null) {
          updateMode(currentMode!);
        }
      });
    });
  }

  @override
  void dispose() {
    selectionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: MessageMode.values
          .map(
            (mode) => mode.isValidMode(widget.pangeaMessageEvent.event)
                ? Tooltip(
                    message: mode.tooltip(context),
                    child: IconButton(
                      icon: Icon(mode.icon),
                      color: mode.iconColor(
                        widget.pangeaMessageEvent,
                        currentMode,
                        context,
                      ),
                      onPressed: () => updateMode(mode),
                    ),
                  )
                : const SizedBox.shrink(),
          )
          .toList(),
    );

    return Material(
      key: MatrixState.pAnyState
          .layerLinkAndKey('${widget.pangeaMessageEvent.eventId}-toolbar')
          .key,
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (toolbarContent != null)
              Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                constraints: const BoxConstraints(
                  maxWidth: 275,
                  minWidth: 275,
                  maxHeight: 250,
                ),
                child: SingleChildScrollView(
                  child: AnimatedSize(
                    duration: FluffyThemes.animationDuration,
                    child: toolbarContent,
                    onEnd: () => widget.completeAnimationStream.add(null),
                  ),
                ),
              ),
            buttonRow,
          ],
        ),
      ),
    );
  }
}
