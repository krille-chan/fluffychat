import 'package:flutter/material.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/choreographer/choreographer_has_error_button.dart';

class ChatFloatingActionButton extends StatelessWidget {
  final ChatController controller;
  const ChatFloatingActionButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.selectedEvents.isNotEmpty) {
      return const SizedBox.shrink();
    }

    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.choreographer.errorService,
        controller.scrollController,
        controller.scrollableNotifier,
      ]),
      builder: (context, _) {
        if (controller.scrollController.hasClients &&
            controller.scrollController.position.pixels > 0) {
          return FloatingActionButton(
            onPressed: controller.scrollDown,
            heroTag: null,
            mini: true,
            child: const Icon(Icons.arrow_downward_outlined),
          );
        }

        if (controller.choreographer.errorService.error != null) {
          return ChoreographerHasErrorButton(
            controller.choreographer.errorService.error!,
            controller.choreographer,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
