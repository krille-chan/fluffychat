import 'dart:math';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/avatar.dart';

class OpenRolesIndicator extends StatelessWidget {
  final int totalSlots;
  final List<String> userIds;
  final Room? space;

  const OpenRolesIndicator({
    super.key,
    required this.totalSlots,
    required this.userIds,
    this.space,
  });

  @override
  Widget build(BuildContext context) {
    final remainingSlots = max(
      0,
      totalSlots - userIds.length,
    );

    final spaceParticipants = space?.getParticipants() ?? [];

    return Row(
      spacing: 2.0,
      children: [
        ...userIds.map((u) {
          final user = spaceParticipants.firstWhereOrNull(
            (p) => p.id == u,
          );
          return Avatar(
            mxContent: user?.avatarUrl,
            userId: user?.calcDisplayname() ?? u.localpart ?? u,
            size: 16,
          );
        }),
        ...List.generate(remainingSlots, (_) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 8,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              CircleAvatar(
                radius: 7,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
            ],
          );
        }),
      ],
    );
  }
}
