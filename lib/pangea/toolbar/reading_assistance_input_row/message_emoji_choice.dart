import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_emojis.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/message_emoji_choice_item.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class MessageEmojiChoice extends StatelessWidget {
  final List<PangeaToken>? tokens;
  final ChatController controller;
  final MessageOverlayController overlayController;

  const MessageEmojiChoice({
    super.key,
    required this.tokens,
    required this.controller,
    required this.overlayController,
  });

  Future<void> redactReaction(BuildContext context, String emoji) {
    if (!context.mounted) {
      return Future.value();
    }
    final evt = allReactionEvents.firstWhereOrNull(
      (e) =>
          e.senderId == e.room.client.userID &&
          e.content.tryGetMap('m.relates_to')?['key'] == emoji,
    );
    if (evt != null) {
      return showFutureLoadingDialog(
        context: context,
        future: () => evt.redactEvent(),
      );
    }
    return Future.value();
  }

  Iterable<Event> get allReactionEvents => controller.selectedEvents.first
      .aggregatedEvents(
        controller.timeline!,
        RelationshipTypes.reaction,
      )
      .where(
        (event) =>
            event.senderId == event.room.client.userID &&
            event.type == 'm.reaction',
      );

  bool alreadyInReactions(String emoji) {
    for (final event in allReactionEvents) {
      try {
        if (event.content.tryGetMap('m.relates_to')!['key'] == emoji) {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  void onDoubleTapOrLongPress(BuildContext context, String emoji) {
    if (alreadyInReactions(emoji)) {
      redactReaction(context, emoji);
    } else {
      controller.sendEmojiAction(emoji);
    }
  }

  List<Widget> standardEmojiChoices(BuildContext context) => AppEmojis.emojis
      .map(
        (emoji) => MessageEmojiChoiceItem(
          content: emoji,
          onTap: () => alreadyInReactions(emoji)
              ? redactReaction(context, emoji)
              : controller.sendEmojiAction(emoji),
          isSelected: false,
          onDoubleTap: () => onDoubleTapOrLongPress(context, emoji),
          onLongPress: () => onDoubleTapOrLongPress(context, emoji),
          greenHighlight: false,
        ),
      )
      .toList();

  List<Widget> perTokenEmoji(BuildContext context) =>
      tokens!.where((token) => token.lemma.saveVocab).map((token) {
        final bool greenHighlight = token.shouldDoActivity(
          a: ActivityTypeEnum.wordMeaning,
          feature: null,
          tag: null,
        );
        if (!token.lemma.saveVocab) {
          return MessageEmojiChoiceItem(
            content: token.text.content,
            onTap: () => {},
            isSelected: overlayController.isTokenSelected(token),
            onDoubleTap: null,
            onLongPress: null,
            greenHighlight: greenHighlight,
          );
        }

        final emoji = token.getEmoji();

        if (emoji == null) {
          return MessageEmojiChoiceItem(
            topContent: token.vocabConstruct.constructLevel.icon(),
            content: token.text.content,
            onTap: () => overlayController.onClickOverlayMessageToken(token),
            onDoubleTap: null,
            onLongPress: null,
            isSelected: overlayController.isTokenSelected(token),
            contentOpacity: 0.1,
            greenHighlight: greenHighlight,
          );
        }

        return MessageEmojiChoiceItem(
          topContent: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          content: token.text.content,
          onTap: () => overlayController.onClickOverlayMessageToken(token),
          onDoubleTap: () => onDoubleTapOrLongPress(context, emoji),
          onLongPress: () => onDoubleTapOrLongPress(context, emoji),
          isSelected: overlayController.isTokenSelected(token),
          greenHighlight: greenHighlight,
        );
      }).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Wrap(
        alignment: WrapAlignment.center,
        // spacing: 8.0, // Adjust spacing between items
        runSpacing: 0.0, // Adjust spacing between rows
        children: tokens == null ||
                tokens!.isEmpty ||
                !(overlayController
                        .pangeaMessageEvent?.messageDisplayLangIsL2 ??
                    false)
            ? standardEmojiChoices(context)
            : perTokenEmoji(context),
      ),
    );
  }
}
