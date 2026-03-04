import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/join_codes/knock_room_extension.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

enum CourseInviteAction { accept, decline }

class RoomInviteDialog extends StatelessWidget {
  final Room room;
  const RoomInviteDialog({super.key, required this.room});

  static Future<void> show(BuildContext context, Room room) async {
    final resp = await showDialog<CourseInviteAction>(
      context: context,
      builder: (context) => RoomInviteDialog(room: room),
    );

    switch (resp) {
      case CourseInviteAction.accept:
        final joinResult = await showFutureLoadingDialog(
          context: context,
          future: room.joinKnockedRoom,
          exceptionContext: ExceptionContext.joinRoom,
        );

        if (joinResult.isError) return;
        if (room.membership != Membership.join) {
          await room.client.waitForRoomInSync(room.id, join: true);
        }

        context.go(
          room.isSpace
              ? "/rooms/spaces/${room.id}/details"
              : "/rooms/${room.id}",
        );
        return;
      case CourseInviteAction.decline:
        await room.leave();
        return;
      case null:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
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
              ? L10n.of(
                  context,
                ).invitedToSpace(room.name, room.creatorId ?? "???")
              : L10n.of(
                  context,
                ).invitedToChat(room.name, room.creatorId ?? "???"),
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
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        AdaptiveDialogAction(
          onPressed: () => Navigator.of(context).pop(CourseInviteAction.accept),
          bigButtons: true,
          child: Text(L10n.of(context).accept),
        ),
      ],
    );
  }
}
