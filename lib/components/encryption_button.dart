import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flushbar/flushbar_helper.dart';
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
      await Navigator.of(context).push(
        AppRoute.defaultRoute(
          context,
          ChatEncryptionSettingsView(widget.room.id),
        ),
      );
      return;
    }
    if (!widget.room.client.encryptionEnabled) {
      await FlushbarHelper.createInformation(
              message: L10n.of(context).needPantalaimonWarning)
          .show(context);
      return;
    }
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).enableEncryptionWarning,
          message: widget.room.client.encryptionEnabled
              ? L10n.of(context).warningEncryptionInBeta
              : L10n.of(context).needPantalaimonWarning,
          okLabel: L10n.of(context).yes,
        ) ==
        OkCancelResult.ok) {
      await SimpleDialogs(context).tryRequestWithLoadingDialog(
        widget.room.enableEncryption(),
      );
      // we want to enable the lock icon
      setState(() => null);
    }
  }

  @override
  void dispose() {
    _onSyncSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room.encrypted) {
      _onSyncSub ??= Matrix.of(context)
          .client
          .onSync
          .stream
          .where((s) => s.deviceLists != null)
          .listen((s) => setState(() => null));
    }
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
            icon: Icon(
                widget.room.encrypted
                    ? Icons.lock_outlined
                    : Icons.lock_open_outlined,
                size: 20,
                color: color),
            onPressed: _enableEncryptionAction,
          );
        });
  }
}
