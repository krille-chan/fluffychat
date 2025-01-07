import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class ClassDescriptionButton extends StatelessWidget {
  final Room room;
  final ChatDetailsController controller;
  const ClassDescriptionButton({
    super.key,
    required this.room,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).textTheme.bodyLarge!.color;
    final ScrollController scrollController = ScrollController();
    return Column(
      children: [
        ListTile(
          onTap: room.isRoomAdmin ? controller.setTopicAction : null,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: iconColor,
            child: const Icon(Icons.topic_outlined),
          ),
          subtitle: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 190,
            ),
            child: Scrollbar(
              controller: scrollController,
              interactive: true,
              child: SingleChildScrollView(
                controller: scrollController,
                primary: false,
                child: Text(
                  room.topic.isEmpty
                      ? (room.isRoomAdmin
                          ? (room.isSpace
                              ? L10n.of(context).classDescriptionDesc
                              : L10n.of(context).setChatDescription)
                          : L10n.of(context).topicNotSet)
                      : room.topic,
                ),
              ),
            ),
          ),
          title: Text(
            room.isSpace
                ? L10n.of(context).classDescription
                : L10n.of(context).chatDescription,
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

void setClassTopic(Room room, BuildContext context) {
  final TextEditingController textFieldController =
      TextEditingController(text: room.topic);
  showDialog(
    context: context,
    useRootNavigator: false,
    builder: (BuildContext context) => AlertDialog(
      title: Text(
        room.isSpace
            ? L10n.of(context).classDescription
            : L10n.of(context).chatDescription,
      ),
      content: TextField(
        controller: textFieldController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 10,
        maxLength: 2000,
      ),
      actions: [
        TextButton(
          child: Text(L10n.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(L10n.of(context).ok),
          onPressed: () async {
            if (textFieldController.text == "") return;
            final success = await showFutureLoadingDialog(
              context: context,
              future: () => room.setDescription(textFieldController.text),
            );
            if (success.error == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(L10n.of(context).groupDescriptionHasBeenChanged),
                ),
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}
