import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../utils/localized_exception_extension.dart';
import 'matrix.dart';

class ConnectionStatusHeader extends StatefulWidget {
  const ConnectionStatusHeader({Key? key}) : super(key: key);

  @override
  _ConnectionStatusHeaderState createState() => _ConnectionStatusHeaderState();
}

class _ConnectionStatusHeaderState extends State<ConnectionStatusHeader> {
  StreamSubscription? _onSyncSub;
  static bool _anySyncReceived = false;

  SyncStatusUpdate _status =
      const SyncStatusUpdate(SyncStatus.waitingForResponse);

  @override
  void dispose() {
    _onSyncSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onSyncSub ??= Matrix.of(context).client.onSyncStatus.stream.listen(
          (status) => setState(
            () {
              _status = status;
              if (status.status == SyncStatus.finished) {
                _anySyncReceived = true;
              }
            },
          ),
        );

    final hide = _anySyncReceived &&
        _status.status != SyncStatus.error &&
        Matrix.of(context).client.prevBatch != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceInOut,
      height: hide ? 0 : 36,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 2,
              value: hide ? 1.0 : _status.progress,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _status.toLocalizedString(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

extension on SyncStatusUpdate {
  String toLocalizedString(BuildContext context) {
    switch (status) {
      case SyncStatus.waitingForResponse:
        return L10n.of(context)!.loadingPleaseWait;
      case SyncStatus.error:
        return ((error?.exception ?? Object()) as Object)
            .toLocalizedString(context);
      case SyncStatus.processing:
      case SyncStatus.cleaningUp:
      case SyncStatus.finished:
      default:
        return L10n.of(context)!.synchronizingPleaseWait;
    }
  }
}
