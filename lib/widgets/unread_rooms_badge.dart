import 'package:badges/badges.dart' as b;
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

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
    return StreamBuilder(
      stream: Matrix.of(context)
          .client
          .onSync
          .stream
          .where((syncUpdate) => syncUpdate.hasRoomUpdate)
          // #Pangea
          .rateLimit(const Duration(seconds: 1)),
      // Pangea#
      builder: (context, _) {
        // #Pangea
        final unreadCounts = Matrix.of(context)
            .client
            .rooms
            .where(filter)
            .where((r) => (r.isUnread || r.membership == Membership.invite))
            .map((r) => r.notificationCount);
        final unreadCount =
            unreadCounts.isEmpty ? 0 : unreadCounts.reduce((a, b) => a + b);
        // final unreadCount = Matrix.of(context)
        //     .client
        //     .rooms
        //     .where(filter)
        //     .where((r) => (r.isUnread || r.membership == Membership.invite))
        //     .length;
        // Pangea#
        return b.Badge(
          badgeStyle: b.BadgeStyle(
            badgeColor: Theme.of(context).colorScheme.primary,
            elevation: 4,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surface,
              width: 2,
            ),
          ),
          badgeContent: Text(
            unreadCount.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 12,
            ),
          ),
          showBadge: unreadCount != 0,
          badgeAnimation: const b.BadgeAnimation.scale(),
          position: badgePosition ?? b.BadgePosition.bottomEnd(),
          child: child,
        );
      },
    );
  }
}
