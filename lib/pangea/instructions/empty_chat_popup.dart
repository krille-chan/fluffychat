import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_show_popup.dart';
import 'package:fluffychat/widgets/matrix.dart';

class EmptyChatPopup extends StatefulWidget {
  const EmptyChatPopup({
    super.key,
    required this.room,
    required this.transformTargetId,
  });

  final Room room;
  final String transformTargetId;

  @override
  State<EmptyChatPopup> createState() => EmptyChatPopupState();
}

class EmptyChatPopupState extends State<EmptyChatPopup> {
  StreamSubscription? _memberSubscription;

  @override
  void initState() {
    super.initState();
    if ((widget.room.summary.mJoinedMemberCount ?? 0) +
            (widget.room.summary.mInvitedMemberCount ?? 0) ==
        1) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => instructionsShowPopup(
          context,
          InstructionsEnum.emptyChatWarning,
          widget.transformTargetId,
        ),
      );
    }

    _memberSubscription = widget.room.client.onRoomState.stream.where(
      (u) {
        return u.roomId == widget.room.id &&
            u.state.type == EventTypes.RoomMember;
      },
    ).listen((event) {
      final members = (widget.room.summary.mJoinedMemberCount ?? 0) +
          (widget.room.summary.mInvitedMemberCount ?? 0);
      if (members > 1) {
        MatrixState.pAnyState.closeOverlay(
          InstructionsEnum.emptyChatWarning.toString(),
        );
      }
    });
  }

  @override
  void dispose() {
    _memberSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
