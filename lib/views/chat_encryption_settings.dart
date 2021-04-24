import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/ui/chat_encryption_settings_ui.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'key_verification_dialog.dart';

class ChatEncryptionSettings extends StatefulWidget {
  final String id;

  const ChatEncryptionSettings(this.id, {Key key}) : super(key: key);

  @override
  ChatEncryptionSettingsController createState() =>
      ChatEncryptionSettingsController();
}

class ChatEncryptionSettingsController extends State<ChatEncryptionSettings> {
  Future<void> onSelected(
      BuildContext context, String action, DeviceKeys key) async {
    final room = Matrix.of(context).client.getRoomById(widget.id);
    final unblock = () async {
      if (key.blocked) {
        await key.setBlocked(false);
      }
    };
    switch (action) {
      case 'verify':
        await unblock();
        final req = key.startVerification();
        req.onUpdate = () {
          if (req.state == KeyVerificationState.done) {
            setState(() => null);
          }
        };
        await KeyVerificationDialog(request: req).show(context);
        break;
      case 'verify_user':
        await unblock();
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
        await unblock();
        setState(() => null);
        break;
    }
  }

  @override
  Widget build(BuildContext context) => ChatEncryptionSettingsUI(this);
}
