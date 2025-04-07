import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_mode_locked_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_speech_to_text_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_translation_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/morph_focus_widget.dart';

const double minContentHeight = 120;

class ReadingAssistanceInputBar extends StatelessWidget {
  final ChatController controller;
  final MessageOverlayController overlayController;

  const ReadingAssistanceInputBar(
    this.controller,
    this.overlayController, {
    super.key,
  });

  Widget barContent(BuildContext context) {
    Widget? content;
    final target =
        overlayController.toolbarMode.associatedActivityType != null &&
                overlayController.pangeaMessageEvent != null
            ? overlayController.practiceSelection?.getSelection(
                overlayController.toolbarMode.associatedActivityType!,
                overlayController.selectedMorph?.token,
                overlayController.selectedMorph?.morph,
              )
            : null;

    if (overlayController.pangeaMessageEvent?.isAudioMessage == true) {
      return MessageSpeechToTextCard(
        messageEvent: overlayController.pangeaMessageEvent!,
      );
    } else {
      switch (overlayController.toolbarMode) {
        case MessageMode.messageSpeechToText:
        case MessageMode.practiceActivity:
        case MessageMode.wordZoom:
        case MessageMode.noneSelected:
        case MessageMode.messageMeaning:
          //TODO: show all emojis for the lemmas and allow sending normal reactions
          break;

        case MessageMode.messageTranslation:
          if (overlayController.isTranslationUnlocked) {
            content = MessageTranslationCard(
              messageEvent: overlayController.pangeaMessageEvent!,
            );
          } else {
            content = MessageModeLockedCard(controller: overlayController);
          }

        case MessageMode.wordEmoji:
        case MessageMode.wordMeaning:
        case MessageMode.listening:
          if (target != null) {
            content = PracticeActivityCard(
              pangeaMessageEvent: overlayController.pangeaMessageEvent!,
              targetTokensAndActivityType: target,
              overlayController: overlayController,
            );
          } else {
            content = const Text("All done!");
          }
        case MessageMode.wordMorph:
          if (target != null) {
            content = PracticeActivityCard(
              pangeaMessageEvent: overlayController.pangeaMessageEvent!,
              targetTokensAndActivityType: target,
              overlayController: overlayController,
            );
          } else if (overlayController.selectedMorph != null) {
            content = MorphFocusWidget(
              token: overlayController.selectedMorph!.token,
              morphFeature: overlayController.selectedMorph!.morph,
              pangeaMessageEvent: overlayController.pangeaMessageEvent!,
              overlayController: overlayController,
              onEditDone: () => overlayController.setState(() {}),
            );
          } else {
            content = Center(
              child: Text(
                L10n.of(context).selectForGrammar,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
      }
    }

    if (content == null) {
      return const SizedBox();
    }

    return Container(
      constraints: const BoxConstraints(
        minHeight: minContentHeight,
      ),
      child: Center(child: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: (MediaQuery.of(context).size.height / 2) -
              AppConfig.toolbarButtonsHeight,
          maxWidth: overlayController.maxWidth,
        ),
        child: AnimatedSize(
          duration: const Duration(
            milliseconds: AppConfig.overlayAnimationDuration,
          ),
          child: SingleChildScrollView(
            child: barContent(context),
          ),
        ),
      ),
    );
  }
}
