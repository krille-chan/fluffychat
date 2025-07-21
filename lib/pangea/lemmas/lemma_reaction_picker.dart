import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/lemma_emoji_choice_item.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaReactionPicker extends StatelessWidget {
  final List<String> emojis;
  final bool loading;

  final Event event;
  final ChatController controller;

  const LemmaReactionPicker({
    super.key,
    required this.emojis,
    required this.loading,
    required this.event,
    required this.controller,
  });

  void setEmoji(String emoji, BuildContext context) {
    final allReactionEvents = event.aggregatedEvents(
      controller.timeline!,
      RelationshipTypes.reaction,
    );

    final client = Matrix.of(context).client;
    final reactionEvent = allReactionEvents.firstWhereOrNull(
      (e) =>
          e.senderId == client.userID &&
          e.content.tryGetMap('m.relates_to')?['key'] == emoji,
    );

    if (reactionEvent != null) {
      showFutureLoadingDialog(
        context: context,
        future: () => reactionEvent.redactEvent(),
      );
    } else {
      controller.room.sendReaction(
        event.eventId,
        emoji,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4.0,
        children: loading
            ? [1, 2, 3, 4, 5]
                .map(
                  (e) => const LemmaEmojiChoicePlaceholder(),
                )
                .toList()
            : emojis
                .map(
                  (emoji) => LemmaEmojiChoiceItem(
                    content: emoji,
                    onTap: () => setEmoji(emoji, context),
                  ),
                )
                .toList(),
      ),
    );
  }
}
