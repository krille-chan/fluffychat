import 'dart:async';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import '../../widgets/matrix.dart';

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
      VRouter.of(context).toSegments(['rooms', widget.room.id, 'encryption']);
      return;
    }
    if (widget.room.joinRules == JoinRules.public) {
      await showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        okLabel: L10n.of(context).ok,
        message: L10n.of(context).noEncryptionForPublicRooms,
      );
      return;
    }
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context).enableEncryption,
          message: widget.room.client.encryptionEnabled
              ? L10n.of(context).enableEncryptionWarning
              : L10n.of(context).needPantalaimonWarning,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
        ) ==
        OkCancelResult.ok) {
      await showFutureLoadingDialog(
        context: context,
        future: () => widget.room.enableEncryption(),
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
            if (oneUserInvalid) color = Colors.red;
            if (!allUsersValid) color = Colors.orange;
          } else if (!widget.room.encrypted &&
              widget.room.joinRules != JoinRules.public) {
            color = Colors.red;
          }
          return IconButton(
            tooltip: widget.room.encrypted
                ? L10n.of(context).encrypted
                : L10n.of(context).encryptionNotEnabled,
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
