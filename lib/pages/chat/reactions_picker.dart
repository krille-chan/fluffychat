import 'package:flutter/material.dart';

import 'package:emoji_proposal/emoji_proposal.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/app_emojis.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import '../../config/themes.dart';

class ReactionsPicker extends StatelessWidget {
  final ChatController controller;

  const ReactionsPicker(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.showEmojiPicker) return const SizedBox.shrink();
    final display = controller.editEvent == null &&
        controller.replyEvent == null &&
        controller.room.canSendDefaultMessages &&
        controller.selectedEvents.isNotEmpty;
    return AnimatedContainer(
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
      height: (display) ? 56 : 0,
      child: Material(
        color: Colors.transparent,
        child: Builder(
          builder: (context) {
            if (!display) {
              return const SizedBox.shrink();
            }
            final proposals = proposeEmojis(
              controller.selectedEvents.first.plaintextBody,
              number: 25,
              languageCodes: EmojiProposalLanguageCodes.values.toSet(),
            );
            final emojis = proposals.isNotEmpty
                ? proposals.map((e) => e.char).toList()
                : List<String>.from(AppEmojis.emojis);
            final allReactionEvents = controller.selectedEvents.first
                .aggregatedEvents(
                  controller.timeline!,
                  RelationshipTypes.reaction,
                )
                .where(
                  (event) =>
                      event.senderId == event.room.client.userID &&
                      event.type == 'm.reaction',
                );

            for (final event in allReactionEvents) {
              try {
                emojis.remove(event.content['m.relates_to']['key']);
              } catch (_) {}
            }
            return Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(AppConfig.borderRadius),
                      ),
                    ),
                    padding: const EdgeInsets.only(right: 1),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: emojis.length,
                      itemBuilder: (c, i) => InkWell(
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
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 36,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_outlined),
                  ),
                  onTap: () =>
                      controller.pickEmojiReactionAction(allReactionEvents),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
