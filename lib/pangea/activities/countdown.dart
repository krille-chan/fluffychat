import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';

class CountDown extends StatefulWidget {
  final DateTime? deadline;

  final double? iconSize;
  final double? textSize;

  const CountDown({
    super.key,
    required this.deadline,
    this.iconSize,
    this.textSize,
  });

  @override
  State<CountDown> createState() => CountDownState();
}

class CountDownState extends State<CountDown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String? _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final List<String> parts = [];
    if (days > 0) parts.add("${days}d");
    if (hours > 0) parts.add("${hours}h");
    if (minutes > 0) parts.add("${minutes}m");
    if (seconds > 0 && minutes <= 0) parts.add("${seconds}s");
    if (parts.isEmpty) return null;

    return parts.join(" ");
  }

  Duration? get _remainingTime {
    if (widget.deadline == null) {
      return null;
    }

    final now = DateTime.now();
    return widget.deadline!.difference(now);
  }

  @override
  Widget build(BuildContext context) {
    final remainingTime = _remainingTime;
    final durationString = _formatDuration(remainingTime ?? Duration.zero);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 250.0,
      ),
      child: Row(
        spacing: 4.0,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: widget.iconSize ?? 28.0,
          ),
          Flexible(
            child: Text(
              remainingTime != null &&
                      remainingTime >= Duration.zero &&
                      durationString != null
                  ? durationString
                  : L10n.of(context).duration,
              style: TextStyle(fontSize: widget.textSize ?? 20),
            ),
          ),
        ],
      ),
    );
  }
}
