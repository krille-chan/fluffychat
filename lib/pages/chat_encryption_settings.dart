import 'package:flutter/material.dart';

import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/views/chat_encryption_settings_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'key_verification_dialog.dart';

class ChatEncryptionSettings extends StatefulWidget {
  const ChatEncryptionSettings({Key key}) : super(key: key);

  @override
  ChatEncryptionSettingsController createState() =>
      ChatEncryptionSettingsController();
}

class ChatEncryptionSettingsController extends State<ChatEncryptionSettings> {
  String get roomId => VRouter.of(context).pathParameters['roomid'];

  Future<void> unblock(DeviceKeys key) async {
    if (key.blocked) {
      await key.setBlocked(false);
    }
  }

  Future<void> onSelected(
      BuildContext context, String action, DeviceKeys key) async {
    final room = Matrix.of(context).client.getRoomById(roomId);
    switch (action) {
      case 'verify':
        await unblock(key);
        final req = key.startVerification();
        req.onUpdate = () {
          if (req.state == KeyVerificationState.done) {
            setState(() => null);
          }
        };
        await KeyVerificationDialog(request: req).show(context);
        break;
      case 'verify_user':
        await unblock(key);
        final req =
            await room.client.userDeviceKeys[key.userId].startVerification();
        req.onUpdate = () {
          if (req.state == KeyVerificationState.done) {
            setState(() => null);
          }
        };
        await KeyVerificationDialog(request: req).show(context);
        break;
      case 'block':
        if (key.directVerified) {
          await key.setVerified(false);
        }
        await key.setBlocked(true);
        setState(() => null);
        break;
      case 'unblock':
        await unblock(key);
        setState(() => null);
        break;
    }
  }

  @override
  Widget build(BuildContext context) => ChatEncryptionSettingsView(this);
}
