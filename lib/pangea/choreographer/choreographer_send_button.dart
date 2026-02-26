import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/choreographer/choreographer_state_extension.dart';

class ChoreographerSendButton extends StatelessWidget {
  final ChatController controller;
  const ChoreographerSendButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.choreographer.isFetching,
      builder: (context, fetching, _) {
        return Container(
          height: 56,
          alignment: Alignment.center,
          child: IconButton(
            icon: const Icon(Icons.send_outlined),
            color: controller.choreographer.assistanceState.sendButtonColor(
              context,
            ),
            onPressed: fetching ? null : controller.onInputBarSubmitted,
            tooltip: L10n.of(context).send,
          ),
        );
      },
    );
  }
}
