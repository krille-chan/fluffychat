import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/permission_slider_dialog.dart';
import 'adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'adaptive_dialogs/show_text_input_dialog.dart';
import 'adaptive_dialogs/user_dialog.dart';
import 'avatar.dart';
import 'future_loading_dialog.dart';

void showMemberActionsPopupMenu({
  required BuildContext context,
  required User user,
  void Function()? onMention,
}) async {
  final theme = Theme.of(context);
  final displayname = user.calcDisplayname();
  final isMe = user.room.client.userID == user.id;

  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

  final button = context.findRenderObject() as RenderBox;

  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(const Offset(0, -65), ancestor: overlay),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero) + const Offset(-50, 0),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );

  final action = await showMenu<_MemberActions>(
    context: context,
    position: position,
    items: <PopupMenuEntry<_MemberActions>>[
      PopupMenuItem(
        value: _MemberActions.info,
        child: Row(
          spacing: 12.0,
          children: [
            Avatar(
              name: displayname,
              mxContent: user.avatarUrl,
              presenceUserId: user.id,
              presenceBackgroundColor: theme.colorScheme.surfaceContainer,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 128),
                  child: Text(
                    displayname,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 128),
                  child: Text(
                    user.id,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const PopupMenuDivider(),
      if (onMention != null)
        PopupMenuItem(
          value: _MemberActions.mention,
          child: Row(
            children: [
              Icon(
                Icons.alternate_email_outlined,
                color: theme.colorScheme.onSecondary,
              ),
              const SizedBox(width: 18),
              Text(L10n.of(context).mention),
            ],
          ),
        ),
      if (user.membership == Membership.knock)
        PopupMenuItem(
          value: _MemberActions.approve,
          child: Row(
            children: [
              Icon(
                Icons.how_to_reg_outlined,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 18),
              Text(L10n.of(context).approve),
            ],
          ),
        ),
      PopupMenuItem(
        enabled: user.room.canChangePowerLevel && user.canChangeUserPowerLevel,
        value: _MemberActions.setRole,
        child: Row(
          children: [
            Icon(
              Icons.admin_panel_settings_outlined,
              color: theme.colorScheme.onSecondary,
            ),
            const SizedBox(width: 18),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10n.of(context).chatPermissions,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                Text(
                  user.powerLevel < 50
                      ? L10n.of(context).userLevel(user.powerLevel)
                      : user.powerLevel < 100
                          ? L10n.of(context).moderatorLevel(user.powerLevel)
                          : L10n.of(context).adminLevel(user.powerLevel),
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      if (user.canKick)
        PopupMenuItem(
          value: _MemberActions.kick,
          child: Row(
            children: [
              Icon(
                Icons.person_remove_outlined,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 18),
              Text(
                L10n.of(context).kickFromChat,
                style: TextStyle(color: theme.colorScheme.onError),
              ),
            ],
          ),
        ),
      if (user.canBan && user.membership != Membership.ban)
        PopupMenuItem(
          value: _MemberActions.ban,
          child: Row(
            children: [
              Icon(
                Icons.block_outlined,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 18),
              Text(
                L10n.of(context).banFromChat,
                style: TextStyle(color: theme.colorScheme.onError),
              ),
            ],
          ),
        ),
      if (user.canBan && user.membership == Membership.ban)
        PopupMenuItem(
          value: _MemberActions.unban,
          child: Row(
            children: [
              Icon(
                Icons.warning,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 18),
              Text(
                L10n.of(context).unbanFromChat,
                style: TextStyle(color: theme.colorScheme.onError),
              ),
            ],
          ),
        ),
      if (!isMe)
        PopupMenuItem(
          value: _MemberActions.report,
          child: Row(
            children: [
              Icon(
                Icons.gavel_outlined,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 18),
              Text(
                L10n.of(context).reportUser,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ),
        ),
    ],
  );
  if (action == null) return;
  if (!context.mounted) return;

  switch (action) {
    case _MemberActions.mention:
      onMention?.call();
      return;
    case _MemberActions.setRole:
      final power = await showPermissionChooser(
        context,
        currentLevel: user.powerLevel,
        maxLevel: user.room.ownPowerLevel,
      );
      if (power == null) return;
      if (!context.mounted) return;
      if (power >= 100) {
        final consent = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
          message: L10n.of(context).makeAdminDescription,
        );
        if (consent != OkCancelResult.ok) return;
        if (!context.mounted) return;
      }
      await showFutureLoadingDialog(
        context: context,
        future: () => user.setPower(power),
      );
      return;
    case _MemberActions.approve:
      await showFutureLoadingDialog(
        context: context,
        future: () => user.room.invite(user.id),
      );
      return;
    case _MemberActions.kick:
      if (await showOkCancelAlertDialog(
            context: context,
            title: L10n.of(context).areYouSure,
            okLabel: L10n.of(context).yes,
            cancelLabel: L10n.of(context).no,
            message: L10n.of(context).kickUserDescription,
          ) ==
          OkCancelResult.ok) {
        await showFutureLoadingDialog(
          context: context,
          future: () => user.kick(),
        );
      }
      return;
    case _MemberActions.ban:
      if (await showOkCancelAlertDialog(
            context: context,
            title: L10n.of(context).areYouSure,
            okLabel: L10n.of(context).yes,
            cancelLabel: L10n.of(context).no,
            message: L10n.of(context).banUserDescription,
          ) ==
          OkCancelResult.ok) {
        await showFutureLoadingDialog(
          context: context,
          future: () => user.ban(),
        );
      }
      return;
    case _MemberActions.report:
      final reason = await showTextInputDialog(
        context: context,
        title: L10n.of(context).whyDoYouWantToReportThis,
        okLabel: L10n.of(context).report,
        cancelLabel: L10n.of(context).cancel,
        hintText: L10n.of(context).reason,
      );
      if (reason == null || reason.isEmpty) return;

      final result = await showFutureLoadingDialog(
        context: context,
        future: () => user.room.client.reportUser(
          user.id,
          reason,
        ),
      );
      if (result.error != null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).contentHasBeenReported)),
      );
      return;
    case _MemberActions.info:
      await UserDialog.show(
        context: context,
        profile: Profile(
          userId: user.id,
          displayName: user.displayName,
          avatarUrl: user.avatarUrl,
        ),
      );
      return;
    case _MemberActions.unban:
      if (await showOkCancelAlertDialog(
            context: context,
            title: L10n.of(context).areYouSure,
            okLabel: L10n.of(context).yes,
            cancelLabel: L10n.of(context).no,
            message: L10n.of(context).unbanUserDescription,
          ) ==
          OkCancelResult.ok) {
        await showFutureLoadingDialog(
          context: context,
          future: () => user.unban(),
        );
      }
  }
}

enum _MemberActions {
  info,
  mention,
  setRole,
  kick,
  ban,
  approve,
  unban,
  report,
}
