import 'package:matrix/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class PermissionsListTile extends StatelessWidget {
  final String permissionKey;
  final int permission;
  final String category;
  final void Function() onTap;

  const PermissionsListTile({
    Key key,
    @required this.permissionKey,
    @required this.permission,
    this.category,
    this.onTap,
  }) : super(key: key);

  String getLocalizedPowerLevelString(BuildContext context) {
    if (category == null) {
      switch (permissionKey) {
        case 'users_default':
          return L10n.of(context).defaultPermissionLevel;
        case 'events_default':
          return L10n.of(context).sendMessages;
        case 'state_default':
          return L10n.of(context).configureChat;
        case 'ban':
          return L10n.of(context).banFromChat;
        case 'kick':
          return L10n.of(context).kickFromChat;
        case 'redact':
          return L10n.of(context).deleteMessage;
        case 'invite':
          return L10n.of(context).inviteContact;
      }
    } else if (category == 'notifications') {
      switch (permissionKey) {
        case 'rooms':
          return L10n.of(context).notifications;
      }
    } else if (category == 'events') {
      switch (permissionKey) {
        case EventTypes.RoomName:
          return L10n.of(context).changeTheNameOfTheGroup;
        case EventTypes.RoomPowerLevels:
          return L10n.of(context).editChatPermissions;
        case EventTypes.HistoryVisibility:
          return L10n.of(context).visibilityOfTheChatHistory;
        case EventTypes.RoomCanonicalAlias:
          return L10n.of(context).setInvitationLink;
        case EventTypes.RoomAvatar:
          return L10n.of(context).editRoomAvatar;
        case EventTypes.RoomTombstone:
          return L10n.of(context).replaceRoomWithNewerVersion;
        case EventTypes.Encryption:
          return L10n.of(context).enableEncryption;
        case 'm.room.server_acl':
          return L10n.of(context).editBlockedServers;
      }
    }
    return permissionKey;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.grey,
        child: const Icon(Icons.edit_attributes_outlined),
      ),
      title: Text(getLocalizedPowerLevelString(context)),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(permission.toString()),
            ),
          ),
          const SizedBox(width: 8),
          Text(permission.toLocalizedPowerLevelString(context)),
        ],
      ),
    );
  }
}

extension on int {
  String toLocalizedPowerLevelString(BuildContext context) {
    return this == 100
        ? L10n.of(context).admin
        : this >= 50
            ? L10n.of(context).moderator
            : L10n.of(context).participant;
  }
}
