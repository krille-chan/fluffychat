// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pages/chat_details/chat_details.dart';

class ClassDescriptionButton extends StatelessWidget {
  final Room room;
  final ChatDetailsController controller;
  const ClassDescriptionButton({
    Key? key,
    required this.room,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).textTheme.bodyLarge!.color;
    return Column(
      children: [
        ListTile(
          onTap: room.canSendEvent(EventTypes.RoomTopic)
              ? controller.setTopicAction
              : null,
          leading: room.canSendEvent(EventTypes.RoomTopic)
              ? CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: iconColor,
                  child: const Icon(Icons.topic_outlined),
                )
              : null,
          subtitle: Text(
            room.topic.isEmpty
                ? (room.isSpace
                    ? L10n.of(context)!.classDescriptionDesc
                    : L10n.of(context)!.chatTopicDesc)
                : room.topic,
          ),
          title: Text(
            room.isSpace
                ? L10n.of(context)!.classDescription
                : L10n.of(context)!.chatTopic,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
