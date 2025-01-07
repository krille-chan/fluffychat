import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import '../../../pages/chat_list/chat_list.dart';
import '../../../widgets/matrix.dart';
import '../../extensions/pangea_room_extension/pangea_room_extension.dart';

class ChatListBodyStartText extends StatelessWidget {
  const ChatListBodyStartText({
    super.key,
    required this.controller,
  });

  final ChatListController controller;

  chatListBodyStartText(BuildContext context) {
    // note: only shows if user is in no chats in that space

    final PangeaController pangeaController = MatrixState.pangeaController;

    if (controller.activeSpaceId != null) {
      if (Matrix.of(context)
              .client
              .getRoomById(controller.activeSpaceId!)
              ?.isSpaceAdmin ??
          false) {
        return L10n.of(context).welcomeToYourNewClass;
      }

      return L10n.of(context).welcomeToClass;
    }

    if (pangeaController.permissionsController.isUser18()) {
      return L10n.of(context).welcomeToPangea18Plus;
    }

    return L10n.of(context).welcomeToPangeaMinor;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      chatListBodyStartText(context),
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
    );
  }
}
