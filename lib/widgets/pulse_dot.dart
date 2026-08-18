import 'dart:async';

import 'package:fluffychat/config/themes.dart';
import 'package:flutter/widgets.dart';

class PulseDot extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  const PulseDot({
    required this.child,
    this.animationDuration = FluffyThemes.animationDuration,
    super.key,
  });

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot> {
  double _scaleFactor = 1.0;

  late final Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(widget.animationDuration, (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _scaleFactor = _scaleFactor == 1.0 ? 0.8 : 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scaleFactor,
      duration: widget.animationDuration,
      curve: FluffyThemes.animationCurve,
      child: widget.child,
    );
  }
}
