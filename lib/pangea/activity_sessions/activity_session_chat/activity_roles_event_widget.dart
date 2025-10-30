import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';

class ActivityRolesEvent extends StatelessWidget {
  final Event event;
  const ActivityRolesEvent({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Set<ActivityRoleModel> difference = {};
    try {
      final currentRoles = (event.content['roles'] as Map<String, dynamic>)
          .values
          .map((v) => ActivityRoleModel.fromJson(v))
          .toSet();

      final previousRoles =
          (event.prevContent?['roles'] as Map<String, dynamic>?)
                  ?.values
                  .map((v) => ActivityRoleModel.fromJson(v))
                  .toSet() ??
              {};

      difference = currentRoles.difference(previousRoles);
    } catch (e) {
      debugPrint("Failed to parse activity roles: $e");
    }

    if (difference.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: difference.map((role) {
        final user = event.room.getParticipants().firstWhereOrNull(
              (u) => u.id == role.userId,
            );

        final displayName =
            user?.calcDisplayname() ?? role.userId.localpart ?? role.userId;

        final message = role.stateEventMessage(displayName, L10n.of(context));
        if (message == null) {
          return const SizedBox();
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    "${role.stateEventMessage(displayName, L10n.of(context))}",
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
      }).toList(),
    );
  }
}
