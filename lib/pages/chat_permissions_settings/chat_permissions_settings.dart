import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat_permissions_settings/chat_permissions_settings_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/permission_slider_dialog.dart';

class ChatPermissionsSettings extends StatefulWidget {
  const ChatPermissionsSettings({Key? key}) : super(key: key);

  @override
  ChatPermissionsSettingsController createState() =>
      ChatPermissionsSettingsController();
}

class ChatPermissionsSettingsController extends State<ChatPermissionsSettings> {
  String? get roomId => VRouter.of(context).pathParameters['roomid'];
  void editPowerLevel(
    BuildContext context,
    String key,
    int currentLevel, {
    String? category,
  }) async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    if (!room.canSendEvent(EventTypes.RoomPowerLevels)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context)!.noPermission)),
      );
      return;
    }
    final newLevel = await showPermissionChooser(
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

  void updateRoomAction(Capabilities capabilities) async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final String roomVersion =
        room.getState(EventTypes.RoomCreate)!.content['room_version'] ?? '1';
    final newVersion = await showConfirmationDialog<String>(
      context: context,
      title: L10n.of(context)!.replaceRoomWithNewerVersion,
      actions: capabilities.mRoomVersions!.available.entries
          .where((r) => r.key != roomVersion)
          .map(
            (version) => AlertDialogAction(
              key: version.key,
              label:
                  '${version.key} (${version.value.toString().split('.').last})',
            ),
          )
          .toList(),
    );
    if (newVersion == null ||
        OkCancelResult.cancel ==
            await showOkCancelAlertDialog(
              useRootNavigator: false,
              context: context,
              okLabel: L10n.of(context)!.yes,
              cancelLabel: L10n.of(context)!.cancel,
              title: L10n.of(context)!.areYouSure,
            )) {
      return;
    }
    await showFutureLoadingDialog(
      context: context,
      future: () => room.client.upgradeRoom(roomId!, newVersion),
    ).then((_) => VRouter.of(context).pop());
  }

  @override
  Widget build(BuildContext context) => ChatPermissionsSettingsView(this);
}
