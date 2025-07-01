import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../common/utils/error_handler.dart';

Future<void> showInviteDialog(Room room, BuildContext context) async {
  if (room.membership != Membership.invite) return;
  final acceptInvite = await showOkCancelAlertDialog(
    context: context,
    title: L10n.of(context).youreInvited,
    message: room.isSpace
        ? L10n.of(context).invitedToSpace(room.name, room.creatorId ?? "???")
        : L10n.of(context).invitedToChat(room.name, room.creatorId ?? "???"),
    okLabel: L10n.of(context).accept,
    cancelLabel: L10n.of(context).decline,
  );

  final resp = await showFutureLoadingDialog(
    context: context,
    future: () async {
      if (acceptInvite == OkCancelResult.ok) {
        await room.join();
        context.go(
          room.isSpace ? "/rooms?spaceId=${room.id}" : "/rooms/${room.id}",
        );
        return room.id;
      } else if (acceptInvite == OkCancelResult.cancel) {
        await room.leave();
      }
    },
  );

  if (!resp.isError && resp.result is String) {
    context.go("/rooms?spaceId=${resp.result}");
  }
}

// ignore: curly_braces_in_flow_control_structures
void chatListHandleSpaceTap(
  BuildContext context,
  Room space,
) {
  void setActiveSpaceAndCloseChat() {
    context.go("/rooms?spaceId=${space.id}");
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
          justInputtedCode == space.classCode) {
        // do nothing
      } else {
        showInviteDialog(space, context);
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
