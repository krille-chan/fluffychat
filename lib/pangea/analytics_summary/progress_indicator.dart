import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';

/// A badge that represents one learning progress indicator (i.e., construct uses)
class ProgressIndicatorBadge extends StatelessWidget {
  final bool loading;
  final int points;
  final ProgressIndicatorEnum indicator;

  const ProgressIndicatorBadge({
    super.key,
    required this.indicator,
    required this.loading,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: indicator.tooltip(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            size: 18,
            indicator.icon,
            color: indicator.color(context),
            weight: 1000,
          ),
          const SizedBox(width: 6.0),
          !loading
              ? AnimatedFloatingNumber(
                  number: points,
                )
              : const SizedBox(
                  height: 8,
                  width: 8,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ),
                ),
        ],
      ),
    );
  }
}

class AnimatedFloatingNumber extends StatefulWidget {
  final int number;

  const AnimatedFloatingNumber({
    super.key,
    required this.number,
  });

  @override
  State<AnimatedFloatingNumber> createState() => AnimatedFloatingNumberState();
}

class AnimatedFloatingNumberState extends State<AnimatedFloatingNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _offsetAnim;
  int? _lastNumber;
  int? _floatingNumber;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _offsetAnim = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.7),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _lastNumber = widget.number;
  }

  @override
  void didUpdateWidget(covariant AnimatedFloatingNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.number > _lastNumber!) {
      _floatingNumber = widget.number;
      _controller.forward(from: 0.0).then((_) {
        setState(() {
          _lastNumber = widget.number;
          _floatingNumber = null;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle indicatorStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_floatingNumber != null)
          SlideTransition(
            position: _offsetAnim,
            child: FadeTransition(
              opacity: ReverseAnimation(_fadeAnim),
              child: Text(
                "$_floatingNumber",
                style: indicatorStyle,
              ),
            ),
          ),
        Text(
          widget.number.toString(),
          style: indicatorStyle,
        ),
      ],
    );
  }
}
