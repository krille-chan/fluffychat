import 'dart:async';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/overlay.dart';
import 'package:fluffychat/pangea/widgets/chat/message_audio_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_text_selection.dart';
import 'package:fluffychat/pangea/widgets/chat/message_translation_card.dart';
import 'package:fluffychat/pangea/widgets/chat/message_unsubscribed_card.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_message.dart';
import 'package:fluffychat/pangea/widgets/igc/word_data_card.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

enum MessageMode { translation, play, definition }

class ToolbarDisplayController {
  final PangeaMessageEvent pangeaMessageEvent;
  final String targetId;
  final bool immersionMode;
  final ChatController controller;

  MessageToolbar? toolbar;
  String? overlayId;
  double? messageWidth;

  final toolbarModeStream = StreamController<MessageMode>.broadcast();

  ToolbarDisplayController({
    required this.pangeaMessageEvent,
    required this.targetId,
    required this.immersionMode,
    required this.controller,
  });

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
    if (highlighted) return;
    if (controller.selectMode) {
      controller.clearSelectedEvents();
    }
    // focusNode.unfocus();
    FocusScope.of(context).unfocus();

    final LayerLinkAndKey layerLinkAndKey =
        MatrixState.pAnyState.layerLinkAndKey(targetId);
    final targetRenderBox =
        layerLinkAndKey.key.currentContext?.findRenderObject();
    if (targetRenderBox != null) {
      final Size transformTargetSize = (targetRenderBox as RenderBox).size;
      messageWidth = transformTargetSize.width;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Widget overlayEntry;
      try {
        overlayEntry = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: pangeaMessageEvent.ownMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            toolbar!,
            const SizedBox(height: 6),
            OverlayMessage(
              pangeaMessageEvent.event,
              timeline: pangeaMessageEvent.timeline,
              immersionMode: immersionMode,
              ownMessage: pangeaMessageEvent.ownMessage,
              toolbarController: this,
              width: messageWidth,
            ),
          ],
        );
      } catch (err) {
        ErrorHandler.logError(e: err, s: StackTrace.current);
        return;
      }

      OverlayUtil.showOverlay(
        context: context,
        child: overlayEntry,
        transformTargetId: targetId,
        targetAnchor: pangeaMessageEvent.ownMessage
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        followerAnchor: pangeaMessageEvent.ownMessage
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1).withAlpha(164),
      );

      if (MatrixState.pAnyState.overlay != null) {
        overlayId = MatrixState.pAnyState.overlay.hashCode.toString();
      }

      if (mode != null) {
        Future.delayed(
          const Duration(milliseconds: 100),
          () => toolbarModeStream.add(mode),
        );
      }
    });
  }

  bool get highlighted =>
      MatrixState.pAnyState.overlay.hashCode.toString() == overlayId;
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
  Widget? child;
  MessageMode? currentMode;
  bool updatingMode = false;
  late StreamSubscription<String?> selectionStream;
  late StreamSubscription<MessageMode> toolbarModeStream;

  IconData getIconData(MessageMode mode) {
    switch (mode) {
      case MessageMode.translation:
        return Icons.g_translate;
      case MessageMode.play:
        return Icons.play_arrow;
      case MessageMode.definition:
        return Icons.book;
      default:
        return Icons.error; // Icon to indicate an error or unsupported mode
    }
  }

  String getModeTitle(MessageMode mode) {
    switch (mode) {
      case MessageMode.translation:
        return L10n.of(context)!.translation;
      case MessageMode.play:
        return L10n.of(context)!.audio;
      case MessageMode.definition:
        return L10n.of(context)!.definitions;
      default:
        return L10n.of(context)!
            .oopsSomethingWentWrong; // Title to indicate an error or unsupported mode
    }
  }

  void updateMode(MessageMode newMode) {
    if (updatingMode) return;
    debugPrint("updating toolbar mode");
    final bool subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;
    setState(() {
      currentMode = newMode;
      updatingMode = true;
    });
    if (!subscribed) {
      child = MessageUnsubscribedCard(
        languageTool: getModeTitle(newMode),
      );
    } else {
      switch (currentMode) {
        case MessageMode.translation:
          showTranslation();
          break;
        case MessageMode.play:
          playAudio();
          break;
        case MessageMode.definition:
          showDefinition();
          break;
        default:
          break;
      }
    }
    setState(() {
      updatingMode = false;
    });
  }

  void showTranslation() {
    debugPrint("show translation");
    child = MessageTranslationCard(
      messageEvent: widget.pangeaMessageEvent,
      immersionMode: widget.immersionMode,
      selection: widget.textSelection,
    );
  }

  void playAudio() {
    debugPrint("play audio");
    child = MessageAudioCard(
      messageEvent: widget.pangeaMessageEvent,
    );
  }

  void showDefinition() {
    if (widget.textSelection.selectedText == null ||
        widget.textSelection.selectedText!.isEmpty) {
      child = const SelectToDefine();
      return;
    }

    child = WordDataCard(
      word: widget.textSelection.selectedText!,
      wordLang: widget.pangeaMessageEvent.messageDisplayLangCode,
      fullText: widget.textSelection.messageText,
      fullTextLang: widget.pangeaMessageEvent.messageDisplayLangCode,
      hasInfo: true,
      room: widget.room,
    );
  }

  void showImage() {}

  void spellCheck() {}

  void showMore() {
    MatrixState.pAnyState.closeOverlay();
    widget.controller.onSelectMessage(widget.pangeaMessageEvent.event);
  }

  @override
  void initState() {
    super.initState();
    toolbarModeStream = widget.toolbarModeStream.stream.listen((mode) {
      updateMode(mode);
    });

    updateMode(MessageMode.play);

    Timer? timer;
    selectionStream =
        widget.textSelection.selectionStream.stream.listen((value) {
      timer?.cancel();
      timer = Timer(const Duration(milliseconds: 500), () {
        if (currentMode != null || value != null && value.isNotEmpty) {
          updateMode(currentMode ?? MessageMode.translation);
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
        constraints: const BoxConstraints(
          maxWidth: 300,
          minWidth: 300,
          maxHeight: 300,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: AnimatedSize(
                  duration: FluffyThemes.animationDuration,
                  child: Column(
                    children: [
                      child ?? const SizedBox(),
                      SizedBox(height: child == null ? 0 : 20),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: MessageMode.values.map((mode) {
                    return IconButton(
                      icon: Icon(getIconData(mode)),
                      color: currentMode == mode
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      onPressed: () => updateMode(mode),
                    );
                  }).toList() +
                  [
                    IconButton(
                      icon: Icon(Icons.adaptive.more_outlined),
                      onPressed: showMore,
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }
}
