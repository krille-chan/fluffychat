import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../common/utils/error_handler.dart';

// ignore: curly_braces_in_flow_control_structures
void chatListHandleSpaceTap(
  BuildContext context,
  ChatListController controller,
  Room space,
) {
  void setActiveSpaceAndCloseChat() {
    controller.setActiveSpace(space.id);

    if (FluffyThemes.isColumnMode(context)) {
      context.go('/rooms/${space.id}');
    } else if (controller.activeChat != null &&
        !space.isFirstOrSecondChild(controller.activeChat!)) {
      context.go("/rooms");
    }
  }

  void autoJoin(Room space) {
    showFutureLoadingDialog(
      context: context,
      future: () async {
        await space.join();
        setActiveSpaceAndCloseChat();
      },
    );
  }

  switch (space.membership) {
    case Membership.join:
      setActiveSpaceAndCloseChat();
      break;
    case Membership.invite:
      //if space is a child of a space you're in, automatically join
      //else confirm you want to join
      //can we tell whether space or chat?
      final rooms = Matrix.of(context).client.rooms.where(
            (element) =>
                element.isSpace && element.membership == Membership.join,
          );
      final justInputtedCode =
          MatrixState.pangeaController.classController.justInputtedCode();
      if (rooms.any((s) => s.spaceChildren.any((c) => c.roomId == space.id))) {
        autoJoin(space);
      } else if (justInputtedCode != null &&
          justInputtedCode == space.classCode(context)) {
        // do nothing
      } else {
        controller.showInviteDialog(space);
      }
      break;
    case Membership.leave:
      autoJoin(space);
      break;
    default:
      setActiveSpaceAndCloseChat();
      ErrorHandler.logError(
        m: 'should not show space with membership ${space.membership}',
        data: space.toJson(),
      );
      break;
  }
}
