import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as b;
import 'package:matrix/matrix.dart';

import 'matrix.dart';

class UnreadRoomsBadge extends StatelessWidget {
  final bool Function(Room) filter;
  final b.BadgePosition? badgePosition;
  final Widget? child;

  const UnreadRoomsBadge({
    Key? key,
    required this.filter,
    this.badgePosition,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Matrix.of(context)
          .client
          .onSync
          .stream
          .where((syncUpdate) => syncUpdate.hasRoomUpdate),
      builder: (context, _) {
        final unreadCount = Matrix.of(context)
            .client
            .rooms
            .where(filter)
            .where((r) => (r.isUnread || r.membership == Membership.invite))
            .length;
        return b.Badge(
          alignment: Alignment.bottomRight,
          badgeContent: Text(
            unreadCount.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 12,
            ),
          ),
          showBadge: unreadCount != 0,
          animationType: b.BadgeAnimationType.scale,
          badgeColor: Theme.of(context).colorScheme.primary,
          position: badgePosition,
          elevation: 4,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.background,
            width: 2,
          ),
          child: child,
        );
      },
    );
  }
}
