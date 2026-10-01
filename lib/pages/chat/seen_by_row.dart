// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

class SeenByRow extends StatelessWidget {
  final Event event;
  final Timeline timeline;
  const SeenByRow({super.key, required this.event, required this.timeline});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const maxAvatars = 7;
    return StreamBuilder(
      stream: event.room.client.onSync.stream.where(
        (syncUpdate) =>
            syncUpdate.rooms?.join?[event.room.id]?.ephemeral?.any(
              (ephemeral) => ephemeral.type == 'm.receipt',
            ) ??
            false,
      ),
      builder: (context, asyncSnapshot) {
        // Read receipts can also be on newer hidden events like reactions:
        final index = timeline.events.indexOf(event);
        final events = index == -1 ? [event] : timeline.events.take(index + 1);
        final usersById = {
          for (final e in events)
            for (final receipt in e.receipts) receipt.user.id: receipt.user,
        };
        final seenByUsers = usersById.values
            .where(
              (user) =>
                  user.id != event.room.client.userID &&
                  user.id != event.senderId,
            )
            .toList();
        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: AnimatedContainer(
            constraints: const BoxConstraints(
              maxWidth: FluffyThemes.maxTimelineWidth,
            ),
            height: seenByUsers.isEmpty ? 0 : 24,
            duration: seenByUsers.isEmpty
                ? Duration.zero
                : FluffyThemes.animationDuration,
            curve: FluffyThemes.animationCurve,
            alignment: event.senderId == Matrix.of(context).client.userID
                ? Alignment.topRight
                : Alignment.topLeft,
            padding: const EdgeInsets.only(
              bottom: 4,
              top: 1,
              left: 8,
              right: 8,
            ),
            child: Wrap(
              spacing: 4,
              children: [
                ...(seenByUsers.length > maxAvatars
                        ? seenByUsers.sublist(0, maxAvatars)
                        : seenByUsers)
                    .map(
                      (user) => Avatar(
                        mxContent: user.avatarUrl,
                        name: user.calcDisplayname(),
                        size: 16,
                      ),
                    ),
                if (seenByUsers.length > maxAvatars)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Material(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(32),
                      child: Center(
                        child: Text(
                          '+${seenByUsers.length - maxAvatars}',
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
