import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as b;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
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

    // #Pangea
    // final unreadCount = Matrix.of(context)
    //     .client
    //     .rooms
    //     .where(filter)
    //     .where((r) => (r.isUnread || r.membership == Membership.invite))
    //     .length;
    final unreadCounts =
        Matrix.of(context).client.rooms.where(filter).where((r) {
      if (r.isAnalyticsRoom) return false;
      return r.isUnread || r.membership == Membership.invite;
    }).map((r) => r.notificationCount);
    final unreadCount =
        unreadCounts.isEmpty ? 0 : unreadCounts.reduce((a, b) => a + b);

    // Pangea#
    return b.Badge(
      badgeStyle: b.BadgeStyle(
        badgeColor: theme.colorScheme.primary,
        elevation: 4,
        borderSide: BorderSide(
          color: theme.colorScheme.surface,
          width: 2,
        ),
      ),
      badgeContent: Text(
        unreadCount.toString(),
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 12,
        ),
      ),
      showBadge: unreadCount != 0,
      badgeAnimation: const b.BadgeAnimation.scale(),
      position: badgePosition ?? b.BadgePosition.bottomEnd(),
      child: child,
    );
  }
}
