import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:flutter/material.dart';

/// A badge that represents one learning progress indicator (i.e., construct uses)
class ProgressIndicatorBadge extends StatelessWidget {
  final int? points;
  final VoidCallback onTap;
  final ProgressIndicatorEnum progressIndicator;
  final bool loading;

  const ProgressIndicatorBadge({
    super.key,
    required this.points,
    required this.onTap,
    required this.progressIndicator,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Tooltip(
        message: progressIndicator.tooltip(context),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  progressIndicator.icon,
                  color: progressIndicator.color(context),
                ),
                const SizedBox(width: 5),
                !loading
                    ? AnimatedCount(
                        count: points ?? 0,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
          ),
        ),
      ),
    );
  }
}

class AnimatedCount extends ImplicitlyAnimatedWidget {
  const AnimatedCount({
    super.key,
    required this.count,
    this.style,
    super.duration = const Duration(seconds: 1),
    super.curve = FluffyThemes.animationCurve,
  });

  final int count;
  final TextStyle? style;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() {
    return _AnimatedCountState();
  }
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween _intCount = IntTween(begin: 0, end: 1);

  @override
  void initState() {
    super.initState();
    _intCount = IntTween(begin: 0, end: widget.count.toInt());
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final String text = _intCount.evaluate(animation).toString();
    return Text(text, style: widget.style);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _intCount = visitor(
      _intCount,
      widget.count,
      (dynamic value) => IntTween(begin: value),
    ) as IntTween;
  }
}
