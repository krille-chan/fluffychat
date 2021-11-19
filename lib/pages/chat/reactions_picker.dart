import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_emojis.dart';
import 'package:fluffychat/pages/chat/chat.dart';

class ReactionsPicker extends StatelessWidget {
  final ChatController controller;
  const ReactionsPicker(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.showEmojiPicker) return Container();
    final display = controller.editEvent == null &&
        controller.replyEvent == null &&
        controller.room.canSendDefaultMessages &&
        controller.selectedEvents.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: (display) ? 56 : 0,
      child: Material(
        color: Theme.of(context).secondaryHeaderColor,
        child: Builder(builder: (context) {
          if (!display) {
            return Container();
          }
          final emojis = List<String>.from(AppEmojis.emojis);
          final allReactionEvents = controller.selectedEvents.first
              .aggregatedEvents(controller.timeline, RelationshipTypes.reaction)
              ?.where((event) =>
                  event.senderId == event.room.client.userID &&
                  event.type == 'm.reaction');

          for (final event in allReactionEvents) {
            try {
              emojis.remove(event.content['m.relates_to']['key']);
            } catch (_) {}
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: emojis.length + 1,
            itemBuilder: (c, i) => i == emojis.length
                ? InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => controller.pickEmojiAction(allReactionEvents),
                    child: Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      child: const Icon(Icons.add_outlined),
                    ),
                  )
                : InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => controller.sendEmojiAction(emojis[i]),
                    child: Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      child: Text(
                        emojis[i],
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
          );
        }),
      ),
    );
  }
}
