import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/chat_list/widgets/room_invite_dialog.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/join_codes/knock_room_extension.dart';
import 'package:fluffychat/pangea/join_codes/space_code_repo.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../common/utils/error_handler.dart';

class SpaceTapUtil {
  static Future<void> onTap(BuildContext context, Room space) async {
    switch (space.membership) {
      case Membership.join:
        context.go("/rooms/spaces/${space.id}/details");
        return;
      case Membership.leave:
        await _autoJoin(context, space);
        return;
      case Membership.invite:
        await _onInviteTap(context, space);
        return;
      case Membership.ban:
      case Membership.knock:
        context.go("/rooms/spaces/${space.id}/details");
        ErrorHandler.logError(
          m: 'should not show space with membership ${space.membership}',
          data: space.toJson(),
        );
    }
  }

  static Future<void> _autoJoin(BuildContext context, Room space) async {
    final resp = await showFutureLoadingDialog(
      context: context,
      future: space.joinKnockedRoom,
    );

    if (resp.isError) return;
    context.go("/rooms/spaces/${space.id}/details");
  }

  static Future<void> _onInviteTap(BuildContext context, Room space) async {
    final justInputtedCode = SpaceCodeRepo.recentCode;
    final spaceCode = space.classCode;
    if (spaceCode != null && justInputtedCode == spaceCode) {
      return;
    }

    final rooms = Matrix.of(context).client.rooms.where(
      (element) => element.isSpace && element.membership == Membership.join,
    );

    final isSpaceChild = rooms.any(
      (s) => s.spaceChildren.any((c) => c.roomId == space.id),
    );

    isSpaceChild || space.hasKnocked
        ? await _autoJoin(context, space)
        : await RoomInviteDialog.show(context, space);
  }
}
