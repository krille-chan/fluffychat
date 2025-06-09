import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_permissions_settings/chat_permissions_settings_view.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/permission_slider_dialog.dart';

class ChatPermissionsSettings extends StatefulWidget {
  const ChatPermissionsSettings({super.key});

  @override
  ChatPermissionsSettingsController createState() =>
      ChatPermissionsSettingsController();
}

class ChatPermissionsSettingsController extends State<ChatPermissionsSettings> {
  String? get roomId => GoRouterState.of(context).pathParameters['roomid'];
  void editPowerLevel(
    BuildContext context,
    String key,
    int currentLevel, {
    int? newLevel,
    String? category,
  }) async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    if (!room.canSendEvent(EventTypes.RoomPowerLevels)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).noPermission)),
      );
      return;
    }
    newLevel ??= await showPermissionChooser(
      context,
      currentLevel: currentLevel,
    );
    if (newLevel == null) return;
    final content = Map<String, dynamic>.from(
      room.getState(EventTypes.RoomPowerLevels)!.content,
    );
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
      future: () => room.client.setRoomStateWithKey(
        room.id,
        EventTypes.RoomPowerLevels,
        '',
        content,
      ),
    );
  }

  Stream get onChanged => Matrix.of(context).client.onSync.stream.where(
        (e) =>
            (e.rooms?.join?.containsKey(roomId) ?? false) &&
            (e.rooms!.join![roomId!]?.timeline?.events
                    ?.any((s) => s.type == EventTypes.RoomPowerLevels) ??
                false),
      );

  // #Pangea
  Map<String, dynamic> get defaultPowerLevels {
    final chatPowerLevels = RoomDefaults.defaultPowerLevels(
      Matrix.of(context).client.userID!,
    ).content;

    final spacePowerLevels = RoomDefaults.defaultSpacePowerLevels(
      Matrix.of(context).client.userID!,
    ).content;

    if (roomId == null) return chatPowerLevels;
    final room = Matrix.of(context).client.getRoomById(roomId!);
    if (room == null) return chatPowerLevels;

    return room.isSpace ? spacePowerLevels : chatPowerLevels;
  }

  int getDefaultValue(
    String permissionKey, {
    String? category,
  }) {
    final room = Matrix.of(context).client.getRoomById(roomId!);
    if (room == null) return 0;
    final powerLevelsContent = Map<String, Object?>.from(
      room.getState(EventTypes.RoomPowerLevels)?.content ?? {},
    );

    final powerLevels = Map<String, dynamic>.from(powerLevelsContent)
      ..removeWhere((k, v) => v is! int);

    if (category == null) {
      switch (permissionKey) {
        case 'users_default':
        case 'events_default':
          return powerLevels[permissionKey] ?? 0;
        case 'state_default':
          return powerLevels[permissionKey] ?? 50;
        case 'ban':
        case 'kick':
        case 'invite':
          return powerLevels[permissionKey] ?? 0;
        case 'redact':
          return powerLevels[permissionKey] ??
              powerLevels['events_default'] ??
              0;
      }
    } else if (category == 'events') {
      return room.powerForChangingStateEvent(permissionKey);
    }
    return 0;
  }
  // Pangea#

  @override
  Widget build(BuildContext context) => ChatPermissionsSettingsView(this);
}
