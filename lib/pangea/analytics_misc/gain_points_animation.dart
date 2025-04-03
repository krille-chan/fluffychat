import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PointsGainedAnimation extends StatefulWidget {
  final int points;
  final String targetID;

  const PointsGainedAnimation({
    super.key,
    required this.points,
    required this.targetID,
  });

  @override
  PointsGainedAnimationState createState() => PointsGainedAnimationState();
}

class PointsGainedAnimationState extends State<PointsGainedAnimation>
    with SingleTickerProviderStateMixin {
  final Color? gainColor = AppConfig.gold;
  final Color? loseColor = Colors.red;

  AnimationController? _controller;
  Animation<double>? _offsetAnimation;
  Animation<double>? _fadeAnimation;
  final List<Animation<double>> _swayAnimation = [];
  final List<Offset> _initialVelocities = [];

  final Random _random = Random();

  static const double _particleSpeed = 50; // Base speed for particles.
  static const double gravity = 15; // Gravity constant for the animation.
  static const int duration =
      2000; // Duration of the animation in milliseconds.

  @override
  void initState() {
    super.initState();
    if (widget.points == 0) return;

    _controller = AnimationController(
      duration: const Duration(milliseconds: duration),
      vsync: this,
    );

    _offsetAnimation = Tween<double>(
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

    _showPointsGained();
  }

  void initParticleTrajectories() {
    _initialVelocities.clear();
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
      _initialVelocities.add(Offset(speed * cos(angle), -speed * sin(angle)));
    }
  }

  void initSwayAnimations() {
    if (_controller == null) return;
    _swayAnimation.clear();
    initParticleTrajectories();

    for (int i = 0; i < widget.points; i++) {
      _swayAnimation.add(
        Tween<double>(
          begin: 0.0,
          end: 2 * pi,
        ).animate(
          CurvedAnimation(
            parent: _controller!,
            curve: Curves.linear,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _showPointsGained() {
    initSwayAnimations();
    _controller?.reset();
    _controller?.forward().then(
      (_) {
        if (!mounted) return;
        MatrixState.pAnyState.closeOverlay(widget.targetID);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points == 0 ||
        _controller == null ||
        _fadeAnimation == null ||
        _offsetAnimation == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          MatrixState.pAnyState.closeOverlay(widget.targetID);
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
                  final progress = _offsetAnimation!.value;
                  final trajectory = _initialVelocities[index];
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
