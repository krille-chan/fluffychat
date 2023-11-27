// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';

bool canAddToSpace(Room space, PangeaController pangeaController) {
  final bool pangeaPermission =
      pangeaController.permissionsController.canUserGroupChat(roomID: space.id);
  final Map<String, dynamic> powerLevelsMap =
      space.getState(EventTypes.RoomPowerLevels)?.content ?? {};
  final pl = powerLevelsMap
          .tryGetMap<String, dynamic>('events')
          ?.tryGet<int>(EventTypes.spaceChild) ??
      powerLevelsMap.tryGet<int>('events_default') ??
      50;
  return space.ownPowerLevel >= pl && pangeaPermission;
}

bool chatIsInSpace(Room chat, Room space) {
  return chat.spaceParents.map((e) => e.roomId).toList().contains(space.id);
}

Future<void> pangeaAddToSpace(
  Room space,
  List<String> selectedRoomIds,
  BuildContext context,
  PangeaController pangeaController,
) async {
  if (!canAddToSpace(space, pangeaController)) {
    throw L10n.of(context)!.noAddToSpacePermissions;
  }
  for (final roomId in selectedRoomIds) {
    final Room? room = Matrix.of(context).client.getRoomById(roomId);
    if (room != null && chatIsInSpace(room, space)) {
      throw L10n.of(context)!.alreadyInSpace;
    }
    await space.setSpaceChild(roomId);
  }
}
