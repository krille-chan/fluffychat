import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/send_file_dialog.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/matrix.dart';

void onChatTap(Room room, BuildContext context) async {
  if (room.membership == Membership.invite) {
    final inviterId =
        room.getState(EventTypes.RoomMember, room.client.userID!)?.senderId;
    final inviteAction = await showModalActionSheet<InviteActions>(
      context: context,
      message: room.isDirectChat
          ? L10n.of(context)!.invitePrivateChat
          : L10n.of(context)!.inviteGroupChat,
      title: room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
      actions: [
        SheetAction(
          key: InviteActions.accept,
          label: L10n.of(context)!.accept,
          icon: Icons.check_outlined,
          isDefaultAction: true,
        ),
        SheetAction(
          key: InviteActions.decline,
          label: L10n.of(context)!.decline,
          icon: Icons.close_outlined,
          isDestructiveAction: true,
        ),
        SheetAction(
          key: InviteActions.block,
          label: L10n.of(context)!.block,
          icon: Icons.block_outlined,
          isDestructiveAction: true,
        ),
      ],
    );
    if (inviteAction == null) return;
    if (inviteAction == InviteActions.block) {
      context.go('/rooms/settings/security/ignorelist', extra: inviterId);
      return;
    }
    if (inviteAction == InviteActions.decline) {
      await showFutureLoadingDialog(
        context: context,
        future: room.leave,
      );
      return;
    }
    final joinResult = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final waitForRoom = room.client.waitForRoomInSync(
          room.id,
          join: true,
        );
        await room.join();
        await waitForRoom;
      },
    );
    if (joinResult.error != null) return;
  }

  if (room.membership == Membership.ban) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L10n.of(context)!.youHaveBeenBannedFromThisChat),
      ),
    );
    return;
  }

  if (room.membership == Membership.leave) {
    context.go('/rooms/archive/${room.id}');
    return;
  }

  // Share content into this room
  final shareContent = Matrix.of(context).shareContent;
  if (shareContent != null) {
    final shareFile = shareContent.tryGet<MatrixFile>('file');
    if (shareContent.tryGet<String>('msgtype') == 'chat.fluffy.shared_file' &&
        shareFile != null) {
      await showDialog(
        context: context,
        useRootNavigator: false,
        builder: (c) => SendFileDialog(
          files: [shareFile],
          room: room,
        ),
      );
      Matrix.of(context).shareContent = null;
    } else {
      final consent = await showOkCancelAlertDialog(
        context: context,
        title: L10n.of(context)!.forward,
        message: L10n.of(context)!.forwardMessageTo(
          room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
        ),
        okLabel: L10n.of(context)!.forward,
        cancelLabel: L10n.of(context)!.cancel,
      );
      if (consent == OkCancelResult.cancel) {
        Matrix.of(context).shareContent = null;
        return;
      }
      if (consent == OkCancelResult.ok) {
        room.sendEvent(shareContent);
        Matrix.of(context).shareContent = null;
      }
    }
  }

  context.go('/rooms/${room.id}');
}

enum InviteActions {
  accept,
  decline,
  block,
}
