import 'dart:async';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import '../utils/localized_exception_extension.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'matrix.dart';

class ConnectionStatusHeader extends StatefulWidget {
  @override
  _ConnectionStatusHeaderState createState() => _ConnectionStatusHeaderState();
}

class _ConnectionStatusHeaderState extends State<ConnectionStatusHeader> {
  StreamSubscription _onSyncSub;
  StreamSubscription _onSyncErrorSub;
  bool get _connected =>
      DateTime.now().millisecondsSinceEpoch -
          _lastSyncReceived.millisecondsSinceEpoch <
      (Matrix.of(context).client.syncTimeoutSec + 2) * 1000;
  static DateTime _lastSyncReceived = DateTime(0);
  SyncStatusUpdate _status = SyncStatusUpdate(SyncStatus.waitingForResponse);

  @override
  void dispose() {
    _onSyncSub?.cancel();
    _onSyncErrorSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onSyncSub ??= Matrix.of(context).client.onSyncStatus.stream.listen(
          (status) => setState(
            () {
              if ((status.status == SyncStatus.processing &&
                      Matrix.of(context).client.prevBatch != null) ||
                  status.status == SyncStatus.finished) {
                _lastSyncReceived = DateTime.now();
              }
              _status = status;
            },
          ),
        );

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.bounceInOut,
      height: _connected ? 0 : 36,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: _connected ? 1.0 : _status.progress,
            ),
          ),
          SizedBox(width: 12),
          Text(
            _status.toLocalizedString(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
        return L10n.of(context).loadingPleaseWait;
      case SyncStatus.error:
        return (error.exception as Object).toLocalizedString(context);
      case SyncStatus.processing:
      case SyncStatus.cleaningUp:
      case SyncStatus.finished:
      default:
        return L10n.of(context).synchronizingPleaseWait;
    }
  }
}
