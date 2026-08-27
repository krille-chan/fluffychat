// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call.dart';
import 'package:fluffychat/widgets/pulsating_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

class ActiveCallIndicator extends StatelessWidget {
  final Room room;
  const ActiveCallIndicator({required this.room, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PulsatingWidget(
      spreadRadius: 3.0,
      color: theme.colorScheme.error,
      child: Material(
        color: theme.colorScheme.error,
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            spacing: 4.0,
            mainAxisSize: .min,
            children: [
              Icon(
                switch (room.activeMatrixRtcCallIntent) {
                  .voice => Icons.video_call_outlined,
                  _ => Icons.mic_outlined,
                },
                size: 16,
                color: theme.colorScheme.onError,
              ),
              Text(
                room.getActiveMatrixRtcMembers().length.toString(),
                style: TextStyle(color: theme.colorScheme.onError),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
