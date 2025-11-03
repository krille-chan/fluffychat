import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/lemmas/lemma_emoji_picker.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaReactionPicker extends StatelessWidget {
  final List<String> emojis;
  final bool loading;
  final Event? event;

  const LemmaReactionPicker({
    super.key,
    required this.emojis,
    required this.loading,
    required this.event,
  });

  void setEmoji(String emoji, BuildContext context) {
    if (event?.room.timeline == null) {
      throw Exception("Timeline is null in reaction picker");
    }

    final allReactionEvents = event!.aggregatedEvents(
      event!.room.timeline!,
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
      event!.room.sendReaction(
        event!.eventId,
        emoji,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sentReactions = <String>{};
    if (event?.room.timeline != null) {
      sentReactions.addAll(
        event!
            .aggregatedEvents(
              event!.room.timeline!,
              RelationshipTypes.reaction,
            )
            .where(
              (event) =>
                  event.senderId == event.room.client.userID &&
                  event.type == 'm.reaction',
            )
            .map(
              (event) => event.content
                  .tryGetMap<String, Object?>('m.relates_to')
                  ?.tryGet<String>('key'),
            )
            .whereType<String>(),
      );
    }

    return LemmaEmojiPicker(
      emojis: emojis,
      onSelect: event?.room.timeline != null
          ? (emoji) => setEmoji(emoji, context)
          : null,
      disabled: (emoji) => sentReactions.contains(emoji),
      loading: loading,
    );
  }
}
