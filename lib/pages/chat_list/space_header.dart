// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

enum SpaceActions { settings, rooms, invite, members, leave }

class SpaceHeader extends StatefulWidget implements PreferredSizeWidget {
  final String spaceId;
  final void Function() onBack;
  final String? activeChat;

  const SpaceHeader({
    required this.spaceId,
    required this.onBack,
    required this.activeChat,
    super.key,
  });

  @override
  State<SpaceHeader> createState() => _SpaceHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _SpaceHeaderState extends State<SpaceHeader> {
  StreamSubscription? _childStateSub;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _childStateSub?.cancel();
    super.dispose();
  }

  Future<void> _onSpaceAction(SpaceActions action) async {
    final space = Matrix.of(context).client.getRoomById(widget.spaceId);

    switch (action) {
      case SpaceActions.settings:
        await space?.postLoad();
        if (!mounted) return;
        context.push('/rooms/${widget.spaceId}/details');
        break;
      case SpaceActions.rooms:
        await space?.postLoad();
        if (!mounted) return;
        context.push('/rooms/${widget.spaceId}/rooms');
        break;
      case SpaceActions.invite:
        await space?.postLoad();
        if (!mounted) return;
        context.push('/rooms/${widget.spaceId}/invite');
        break;
      case SpaceActions.members:
        await space?.postLoad();
        if (!mounted) return;
        context.push('/rooms/${widget.spaceId}/details/members');
        break;
      case SpaceActions.leave:
        final confirmed = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
          message: L10n.of(context).archiveRoomDescription,
          okLabel: L10n.of(context).leave,
          cancelLabel: L10n.of(context).cancel,
          isDestructive: true,
        );
        if (!mounted) return;
        if (confirmed != OkCancelResult.ok) return;

        final success = await showFutureLoadingDialog(
          context: context,
          future: () async => await space?.leave(),
        );
        if (!mounted) return;
        if (success.error != null) return;
        widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final room = Matrix.of(context).client.getRoomById(widget.spaceId);
    final displayname =
        room?.getLocalizedDisplayname() ?? L10n.of(context).nothingFound;
    const avatarSize = Avatar.defaultSize / 1.5;
    final isAdmin = room?.canChangeStateEvent(EventTypes.SpaceChild) == true;
    return SliverAppBar(
      leading:
          FluffyThemes.isColumnMode(context) ||
              AppSettings.displayNavigationRail.value
          ? null
          : Center(child: CloseButton(onPressed: widget.onBack)),
      automaticallyImplyLeading: false,
      titleSpacing:
          FluffyThemes.isColumnMode(context) ||
              AppSettings.displayNavigationRail.value
          ? null
          : 0,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Avatar(
          size: avatarSize,
          mxContent: room?.avatar,
          name: displayname,
          shapeBorder: RoundedSuperellipseBorder(
            side: BorderSide(width: 1, color: theme.dividerColor),
            borderRadius: BorderRadius.circular(AppConfig.spaceBorderRadius),
          ),
          borderRadius: BorderRadius.circular(AppConfig.spaceBorderRadius),
        ),
        title: Text(displayname, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      actions: [
        if (isAdmin)
          IconButton(
            icon: Icon(Icons.add_outlined),
            tooltip: L10n.of(context).addChatOrSubSpace,
            onPressed: () =>
                context.go('/rooms/newgroup?space_id=${widget.spaceId}'),
          ),
        PopupMenuButton<SpaceActions>(
          useRootNavigator: true,
          onSelected: _onSpaceAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: SpaceActions.settings,
              child: Row(
                mainAxisSize: .min,
                children: [
                  const Icon(Icons.settings_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).settings),
                ],
              ),
            ),
            PopupMenuItem(
              value: SpaceActions.rooms,
              child: Row(
                mainAxisSize: .min,
                children: [
                  const Icon(Icons.room_preferences_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).rooms),
                ],
              ),
            ),
            PopupMenuItem(
              value: SpaceActions.invite,
              child: Row(
                mainAxisSize: .min,
                children: [
                  const Icon(Icons.person_add_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).invite),
                ],
              ),
            ),
            PopupMenuItem(
              value: SpaceActions.members,
              child: Row(
                mainAxisSize: .min,
                children: [
                  const Icon(Icons.group_outlined),
                  const SizedBox(width: 12),
                  Text(
                    L10n.of(
                      context,
                    ).countParticipants(room?.summary.mJoinedMemberCount ?? 1),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: SpaceActions.leave,
              child: Row(
                mainAxisSize: .min,
                children: [
                  const Icon(Icons.delete_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).leave),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
