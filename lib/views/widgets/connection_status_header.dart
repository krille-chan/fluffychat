import 'dart:async';
import 'package:flutter/material.dart';

import 'matrix.dart';

class ConnectionStatusHeader extends StatefulWidget {
  @override
  _ConnectionStatusHeaderState createState() => _ConnectionStatusHeaderState();
}

class _ConnectionStatusHeaderState extends State<ConnectionStatusHeader> {
  StreamSubscription _onSyncSub;
  StreamSubscription _onSyncErrorSub;
  static bool _connected = true;

  set connected(bool connected) {
    if (mounted) {
      setState(() => _connected = connected);
    }
  }

  @override
  void dispose() {
    _onSyncSub?.cancel();
    _onSyncErrorSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onSyncSub ??= Matrix.of(context).client.onSync.stream.listen(
          (_) => connected = true,
        );
    _onSyncErrorSub ??= Matrix.of(context).client.onSyncError.stream.listen(
          (_) => connected = false,
        );

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _connected ? 0 : 5,
      child: LinearProgressIndicator(),
    );
  }
}
