import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as b;
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import '../../widgets/matrix.dart';

class EncryptionButton extends StatelessWidget {
  final Room room;
  const EncryptionButton(this.room, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<SyncUpdate>(
      stream: Matrix.of(context)
          .client
          .onSync
          .stream
          .where((s) => s.deviceLists != null),
      builder: (context, snapshot) {
        return FutureBuilder<EncryptionHealthState>(
          future: room.encrypted
              ? room.calcEncryptionHealthState()
              : Future.value(EncryptionHealthState.allVerified),
          builder: (BuildContext context, snapshot) => IconButton(
            tooltip: room.encrypted
                ? L10n.of(context).encrypted
                : L10n.of(context).encryptionNotEnabled,
            icon: b.Badge(
              badgeAnimation: const b.BadgeAnimation.fade(),
              showBadge:
                  snapshot.data == EncryptionHealthState.unverifiedDevices,
              badgeStyle: b.BadgeStyle(
                badgeColor: theme.colorScheme.error,
                elevation: 4,
              ),
              badgeContent: Text(
                '!',
                style: TextStyle(
                  fontSize: 9,
                  color: theme.colorScheme.onError,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Icon(
                room.encrypted ? Icons.lock_outlined : Icons.lock_open_outlined,
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
            onPressed: () => context.go('/rooms/${room.id}/encryption'),
          ),
        );
      },
    );
  }
}
