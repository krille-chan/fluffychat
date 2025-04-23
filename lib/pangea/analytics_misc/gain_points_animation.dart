import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PointsGainedAnimation extends StatefulWidget {
  final int points;
  final String targetID;
  final bool invert;

  const PointsGainedAnimation({
    super.key,
    required this.points,
    required this.targetID,
    this.invert = false,
  });

  @override
  PointsGainedAnimationState createState() => PointsGainedAnimationState();
}

class PointsGainedAnimationState extends State<PointsGainedAnimation>
    with SingleTickerProviderStateMixin {
  final Color? gainColor = AppConfig.gold;
  final Color? loseColor = Colors.red;

  AnimationController? _controller;
  Animation<double>? _fadeAnimation;
  Animation<double>? _progressAnimation;

  final List<Offset> _trajectories = [];
  final Random _random = Random();

  static const double _particleSpeed = 50;
  static const double gravity = 15;
  static const int duration = 2000;

  @override
  void initState() {
    super.initState();
    if (widget.points == 0) return;

    _controller = AnimationController(
      duration: const Duration(milliseconds: duration),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 3.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );

    initParticleTrajectories();
    _controller?.forward().then(
      (_) {
        if (!mounted) return;
        MatrixState.pAnyState.closeOverlay("${widget.targetID}_points");
      },
    );
  }

  void initParticleTrajectories() {
    for (int i = 0; i < widget.points.abs(); i++) {
      final angle =
          (i - widget.points.abs() / 2) / widget.points.abs() * (pi / 3) +
              (_random.nextDouble() - 0.5) * pi / 6 +
              pi / 2;

      final speedMultiplier =
          0.75 + _random.nextDouble() / 4; // Random speed multiplier.
      final speed = _particleSpeed *
          speedMultiplier *
          (widget.points > 0 ? 2 : 1); // Exponential speed.
      _trajectories.add(
        Offset(
          speed * cos(angle) * (widget.invert ? -1 : 1),
          -speed * sin(angle) * (widget.invert ? -1 : 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points == 0 ||
        _controller == null ||
        _fadeAnimation == null ||
        _progressAnimation == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          MatrixState.pAnyState.closeOverlay("${widget.targetID}_points");
        }
      });
      return const SizedBox();
    }

    final textColor = widget.points > 0 ? gainColor : loseColor;

    final plusWidget = Text(
      widget.points > 0 ? "+" : "-",
      style: BotStyle.text(
        context,
        big: true,
        setColor: textColor == null,
        existingStyle: TextStyle(
          color: textColor,
        ),
      ),
    );

    return Material(
      type: MaterialType.transparency,
      child: FadeTransition(
        opacity: _fadeAnimation!,
        child: IgnorePointer(
          ignoring: _controller!.isAnimating,
          child: Stack(
            children: List.generate(widget.points.abs(), (index) {
              return AnimatedBuilder(
                animation: _controller!,
                builder: (context, child) {
                  final progress = _progressAnimation!.value;
                  final trajectory = _trajectories[index];
                  return Transform.translate(
                    offset: Offset(
                      trajectory.dx * progress,
                      trajectory.dy * progress + gravity * pow(progress, 2),
                    ),
                    child: plusWidget,
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
