import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';

class RoomCreationStateEvent extends StatelessWidget {
  final Event event;
  const RoomCreationStateEvent({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final matrixLocals = MatrixLocals(l10n);
    final theme = Theme.of(context);
    final roomName = event.room.getLocalizedDisplayname(matrixLocals);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Avatar(
          mxContent: event.room.avatar,
          name: roomName,
          size: Avatar.defaultSize * 2,
        ),
        Text(
          roomName,
          style: theme.textTheme.headlineSmall,
        ),
        Text(
          '${event.originServerTs.localizedTime(context)} | ${l10n.countParticipants((event.room.summary.mJoinedMemberCount ?? 1) + (event.room.summary.mInvitedMemberCount ?? 0))}',
          style: theme.textTheme.labelSmall,
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
