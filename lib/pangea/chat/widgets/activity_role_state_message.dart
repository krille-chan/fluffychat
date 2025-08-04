import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import '../../../config/app_config.dart';

class ActivityRoleStateMessage extends StatelessWidget {
  final Event event;
  const ActivityRoleStateMessage(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final senderName = event.senderId == event.room.client.userID
        ? L10n.of(context).you
        : event.senderFromMemoryOrFallback.calcDisplayname();

    String role = L10n.of(context).participant;
    bool finished = false;

    try {
      final roleContent = event.content['role'] as String?;
      if (roleContent != null) {
        role = roleContent;
      }

      finished = event.content['finishedAt'] != null;
    } catch (e) {
      // If the role is not found, we keep the default participant role.
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Material(
            color: theme.colorScheme.surface.withAlpha(128),
            borderRadius: BorderRadius.circular(AppConfig.borderRadius / 3),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                finished
                    ? L10n.of(context).finishedTheActivity(senderName)
                    : L10n.of(context).joinedTheActivity(senderName, role),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12 * AppConfig.fontSizeFactor,
                  decoration:
                      event.redacted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
