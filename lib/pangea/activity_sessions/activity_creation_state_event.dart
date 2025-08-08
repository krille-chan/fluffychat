import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';

class ActivityCreationStateEvent extends StatelessWidget {
  final Event event;

  const ActivityCreationStateEvent({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final matrixLocals = MatrixLocals(l10n);
    final theme = Theme.of(context);
    final roomName = event.room.getLocalizedDisplayname(matrixLocals);
    return Center(
      child: Container(
        padding: const EdgeInsets.only(bottom: 32.0, top: 60.0),
        child: Material(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Avatar(
              mxContent: event.room.avatar,
              name: roomName,
              size: Avatar.defaultSize * 5,
              userId: event.room.directChatMatrixID,
            ),
          ),
        ),
      ),
    );
  }
}
