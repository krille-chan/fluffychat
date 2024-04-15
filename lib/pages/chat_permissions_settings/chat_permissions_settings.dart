import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_permissions_settings/chat_permissions_settings_view.dart';
import 'package:fluffychat/widgets/matrix.dart';

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
        SnackBar(content: Text(L10n.of(context)!.noPermission)),
      );
      return;
    }
    newLevel ??= int.tryParse(
      (await showTextInputDialog(
            context: context,
            title: L10n.of(context)!.setPermissionsLevel,
            textFields: [
              DialogTextField(
                initialText: currentLevel.toString(),
                keyboardType: TextInputType.number,
                autocorrect: false,
                validator: (text) {
                  if (text == null) {
                    return L10n.of(context)!.pleaseEnterANumber;
                  }
                  final level = int.tryParse(text);
                  if (level == null || level < 0) {
                    return L10n.of(context)!.pleaseEnterANumber;
                  }
                  return null;
                },
              ),
            ],
          ))
              ?.singleOrNull ??
          '',
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

  @override
  Widget build(BuildContext context) => ChatPermissionsSettingsView(this);
}
