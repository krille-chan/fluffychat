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
      1000 * 30;
  static DateTime _lastSyncReceived = DateTime(0);
  SdkError _error;

  @override
  void dispose() {
    _onSyncSub?.cancel();
    _onSyncErrorSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onSyncSub ??= Matrix.of(context).client.onSync.stream.listen(
          (_) => setState(
            () {
              _lastSyncReceived = DateTime.now();
              _error = null;
            },
          ),
        );
    _onSyncErrorSub ??= Matrix.of(context).client.onSyncError.stream.listen(
          (error) => setState(
            () {
              _lastSyncReceived = DateTime(0);
              _error = error;
            },
          ),
        );

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
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
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text(
            _error != null
                ? (_error.exception as Object).toLocalizedString(context)
                : L10n.of(context).loadingPleaseWait,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
