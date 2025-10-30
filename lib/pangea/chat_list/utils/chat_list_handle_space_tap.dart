import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../common/utils/error_handler.dart';

Future<void> showInviteDialog(Room room, BuildContext context) async {
  if (room.membership != Membership.invite) return;

  final theme = Theme.of(context);
  final action = await showAdaptiveDialog<CourseInviteAction>(
    barrierDismissible: true,
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256),
        child: Center(
          child: Text(
            L10n.of(context).youreInvited,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
        child: Text(
          room.isSpace
              ? L10n.of(context)
                  .invitedToSpace(room.name, room.creatorId ?? "???")
              : L10n.of(context)
                  .invitedToChat(room.name, room.creatorId ?? "???"),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        AdaptiveDialogAction(
          onPressed: () =>
              Navigator.of(context).pop(CourseInviteAction.decline),
          bigButtons: true,
          child: Text(
            L10n.of(context).decline,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
        AdaptiveDialogAction(
          onPressed: () => Navigator.of(context).pop(CourseInviteAction.accept),
          bigButtons: true,
          child: Text(L10n.of(context).accept),
        ),
      ],
    ),
  );
  switch (action) {
    case null:
      return;
    case CourseInviteAction.accept:
      break;
    case CourseInviteAction.decline:
      await room.leave();
      return;
  }

  final joinResult = await showFutureLoadingDialog(
    context: context,
    future: () async {
      await room.join();
    },
    exceptionContext: ExceptionContext.joinRoom,
  );
  if (joinResult.error != null) return;

  if (room.membership != Membership.join) {
    await room.client.waitForRoomInSync(room.id, join: true);
  }

  context.go(
    room.isSpace ? "/rooms/spaces/${room.id}/details" : "/rooms/${room.id}",
  );
}

// ignore: curly_braces_in_flow_control_structures
void chatListHandleSpaceTap(
  BuildContext context,
  Room space,
) {
  void setActiveSpaceAndCloseChat() {
    // push to refresh space details
    // https://github.com/pangeachat/client/issues/4292#issuecomment-3426794043
    context.push("/rooms/spaces/${space.id}/details");
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
          MatrixState.pangeaController.spaceCodeController.justInputtedCode;
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

enum CourseInviteAction { accept, decline }
