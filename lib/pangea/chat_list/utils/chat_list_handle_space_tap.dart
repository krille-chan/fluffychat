import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
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
      context.go('/rooms/${space.id}/details');
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
        if (await space.leaveIfFull()) {
          throw L10n.of(context).roomFull;
        }
        setActiveSpaceAndCloseChat();
      },
    );
  }

  //show alert dialog prompting user to accept invite or reject
  //if accepted, setActiveSpaceAndCloseChat()
  //if rejected, leave space
  // use standard alert diolog, not cupertino
  Future<void> showAlertDialog(BuildContext context) async {
    final acceptInvite = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context).youreInvited,
      message: space.isSpace
          ? L10n.of(context)
              .invitedToSpace(space.name, space.creatorId ?? "???")
          : L10n.of(context)
              .invitedToChat(space.name, space.creatorId ?? "???"),
      okLabel: L10n.of(context).accept,
      cancelLabel: L10n.of(context).decline,
    );

    if (acceptInvite == OkCancelResult.ok) {
      await showFutureLoadingDialog(
        context: context,
        future: () async {
          await space.join();
          if (await space.leaveIfFull()) {
            throw L10n.of(context).roomFull;
          }
          setActiveSpaceAndCloseChat();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(L10n.of(context).acceptedInvitation),
              duration: const Duration(seconds: 3),
            ),
          );
        },
      );
    } else {
      await space.leave();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).declinedInvitation),
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
      final justInputtedCode = MatrixState
          .pangeaController.classController.chatBox
          .read(PLocalKey.justInputtedCode);
      if (rooms.any((s) => s.spaceChildren.any((c) => c.roomId == space.id))) {
        autoJoin(space);
      } else if (justInputtedCode != null &&
          justInputtedCode == space.classCode) {
        // do nothing
      } else {
        showAlertDialog(context);
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
