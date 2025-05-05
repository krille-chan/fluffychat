import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';

// #Pangea
// class RoomCreationStateEvent extends StatelessWidget {
class RoomCreationStateEvent extends StatefulWidget {
  // Pangea#
  final Event event;
  const RoomCreationStateEvent({required this.event, super.key});

  // #Pangea
  @override
  State<RoomCreationStateEvent> createState() => RoomCreationStateEventState();
}

class RoomCreationStateEventState extends State<RoomCreationStateEvent> {
  Event get event => widget.event;
  StreamSubscription? _memberSubscription;

  int get _members =>
      (event.room.summary.mJoinedMemberCount ?? 0) +
      (event.room.summary.mInvitedMemberCount ?? 0);

  @override
  void initState() {
    super.initState();
    _memberSubscription = event.room.client.onRoomState.stream.where(
      (u) {
        return u.roomId == event.room.id &&
            u.state.type == EventTypes.RoomMember;
      },
    ).listen((_) {
      if (_members > 1) setState(() {});
    });
  }

  @override
  void dispose() {
    _memberSubscription?.cancel();
    super.dispose();
  }
  // Pangea#

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final matrixLocals = MatrixLocals(l10n);
    final theme = Theme.of(context);
    final roomName = event.room.getLocalizedDisplayname(matrixLocals);
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Center(
        child: Material(
          color: theme.colorScheme.surface.withAlpha(128),
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Avatar(
                  mxContent: event.room.avatar,
                  name: roomName,
                  // #Pangea
                  userId: event.room.directChatMatrixID,
                  useRive: true,
                  // Pangea#
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
                // #Pangea
                InstructionsInlineTooltip(
                  instructionsEnum: InstructionsEnum.clickMessage,
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                  ),
                  onClose: () => setState(() {}),
                ),
                if (_members <= 1 && InstructionsEnum.clickMessage.isToggledOff)
                  const InstructionsInlineTooltip(
                    instructionsEnum: InstructionsEnum.emptyChatWarning,
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                    ),
                  ),
                // Pangea#
              ],
            ),
          ),
        ),
      ),
    );
  }
}
