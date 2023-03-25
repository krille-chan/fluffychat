import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'chat.dart';

class TombstoneDisplay extends StatelessWidget {
  final ChatController controller;
  const TombstoneDisplay(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.room.getState(EventTypes.RoomTombstone) == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 72,
      child: Material(
        color: Theme.of(context).colorScheme.surfaceVariant,
        elevation: 1,
        child: ListTile(
          leading: CircleAvatar(
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(Icons.upgrade_outlined),
          ),
          title: Text(
            controller.room
                .getState(EventTypes.RoomTombstone)!
                .parsedTombstoneContent
                .body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          subtitle: Text(L10n.of(context)!.goToTheNewRoom),
          onTap: controller.goToNewRoomAction,
        ),
      ),
    );
  }
}
