// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/pulsating_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

class IncomingCallDialog extends StatefulWidget {
  final Event event;
  const IncomingCallDialog({required this.event, super.key});

  @override
  State<IncomingCallDialog> createState() => _IncomingCallDialogState();
}

class _IncomingCallDialogState extends State<IncomingCallDialog> {
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription? _onSync;

  @override
  void initState() {
    _initAudioPlayer();
    _onSync = widget.event.room.client.onSync.stream.listen((_) {
      if (!mounted) return;
      if (!widget.event.room.hasActiveMatrixRtcCall) {
        Logs().i('The other party has ended the call');
        Navigator.of(context).pop();
      } else if (widget.event.room.getActiveMatrixRtcMembers().any(
        (member) =>
            member.senderId == widget.event.room.client.userID! &&
            member.deviceId != widget.event.room.client.deviceID!,
      )) {
        Logs().i('User has accepted the call on a different device');
        Navigator.of(context).pop();
      }
    });
    final timeout =
        widget.event.tryParseRtcNotificationContent()?.lifetime ??
        RtcNotificationContent.defaultLifetime;
    Future.delayed(timeout).then((_) {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
    super.initState();
  }

  Future<void> _initAudioPlayer() async {
    await _player.setAsset('assets/sounds/call_ring.mp3');
    await _player.setLoopMode(.one);
    await _player.play();
  }

  @override
  void dispose() {
    _onSync?.cancel();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayname = widget.event.room.getLocalizedDisplayname();
    final avatar = widget.event.room.avatar;
    final theme = Theme.of(context);
    return AlertDialog(
      title: Center(child: Text(L10n.of(context).incomingCall)),
      content: Column(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          PulsatingWidget(
            spreadRadius: 10.0,
            color: theme.colorScheme.primary,
            child: Avatar(mxContent: avatar, name: displayname),
          ),
          Text(displayname, textAlign: .center),
        ],
      ),
      actionsAlignment: .spaceEvenly,
      actions: [
        IconButton(
          style: IconButton.styleFrom(
            fixedSize: Size.fromRadius(24),
            elevation: theme.appBarTheme.elevation ?? 4,
            shadowColor: theme.appBarTheme.shadowColor,
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
          ),
          icon: Icon(Icons.call_end_outlined),
          onPressed: () => context.pop(false),
        ),
        IconButton(
          style: IconButton.styleFrom(
            fixedSize: Size.fromRadius(24),
            elevation: theme.appBarTheme.elevation ?? 4,
            shadowColor: theme.appBarTheme.shadowColor,
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
          ),
          icon: Icon(Icons.call_outlined),
          onPressed: () => context.pop(true),
        ),
      ],
    );
  }
}
