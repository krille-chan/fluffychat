import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/constants/colors.dart';
import '../../../pages/chat/chat.dart';

class ChoreographerSendButton extends StatelessWidget {
  const ChoreographerSendButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    // commit for cicd
    return controller.choreographer.isFetching
        ? Container(
            height: 56,
            width: 56,
            padding: const EdgeInsets.all(13),
            child: const CircularProgressIndicator(),
          )
        : Container(
            height: 56,
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.send_outlined),
              color: controller.choreographer.igc.canSendMessage
                  ? null
                  : PangeaColors.igcError,
              onPressed: () {
                controller.choreographer.send(context);
              },
              tooltip: L10n.of(context)!.send,
            ),
          );
  }
}
