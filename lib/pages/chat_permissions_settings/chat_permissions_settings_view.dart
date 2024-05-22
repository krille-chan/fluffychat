import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_permissions_settings/chat_permissions_settings.dart';
import 'package:fluffychat/pages/chat_permissions_settings/permission_list_tile.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ChatPermissionsSettingsView extends StatelessWidget {
  final ChatPermissionsSettingsController controller;

  const ChatPermissionsSettingsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Text(L10n.of(context)!.chatPermissions),
      ),
      body: MaxWidthBody(
        child: StreamBuilder(
          stream: controller.onChanged,
          builder: (context, _) {
            final roomId = controller.roomId;
            final room = roomId == null
                ? null
                : Matrix.of(context).client.getRoomById(roomId);
            if (room == null) {
              return Center(child: Text(L10n.of(context)!.noRoomsFound));
            }
            final powerLevelsContent = Map<String, Object?>.from(
              room.getState(EventTypes.RoomPowerLevels)?.content ?? {},
            );
            final powerLevels = Map<String, dynamic>.from(powerLevelsContent)
              ..removeWhere((k, v) => v is! int);
            final eventsPowerLevels = Map<String, int?>.from(
              powerLevelsContent.tryGetMap<String, int?>('events') ?? {},
            )..removeWhere((k, v) => v is! int);
            return Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final entry in powerLevels.entries)
                      PermissionsListTile(
                        permissionKey: entry.key,
                        permission: entry.value,
                        onChanged: (level) => controller.editPowerLevel(
                          context,
                          entry.key,
                          entry.value,
                          newLevel: level,
                        ),
                        canEdit: room.canChangePowerLevel,
                      ),
                    Divider(color: Theme.of(context).dividerColor),
                    ListTile(
                      title: Text(
                        L10n.of(context)!.notifications,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        const key = 'rooms';
                        final value = powerLevelsContent
                                .containsKey('notifications')
                            ? powerLevelsContent
                                    .tryGetMap<String, Object?>('notifications')
                                    ?.tryGet<int>('rooms') ??
                                0
                            : 0;
                        return PermissionsListTile(
                          permissionKey: key,
                          permission: value,
                          category: 'notifications',
                          canEdit: room.canChangePowerLevel,
                          onChanged: (level) => controller.editPowerLevel(
                            context,
                            key,
                            value,
                            newLevel: level,
                            category: 'notifications',
                          ),
                        );
                      },
                    ),
                    Divider(color: Theme.of(context).dividerColor),
                    ListTile(
                      title: Text(
                        L10n.of(context)!.configureChat,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (final entry in eventsPowerLevels.entries)
                      PermissionsListTile(
                        permissionKey: entry.key,
                        category: 'events',
                        permission: entry.value ?? 0,
                        canEdit: room.canChangePowerLevel,
                        onChanged: (level) => controller.editPowerLevel(
                          context,
                          entry.key,
                          entry.value ?? 0,
                          newLevel: level,
                          category: 'events',
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
