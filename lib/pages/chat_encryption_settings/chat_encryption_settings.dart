import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat_encryption_settings/chat_encryption_settings_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../key_verification/key_verification_dialog.dart';

class ChatEncryptionSettings extends StatefulWidget {
  const ChatEncryptionSettings({Key? key}) : super(key: key);

  @override
  ChatEncryptionSettingsController createState() =>
      ChatEncryptionSettingsController();
}

class ChatEncryptionSettingsController extends State<ChatEncryptionSettings> {
  String? get roomId => VRouter.of(context).pathParameters['roomid'];

  Room get room => Matrix.of(context).client.getRoomById(roomId!)!;

  Future<void> unblock(DeviceKeys key) async {
    if (key.blocked) {
      await key.setBlocked(false);
    }
  }

  void enableEncryption(_) async {
    if (room.encrypted) {
      showOkAlertDialog(
        context: context,
        title: L10n.of(context)!.sorryThatsNotPossible,
        message: L10n.of(context)!.disableEncryptionWarning,
      );
      return;
    }
    if (room.joinRules == JoinRules.public) {
      showOkAlertDialog(
        context: context,
        title: L10n.of(context)!.sorryThatsNotPossible,
        message: L10n.of(context)!.noEncryptionForPublicRooms,
      );
      return;
    }
    if (!room.canChangeStateEvent(EventTypes.Encryption)) {
      showOkAlertDialog(
        context: context,
        title: L10n.of(context)!.sorryThatsNotPossible,
        message: L10n.of(context)!.noPermission,
      );
      return;
    }
    final consent = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context)!.areYouSure,
      message: L10n.of(context)!.enableEncryptionWarning,
      okLabel: L10n.of(context)!.yes,
      cancelLabel: L10n.of(context)!.cancel,
    );
    if (consent != OkCancelResult.ok) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => room.enableEncryption(),
    );
  }

  void startVerification() async {
    final req = await room.client.userDeviceKeys[room.directChatMatrixID]!
        .startVerification();
    req.onUpdate = () {
      if (req.state == KeyVerificationState.done) {
        setState(() {});
      }
    };
    await KeyVerificationDialog(request: req).show(context);
  }

  void toggleDeviceKey(DeviceKeys key) {
    setState(() {
      key.setBlocked(!key.blocked);
    });
  }

  @override
  Widget build(BuildContext context) => ChatEncryptionSettingsView(this);
}
