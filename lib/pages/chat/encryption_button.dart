import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import '../../widgets/matrix.dart';

class EncryptionButton extends StatelessWidget {
  final Room room;
  const EncryptionButton(this.room, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SyncUpdate>(
      stream: Matrix.of(context)
          .client
          .onSync
          .stream
          .where((s) => s.deviceLists != null),
      builder: (context, snapshot) {
        return FutureBuilder<EncryptionHealthState>(
          future: room.calcEncryptionHealthState(),
          builder: (BuildContext context, snapshot) => IconButton(
            tooltip: room.encrypted
                ? L10n.of(context)!.encrypted
                : L10n.of(context)!.encryptionNotEnabled,
            icon: Icon(
              room.encrypted ? Icons.lock_outlined : Icons.lock_open_outlined,
              size: 20,
              color: room.joinRules != JoinRules.public && !room.encrypted
                  ? Colors.red
                  : room.joinRules != JoinRules.public &&
                          snapshot.data ==
                              EncryptionHealthState.unverifiedDevices
                      ? Colors.orange
                      : null,
            ),
            onPressed: () => VRouter.of(context)
                .toSegments(['rooms', room.id, 'encryption']),
          ),
        );
      },
    );
  }
}
