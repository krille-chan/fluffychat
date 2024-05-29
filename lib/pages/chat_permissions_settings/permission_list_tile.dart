import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';

class PermissionsListTile extends StatelessWidget {
  final String permissionKey;
  final int permission;
  final String? category;
  final void Function(int? level)? onChanged;
  final bool canEdit;

  const PermissionsListTile({
    super.key,
    required this.permissionKey,
    required this.permission,
    this.category,
    required this.onChanged,
    required this.canEdit,
  });

  String getLocalizedPowerLevelString(BuildContext context) {
    if (category == null) {
      switch (permissionKey) {
        case 'users_default':
          return L10n.of(context)!.defaultPermissionLevel;
        case 'events_default':
          return L10n.of(context)!.sendMessages;
        case 'state_default':
          return L10n.of(context)!.configureChat;
        case 'ban':
          return L10n.of(context)!.banFromChat;
        case 'kick':
          return L10n.of(context)!.kickFromChat;
        case 'redact':
          return L10n.of(context)!.deleteMessage;
        case 'invite':
          return L10n.of(context)!.inviteContact;
      }
    } else if (category == 'notifications') {
      switch (permissionKey) {
        case 'rooms':
          return L10n.of(context)!.notifications;
      }
    } else if (category == 'events') {
      switch (permissionKey) {
        case EventTypes.RoomName:
          return L10n.of(context)!.changeTheNameOfTheGroup;
        case EventTypes.RoomPowerLevels:
          return L10n.of(context)!.chatPermissions;
        case EventTypes.HistoryVisibility:
          return L10n.of(context)!.visibilityOfTheChatHistory;
        case EventTypes.RoomCanonicalAlias:
          return L10n.of(context)!.setInvitationLink;
        case EventTypes.RoomAvatar:
          return L10n.of(context)!.editRoomAvatar;
        case EventTypes.RoomTombstone:
          return L10n.of(context)!.replaceRoomWithNewerVersion;
        case EventTypes.Encryption:
          return L10n.of(context)!.enableEncryption;
        case 'm.room.server_acl':
          return L10n.of(context)!.editBlockedServers;
      }
    }
    return permissionKey;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(getLocalizedPowerLevelString(context)),
      subtitle: Text(
        L10n.of(context)!.minimumPowerLevel(permission.toString()),
      ),
      trailing: Material(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
        color: Theme.of(context).colorScheme.onInverseSurface,
        child: DropdownButton<int>(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          underline: const SizedBox.shrink(),
          onChanged: canEdit ? onChanged : null,
          value: {0, 50, 100}.contains(permission) ? permission : null,
          items: [
            DropdownMenuItem(
              value: 0,
              child: Text(L10n.of(context)!.user),
            ),
            DropdownMenuItem(
              value: 50,
              child: Text(L10n.of(context)!.moderator),
            ),
            DropdownMenuItem(
              value: 100,
              child: Text(L10n.of(context)!.admin),
            ),
            DropdownMenuItem(
              value: null,
              child: Text(L10n.of(context)!.custom),
            ),
          ],
        ),
      ),
    );
  }
}
