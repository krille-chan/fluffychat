import 'dart:developer';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/components/dialogs/permission_slider_dialog.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/components/matrix.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:famedlysdk/famedlysdk.dart';

class ChatPermissionsSettings extends StatelessWidget {
  final String roomId;

  const ChatPermissionsSettings(this.roomId, {Key key}) : super(key: key);

  void _editPowerLevel(BuildContext context, String key, int currentLevel,
      {String category}) async {
    final room = Matrix.of(context).client.getRoomById(roomId);
    if (!room.canSendEvent(EventTypes.RoomPowerLevels)) {
      AdaptivePageLayout.of(context)
          .showSnackBar(SnackBar(content: Text(L10n.of(context).noPermission)));
      return;
    }
    final newLevel =
        await PermissionSliderDialog(initialPermission: currentLevel)
            .show(context);
    if (newLevel == null) return;
    final content = Map<String, dynamic>.from(
        room.getState(EventTypes.RoomPowerLevels).content);
    if (category != null) {
      if (!content.containsKey(category)) {
        content[category] = <String, dynamic>{};
      }
      content[category][key] = newLevel;
    } else {
      content[key] = newLevel;
    }
    inspect(content);
    await showFutureLoadingDialog(
      context: context,
      future: () =>
          room.client.sendState(room.id, EventTypes.RoomPowerLevels, content),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).editChatPermissions),
      ),
      body: StreamBuilder(
        stream: Matrix.of(context).client.onSync.stream.where(
              (e) =>
                  (e?.rooms?.join?.containsKey(roomId) ?? false) &&
                  (e.rooms.join[roomId]?.timeline?.events
                          ?.any((s) => s.type == EventTypes.RoomPowerLevels) ??
                      false),
            ),
        builder: (context, _) {
          final room = Matrix.of(context).client.getRoomById(roomId);
          final powerLevelsContent = Map<String, dynamic>.from(
              room.getState(EventTypes.RoomPowerLevels).content);
          final powerLevels = Map<String, dynamic>.from(powerLevelsContent)
            ..removeWhere((k, v) => !(v is int));
          final eventsPowerLevels =
              Map<String, dynamic>.from(powerLevelsContent['events'])
                ..removeWhere((k, v) => !(v is int));

          return ListView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var entry in powerLevels.entries)
                    PermissionsListTile(
                      permissionKey: entry.key,
                      permission: entry.value,
                      onTap: () =>
                          _editPowerLevel(context, entry.key, entry.value),
                    ),
                  Divider(thickness: 1),
                  ListTile(
                    title: Text(
                      L10n.of(context).notifications,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    final key = 'rooms';
                    final int value =
                        powerLevelsContent.containsKey('notifications')
                            ? powerLevelsContent['notifications']['rooms'] ?? 0
                            : 0;
                    return PermissionsListTile(
                      permissionKey: key,
                      permission: value,
                      category: 'notifications',
                      onTap: () => _editPowerLevel(context, key, value,
                          category: 'notifications'),
                    );
                  }),
                  Divider(thickness: 1),
                  ListTile(
                    title: Text(
                      L10n.of(context).configureChat,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (eventsPowerLevels != null)
                    for (var entry in eventsPowerLevels.entries)
                      PermissionsListTile(
                        permissionKey: entry.key,
                        category: 'events',
                        permission: entry.value,
                        onTap: () => _editPowerLevel(
                            context, entry.key, entry.value,
                            category: 'events'),
                      ),
                  if (room.ownPowerLevel >= 100) ...{
                    Divider(thickness: 1),
                    FutureBuilder<ServerCapabilities>(
                      future: room.client.requestServerCapabilities(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final String roomVersion = room
                                .getState(EventTypes.RoomCreate)
                                .content['room_version'] ??
                            '1';
                        final shouldHaveVersion =
                            snapshot.data.mRoomVersions.defaultVersion;

                        return ListTile(
                          title: Text('Current room version: $roomVersion'),
                          subtitle: roomVersion == shouldHaveVersion
                              ? null
                              : Text(
                                  'Upgrade to $shouldHaveVersion available!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor),
                                ),
                          onTap: () async {
                            final newVersion =
                                await showConfirmationDialog<String>(
                              context: context,
                              title: 'Choose Room Version',
                              actions: snapshot
                                  .data.mRoomVersions.available.entries
                                  .where((r) => r.key != roomVersion)
                                  .map((version) => AlertDialogAction(
                                      key: version.key,
                                      label:
                                          '${version.key} (${version.value.toString().split('.').last})')),
                            );
                            await showFutureLoadingDialog(
                              context: context,
                              future: () =>
                                  room.client.upgradeRoom(roomId, newVersion),
                            ).then((_) => AdaptivePageLayout.of(context).pop());
                          },
                        );
                      },
                    ),
                  },
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

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
        child: Icon(Icons.edit_attributes_outlined),
      ),
      title: Text(getLocalizedPowerLevelString(context)),
      subtitle: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(permission.toString()),
            ),
          ),
          SizedBox(width: 8),
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
