import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as b;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'matrix.dart';

class UnreadRoomsBadge extends StatelessWidget {
  final bool Function(Room) filter;
  final b.BadgePosition? badgePosition;
  final Widget? child;

  const UnreadRoomsBadge({
    super.key,
    required this.filter,
    this.badgePosition,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final unreadCount = Matrix.of(context)
        .client
        .rooms
        .where(filter)
        .where((r) => (r.isUnread || r.membership == Membership.invite))
        .length;
    return b.Badge(
      badgeStyle: b.BadgeStyle(
        padding: const EdgeInsetsGeometry.all(1),
        badgeColor: theme.colorScheme.primary,
        elevation: 4,
        borderSide: BorderSide(
          color: theme.colorScheme.surface,
          width: 2,
        ),
      ),
      badgeContent: SizedBox(
        width: 15,
        height: 15,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            unreadCount < 100
                ? unreadCount.toString()
                : L10n.of(context).unreadPlus,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 12,
            ),
          ),
        ),
      ),
      showBadge: unreadCount != 0,
      badgeAnimation: const b.BadgeAnimation.scale(),
      position: badgePosition ?? b.BadgePosition.bottomEnd(),
      child: child,
    );
  }
}
