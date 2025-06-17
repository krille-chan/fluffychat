import 'dart:async';

import 'package:flutter/material.dart';

class ActivityAwareBuilder extends StatefulWidget {
  final DateTime? deadline;
  final Widget Function(bool) builder;

  const ActivityAwareBuilder({
    super.key,
    required this.builder,
    this.deadline,
  });

  @override
  State<ActivityAwareBuilder> createState() => ActivityAwareBuilderState();
}

class ActivityAwareBuilderState extends State<ActivityAwareBuilder> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _setTimer();
  }

  @override
  void didUpdateWidget(covariant ActivityAwareBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deadline != widget.deadline) {
      _setTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setTimer() {
    final now = DateTime.now();
    final delay = widget.deadline?.difference(now);

    if (delay != null && delay > Duration.zero) {
      _timer?.cancel();
      _timer = Timer(delay, () {
        _timer?.cancel();
        _timer = null;
        if (mounted) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      widget.deadline != null && widget.deadline!.isAfter(DateTime.now()),
    );
  }
}
