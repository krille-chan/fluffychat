import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';

class PermissionsListTile extends StatelessWidget {
  final String permissionKey;
  final int permission;
  final String? category;
  final void Function(int? level)? onChanged;
  final bool canEdit;
  // #Pangea
  final Room room;
  // Pangea#

  const PermissionsListTile({
    super.key,
    required this.permissionKey,
    required this.permission,
    this.category,
    required this.onChanged,
    required this.canEdit,
    // #Pangea
    required this.room,
    // Pangea#
  });

  String getLocalizedPowerLevelString(BuildContext context) {
    if (category == null) {
      switch (permissionKey) {
        case 'users_default':
          return L10n.of(context).defaultPermissionLevel;
        case 'events_default':
          return L10n.of(context).sendMessages;
        case 'state_default':
          // #Pangea
          // return L10n.of(context).changeGeneralChatSettings;
          return L10n.of(context).changeGeneralSettings;
        // Pangea#
        case 'ban':
          // #Pangea
          // return L10n.of(context).banFromChat;
          return L10n.of(context).ban;
        // Pangea#
        case 'kick':
          // #Pangea
          // return L10n.of(context).kickFromChat;
          return L10n.of(context).kick;
        // Pangea#
        case 'redact':
          return L10n.of(context).deleteMessage;
        case 'invite':
          // #Pangea
          // return L10n.of(context).inviteOtherUsers;
          return L10n.of(context).inviteOtherUsersToRoom;
        // Pangea#
      }
    } else if (category == 'notifications') {
      switch (permissionKey) {
        case 'rooms':
          return L10n.of(context).sendRoomNotifications;
      }
    } else if (category == 'events') {
      switch (permissionKey) {
        case EventTypes.RoomName:
          // #Pangea
          // return L10n.of(context).changeTheNameOfTheGroup;
          return room.isSpace
              ? L10n.of(context).changeTheNameOfTheSpace
              : L10n.of(context).changeTheNameOfTheChat;
        // Pangea#
        case EventTypes.RoomTopic:
          // #Pangea
          // return L10n.of(context).changeTheDescriptionOfTheGroup;
          return L10n.of(context).changeTheDescription;
        // Pangea#
        case EventTypes.RoomPowerLevels:
          // #Pangea
          // return L10n.of(context).changeTheChatPermissions;
          return L10n.of(context).changeThePermissions;
        // Pangea#
        case EventTypes.HistoryVisibility:
          return L10n.of(context).changeTheVisibilityOfChatHistory;
        case EventTypes.RoomCanonicalAlias:
          return L10n.of(context).changeTheCanonicalRoomAlias;
        case EventTypes.RoomAvatar:
          return L10n.of(context).editRoomAvatar;
        case EventTypes.RoomTombstone:
          return L10n.of(context).replaceRoomWithNewerVersion;
        case EventTypes.Encryption:
          return L10n.of(context).enableEncryption;
        case 'm.room.server_acl':
          return L10n.of(context).editBlockedServers;
        // #Pangea
        case EventTypes.SpaceChild:
          return L10n.of(context).spaceChildPermission;
        case EventTypes.RoomPinnedEvents:
          return L10n.of(context).pinMessages;
        case EventTypes.RoomJoinRules:
          return L10n.of(context).setJoinRules;
        case PangeaEventTypes.activityPlan:
          return L10n.of(context).sendActivities;
        // Pangea#
      }
    }
    return permissionKey;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = permission >= 100
        ? Colors.orangeAccent
        : permission >= 50
            ? Colors.blueAccent
            : Colors.greenAccent;
    return ListTile(
      title: Text(
        getLocalizedPowerLevelString(context),
        style: theme.textTheme.titleSmall,
      ),
      trailing: Material(
        color: color.withAlpha(32),
        borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
        child: DropdownButton<int>(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          underline: const SizedBox.shrink(),
          onChanged: canEdit ? onChanged : null,
          value: permission,
          items: [
            DropdownMenuItem(
              value: permission < 50 ? permission : 0,
              child: Text(
                L10n.of(context).userLevel(permission < 50 ? permission : 0),
              ),
            ),
            DropdownMenuItem(
              value: permission < 100 && permission >= 50 ? permission : 50,
              child: Text(
                L10n.of(context).moderatorLevel(
                  permission < 100 && permission >= 50 ? permission : 50,
                ),
              ),
            ),
            DropdownMenuItem(
              value: permission >= 100 ? permission : 100,
              child: Text(
                L10n.of(context)
                    .adminLevel(permission >= 100 ? permission : 100),
              ),
            ),
            DropdownMenuItem(
              value: null,
              child: Text(L10n.of(context).custom),
            ),
          ],
        ),
      ),
    );
  }
}
