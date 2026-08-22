// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
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

  @override
  void initState() {
    _initAudioPlayer();
    super.initState();
  }

  Future<void> _initAudioPlayer() async {
    await _player.setAsset('assets/sounds/call_ring.mp3');
    await _player.setLoopMode(.one);
    await _player.play();
  }

  @override
  void dispose() {
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
