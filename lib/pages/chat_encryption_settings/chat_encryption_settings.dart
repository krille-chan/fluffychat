import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_encryption_settings/chat_encryption_settings_view.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';

import '../key_verification/key_verification_dialog.dart';

class ChatEncryptionSettings extends StatefulWidget {
  const ChatEncryptionSettings({super.key});

  @override
  ChatEncryptionSettingsController createState() =>
      ChatEncryptionSettingsController();
}

class ChatEncryptionSettingsController extends State<ChatEncryptionSettings> {
  String? get roomId => GoRouterState.of(context).pathParameters['roomid'];

  Room get room => Matrix.of(context).client.getRoomById(roomId!)!;

  Future<void> unblock(DeviceKeys key) async {
    if (key.blocked) {
      await key.setBlocked(false);
    }
  }

  Future<void> enableEncryption(_) async {
    final l10n = L10n.of(context);
    if (room.encrypted) {
      showOkAlertDialog(
        context: context,
        title: l10n.sorryThatsNotPossible,
        message: l10n.disableEncryptionWarning,
      );
      return;
    }
    if (room.joinRules == JoinRules.public) {
      showOkAlertDialog(
        context: context,
        title: l10n.sorryThatsNotPossible,
        message: l10n.noEncryptionForPublicRooms,
      );
      return;
    }
    if (!room.canChangeStateEvent(EventTypes.Encryption)) {
      showOkAlertDialog(
        context: context,
        title: l10n.sorryThatsNotPossible,
        message: l10n.noPermission,
      );
      return;
    }
    final consent = await showOkCancelAlertDialog(
      context: context,
      title: l10n.areYouSure,
      message: l10n.enableEncryptionWarning,
      okLabel: l10n.yes,
      cancelLabel: l10n.cancel,
    );
    if (consent != OkCancelResult.ok) return;
    if (!mounted) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => room.enableEncryption(),
    );
  }

  Future<void> startVerification() async {
    final l10n = L10n.of(context);
    final consent = await showOkCancelAlertDialog(
      context: context,
      title: l10n.verifyOtherUser,
      message: l10n.verifyOtherUserDescription,
      okLabel: l10n.ok,
      cancelLabel: l10n.cancel,
    );
    if (consent != OkCancelResult.ok) return;
    if (!mounted) return;
    final req = await room.client.userDeviceKeys[room.directChatMatrixID]!
        .startVerification();
    req.onUpdate = () {
      if (req.state == KeyVerificationState.done) {
        setState(() {});
      }
    };
    if (!mounted) return;
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
