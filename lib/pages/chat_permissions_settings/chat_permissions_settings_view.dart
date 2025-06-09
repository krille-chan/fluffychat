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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        // #Pangea
        // title: Text(L10n.of(context).chatPermissions),
        title: Text(L10n.of(context).permissions),
        // Pangea#
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
              return Center(child: Text(L10n.of(context).noRoomsFound));
            }
            final powerLevelsContent = Map<String, Object?>.from(
              room.getState(EventTypes.RoomPowerLevels)?.content ?? {},
            );
            final powerLevels = Map<String, dynamic>.from(powerLevelsContent)
              ..removeWhere((k, v) => v is! int);
            final eventsPowerLevels = Map<String, int?>.from(
              powerLevelsContent.tryGetMap<String, int?>('events') ?? {},
            )..removeWhere((k, v) => v is! int);
            // #Pangea
            final defaults = Map<String, dynamic>.from(
              controller.defaultPowerLevels,
            );

            Map<String, dynamic> missingPowerLevels = Map<String, dynamic>.from(
              defaults,
            )..removeWhere((k, v) => v is! int || powerLevels.containsKey(k));

            missingPowerLevels = missingPowerLevels.map(
              (key, value) => MapEntry(key, controller.getDefaultValue(key)),
            );

            Map<String, int?> missingEventsPowerLevels = Map<String, int?>.from(
              defaults.tryGetMap<String, int?>('events') ?? {},
            )..removeWhere(
                (k, v) => v is! int || eventsPowerLevels.containsKey(k),
              );

            missingEventsPowerLevels = missingEventsPowerLevels.map(
              (key, value) => MapEntry(
                key,
                controller.getDefaultValue(key, category: 'events'),
              ),
            );

            powerLevels.addAll(missingPowerLevels);
            eventsPowerLevels.addAll(missingEventsPowerLevels);
            // Pangea#
            return Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outlined),
                  subtitle: Text(
                    L10n.of(context).chatPermissionsDescription,
                  ),
                ),
                Divider(color: theme.dividerColor),
                ListTile(
                  title: Text(
                    // #Pangea
                    // L10n.of(context).chatPermissions,
                    L10n.of(context).permissions,
                    // Pangea#
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                        // #Pangea
                        room: room,
                        // Pangea#
                      ),
                    Divider(color: theme.dividerColor),
                    ListTile(
                      title: Text(
                        L10n.of(context).notifications,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
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
                          // #Pangea
                          room: room,
                          // Pangea#
                        );
                      },
                    ),
                    Divider(color: theme.dividerColor),
                    ListTile(
                      title: Text(
                        // #Pangea
                        // L10n.of(context).configureChat,
                        room.isSpace
                            ? L10n.of(context).configureSpace
                            : L10n.of(context).configureChat,
                        // Pangea#
                        style: TextStyle(
                          color: theme.colorScheme.primary,
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
                        // #Pangea
                        room: room,
                        // Pangea#
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
