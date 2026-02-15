import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SeenByRow extends StatelessWidget {
  final Timeline timeline;
  final Event event;
  const SeenByRow({super.key, required this.timeline, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const maxAvatars = 7;
    return StreamBuilder(
      stream: timeline.room.client.onSync.stream.where(
        (syncUpdate) =>
            syncUpdate.rooms?.join?[timeline.room.id]?.ephemeral?.any(
              (ephemeral) => ephemeral.type == 'm.receipt',
            ) ??
            false,
      ),
      builder: (context, asyncSnapshot) {
        final seenByUsers = event.receipts.map((r) => r.user).toList();
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
            alignment:
                timeline.events.isNotEmpty &&
                    timeline.events.first.senderId ==
                        Matrix.of(context).client.userID
                ? Alignment.topRight
                : Alignment.topLeft,
            padding: const EdgeInsets.only(bottom: 4, top: 1),
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
