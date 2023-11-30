import 'package:flutter/material.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_event_list.dart';
import 'package:fluffychat/pages/chat/chat_view_frame.dart';
import 'package:fluffychat/pages/chat/chat_view_scaffold.dart';

class ChatView extends StatelessWidget {
  final ChatController controller;

  const ChatView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.room.membership == Membership.invite) {
      showFutureLoadingDialog(
        context: context,
        future: () => controller.room.join(),
      );
    }

    return ChatViewScaffold(
      controller,
      body: ChatViewFrame(
        controller,
        contentBuilder: (context) {
          if (controller.timeline == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
              ),
            );
          }

          return ChatEventList(
            controller: controller,
          );
        },
      ),
    );
  }
}
