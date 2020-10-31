import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat_encryption_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'dialogs/simple_dialogs.dart';
import 'matrix.dart';

class EncryptionButton extends StatefulWidget {
  final Room room;
  const EncryptionButton(this.room, {Key key}) : super(key: key);
  @override
  _EncryptionButtonState createState() => _EncryptionButtonState();
}

class _EncryptionButtonState extends State<EncryptionButton> {
  StreamSubscription _onSyncSub;

  void _enableEncryptionAction() async {
    if (widget.room.encrypted) {
      BotToast.showText(text: L10n.of(context).warningEncryptionInBeta);
      await Navigator.of(context).push(
        AppRoute.defaultRoute(
          context,
          ChatEncryptionSettingsView(widget.room.id),
        ),
      );
      return;
    }
    if (!widget.room.client.encryptionEnabled) {
      BotToast.showText(text: L10n.of(context).needPantalaimonWarning);
      return;
    }
    if (await SimpleDialogs(context).askConfirmation(
          titleText: L10n.of(context).enableEncryptionWarning,
          contentText: widget.room.client.encryptionEnabled
              ? L10n.of(context).warningEncryptionInBeta
              : L10n.of(context).needPantalaimonWarning,
          confirmText: L10n.of(context).yes,
        ) ==
        true) {
      await SimpleDialogs(context).tryRequestWithLoadingDialog(
        widget.room.enableEncryption(),
      );
    }
  }

  @override
  void dispose() {
    _onSyncSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onSyncSub ??= Matrix.of(context)
        .client
        .onSync
        .stream
        .listen((s) => setState(() => null));
    return FutureBuilder<List<User>>(
        future:
            widget.room.encrypted ? widget.room.requestParticipants() : null,
        builder: (BuildContext context, snapshot) {
          Color color;
          if (widget.room.encrypted && snapshot.hasData) {
            final users = snapshot.data;
            users.removeWhere((u) =>
                !{Membership.invite, Membership.join}.contains(u.membership) ||
                !widget.room.client.userDeviceKeys.containsKey(u.id));
            var allUsersValid = true;
            var oneUserInvalid = false;
            for (final u in users) {
              final status = widget.room.client.userDeviceKeys[u.id].verified;
              if (status != UserVerifiedStatus.verified) {
                allUsersValid = false;
              }
              if (status == UserVerifiedStatus.unknownDevice) {
                oneUserInvalid = true;
              }
            }
            color = oneUserInvalid
                ? Colors.red
                : (allUsersValid ? Colors.green : Colors.orange);
          } else if (!widget.room.encrypted &&
              widget.room.joinRules != JoinRules.public) {
            color = null;
          }
          return IconButton(
            icon: Icon(widget.room.encrypted ? Icons.lock : Icons.lock_open,
                size: 20, color: color),
            onPressed: _enableEncryptionAction,
          );
        });
  }
}
