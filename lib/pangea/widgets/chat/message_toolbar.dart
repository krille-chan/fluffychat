import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/overlay.dart';
import 'package:fluffychat/pangea/widgets/chat/message_audio_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/chat/message_speech_to_text_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_text_selection.dart';
import 'package:fluffychat/pangea/widgets/chat/message_translation_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_unsubscribed_card.dart';
import 'package:fluffychat/pangea/widgets/igc/word_data_card.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/widgets/user_settings/p_language_dialog.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class ToolbarDisplayController {
  final PangeaMessageEvent pangeaMessageEvent;
  final String targetId;
  final bool immersionMode;
  final ChatController controller;
  final FocusNode focusNode = FocusNode();
  Event? nextEvent;
  Event? previousEvent;

  MessageToolbar? toolbar;
  String? overlayId;
  double? messageWidth;

  final toolbarModeStream = StreamController<MessageMode>.broadcast();

  ToolbarDisplayController({
    required this.pangeaMessageEvent,
    required this.targetId,
    required this.immersionMode,
    required this.controller,
    this.nextEvent,
    this.previousEvent,
  });

  void closeToolbar() {
    controller.clearSelectedEvents();
    MatrixState.pAnyState.closeAllOverlays();
  }

  void setToolbar() {
    toolbar ??= MessageToolbar(
      textSelection: MessageTextSelection(),
      room: pangeaMessageEvent.room,
      toolbarModeStream: toolbarModeStream,
      pangeaMessageEvent: pangeaMessageEvent,
      immersionMode: immersionMode,
      controller: controller,
    );
  }

  void showToolbar(BuildContext context, {MessageMode? mode}) {
    // Close keyboard, if open
    FocusManager.instance.primaryFocus?.unfocus();
    // Close emoji picker, if open
    controller.showEmojiPicker = false;
    if (highlighted) return;
    if (!MatrixState.pangeaController.languageController.languagesSet) {
      pLanguageDialog(context, () {});
      return;
    }
    focusNode.requestFocus();

    // I'm not sure why I put this here, but it causes the toolbar
    // not to open immediately after clicking (user has to scroll or move their cursor)
    // so I'm commenting it out for now
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    Widget overlayEntry;
    if (toolbar == null) return;
    try {
      overlayEntry = MessageSelectionOverlay(
        controller: controller,
        closeToolbar: closeToolbar,
        toolbar: toolbar!,
        pangeaMessageEvent: pangeaMessageEvent,
        immersionMode: immersionMode,
        ownMessage: pangeaMessageEvent.ownMessage,
        targetId: targetId,
        toolbarController: this,
      );
    } catch (err) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: StackTrace.current);
      return;
    }

    OverlayUtil.showOverlay(
      context: context,
      child: overlayEntry,
      transformTargetId: targetId,
      targetAnchor: Alignment.center,
      followerAnchor: Alignment.center,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1).withAlpha(200),
      closePrevOverlay:
          MatrixState.pangeaController.subscriptionController.isSubscribed,
      position: OverlayEnum.centered,
      onDismiss: controller.clearSelectedEvents,
    );

    controller.onSelectMessage(pangeaMessageEvent.event);

    if (MatrixState.pAnyState.entries.isNotEmpty) {
      overlayId = MatrixState.pAnyState.entries.last.hashCode.toString();
    }

    if (mode != null) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => toolbarModeStream.add(mode),
      );
    }
  }

  bool get highlighted {
    if (overlayId == null) return false;
    if (MatrixState.pAnyState.entries.isEmpty) {
      overlayId = null;
      return false;
    }
    return MatrixState.pAnyState.entries.last.hashCode.toString() == overlayId;
  }
}

class MessageToolbar extends StatefulWidget {
  final MessageTextSelection textSelection;
  final Room room;
  final PangeaMessageEvent pangeaMessageEvent;
  final StreamController<MessageMode> toolbarModeStream;
  final bool immersionMode;
  final ChatController controller;

  const MessageToolbar({
    super.key,
    required this.textSelection,
    required this.room,
    required this.pangeaMessageEvent,
    required this.toolbarModeStream,
    required this.immersionMode,
    required this.controller,
  });

  @override
  MessageToolbarState createState() => MessageToolbarState();
}

class MessageToolbarState extends State<MessageToolbar> {
  Widget? toolbarContent;
  MessageMode? currentMode;
  bool updatingMode = false;
  late StreamSubscription<String?> selectionStream;
  late StreamSubscription<MessageMode> toolbarModeStream;

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
        toolbarModeStream: widget.toolbarModeStream,
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
      immersionMode: widget.immersionMode,
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
      room: widget.room,
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

    toolbarModeStream = widget.toolbarModeStream.stream.listen((mode) {
      updateMode(mode);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.pangeaMessageEvent.isAudioMessage) {
        updateMode(MessageMode.speechToText);
        return;
      }

      MatrixState.pangeaController.userController.profile.userSettings
              .autoPlayMessages
          ? updateMode(MessageMode.textToSpeech)
          : updateMode(MessageMode.translation);
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
    toolbarModeStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = (MediaQuery.of(context).size.height -
            (PlatformInfos.isIOS ? 254 : 222)) /
        2;

    return Material(
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
        constraints: BoxConstraints(
          maxWidth: 290,
          minWidth: 290,
          maxHeight: maxHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: 290,
                maxHeight: maxHeight - 72,
              ),
              child: SingleChildScrollView(
                child: AnimatedSize(
                  duration: FluffyThemes.animationDuration,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: toolbarContent ?? const SizedBox(),
                      ),
                      SizedBox(height: toolbarContent == null ? 0 : 20),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: MessageMode.values.map((mode) {
                if ([
                      MessageMode.definition,
                      MessageMode.textToSpeech,
                      MessageMode.translation,
                    ].contains(mode) &&
                    widget.pangeaMessageEvent.isAudioMessage) {
                  return const SizedBox.shrink();
                }
                if (mode == MessageMode.speechToText &&
                    !widget.pangeaMessageEvent.isAudioMessage) {
                  return const SizedBox.shrink();
                }
                return Tooltip(
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
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
