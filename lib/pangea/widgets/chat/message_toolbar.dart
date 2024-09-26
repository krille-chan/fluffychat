import 'dart:developer';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
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
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

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
  bool updatingMode = false;

  @override
  void initState() {
    super.initState();

    // why can't this just be initstate or the build mode?
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   //determine the starting mode
    //   //   if (widget.pangeaMessageEvent.isAudioMessage) {
    //   //     updateMode(MessageMode.speechToText);
    //   //     return;
    //   //   }

    //   //   if (widget.initialMode != null) {
    //   //     updateMode(widget.initialMode!);
    //   //   } else {
    //   //     MatrixState.pangeaController.userController.profile.userSettings
    //   //             .autoPlayMessages
    //   //         ? updateMode(MessageMode.textToSpeech)
    //   //         : updateMode(MessageMode.translation);
    //   //   }
    //   // });

    //   // just set mode based on messageSelectionOverlay mode which is now handling the state
    //   updateMode(widget.overLayController.toolbarMode);
    // });
  }

  Widget get toolbarContent {
    final bool subscribed =
        MatrixState.pangeaController.subscriptionController.isSubscribed;

    if (!subscribed) {
      return MessageUnsubscribedCard(
        languageTool: widget.overLayController.toolbarMode.title(context),
        mode: widget.overLayController.toolbarMode,
        controller: this,
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
    debugPrint("building toolbar");
    return Material(
      key: MatrixState.pAnyState
          .layerLinkAndKey('${widget.pangeaMessageEvent.eventId}-toolbar')
          .key,
      type: MaterialType.transparency,
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: AppConfig.toolbarMaxHeight,
          maxWidth: 275,
          minWidth: 275,
        ),
        padding: const EdgeInsets.all(20),
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
            Flexible(
              child: SingleChildScrollView(
                child: AnimatedSize(
                  duration: FluffyThemes.animationDuration,
                  child: toolbarContent,
                ),
              ),
            ),
            ToolbarButtons(messageToolbarController: this, width: 250),
          ],
        ),
      ),
    );
  }
}

class ToolbarSelectionArea extends StatelessWidget {
  final ChatController controller;
  final PangeaMessageEvent? pangeaMessageEvent;
  final bool isOverlay;
  final Widget child;
  final Event? nextEvent;
  final Event? prevEvent;

  const ToolbarSelectionArea({
    required this.controller,
    this.pangeaMessageEvent,
    this.isOverlay = false,
    required this.child,
    this.nextEvent,
    this.prevEvent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (pangeaMessageEvent != null && !isOverlay) {
          controller.showToolbar(
            pangeaMessageEvent!,
            nextEvent: nextEvent,
            prevEvent: prevEvent,
          );
        }
      },
      onLongPress: () {
        if (pangeaMessageEvent != null && !isOverlay) {
          controller.showToolbar(
            pangeaMessageEvent!,
            nextEvent: nextEvent,
            prevEvent: prevEvent,
          );
        }
      },
      child: child,
    );
  }
}

class ToolbarButtons extends StatefulWidget {
  final MessageToolbarState messageToolbarController;
  final double width;

  const ToolbarButtons({
    required this.messageToolbarController,
    required this.width,
    super.key,
  });

  @override
  ToolbarButtonsState createState() => ToolbarButtonsState();
}

class ToolbarButtonsState extends State<ToolbarButtons> {
  PangeaMessageEvent get pangeaMessageEvent =>
      widget.messageToolbarController.widget.pangeaMessageEvent;

  List<MessageMode> get modes => MessageMode.values
      .where((mode) => mode.isValidMode(pangeaMessageEvent.event))
      .toList();

  static const double iconWidth = 36.0;
  double get progressWidth => widget.width / overlayController.needed;

  MessageOverlayController get overlayController =>
      widget.messageToolbarController.widget.overLayController;

  // @ggurdin - maybe this can be stateless now?
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget
        .messageToolbarController.widget.pangeaMessageEvent.isAudioMessage) {
      return const SizedBox();
    }

    return SizedBox(
      width: widget.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: widget.width,
                height: 12,
                decoration: BoxDecoration(
                  color: MessageModeExtension.barAndLockedButtonColor(context),
                ),
                margin: const EdgeInsets.symmetric(horizontal: iconWidth / 2),
              ),
              AnimatedContainer(
                duration: FluffyThemes.animationDuration,
                height: 12,
                width: min(
                  widget.width,
                  progressWidth *
                      pangeaMessageEvent.numberOfActivitiesCompleted,
                ),
                color: AppConfig.success,
                margin: const EdgeInsets.symmetric(horizontal: iconWidth / 2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: modes
                .mapIndexed(
                  (index, mode) => Tooltip(
                    message: mode.tooltip(context),
                    child: IconButton(
                      iconSize: 20,
                      icon: Icon(mode.icon),
                      color: mode ==
                              widget.messageToolbarController.widget
                                  .overLayController.toolbarMode
                          ? Colors.white
                          : null,
                      isSelected: mode ==
                          widget.messageToolbarController.widget
                              .overLayController.toolbarMode,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          mode.iconButtonColor(
                            context,
                            index,
                            widget.messageToolbarController.widget
                                .overLayController.toolbarMode,
                            pangeaMessageEvent.numberOfActivitiesCompleted,
                            widget.messageToolbarController.widget
                                .overLayController.isPracticeComplete,
                          ),
                        ),
                      ),
                      onPressed: mode.isUnlocked(
                        index,
                        pangeaMessageEvent.numberOfActivitiesCompleted,
                        overlayController.isPracticeComplete,
                      )
                          ? () => widget
                              .messageToolbarController.widget.overLayController
                              .updateToolbarMode(mode)
                          : null,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
