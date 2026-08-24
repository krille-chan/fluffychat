// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:flutter/widgets.dart';

class StartTime extends StatefulWidget {
  final DateTime startTime;
  const StartTime({required this.startTime, super.key});

  @override
  State<StartTime> createState() => _StartTimeState();
}

class _StartTimeState extends State<StartTime> {
  late final Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = DateTime.now().difference(widget.startTime);
    return Center(
      child: Text(
        '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
        style: TextStyle(fontSize: 11),
      ),
    );
  }
}
