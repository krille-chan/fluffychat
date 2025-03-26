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

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  final List<Animation<double>> _swayAnimation = [];
  final List<Offset> _particleTrajectories = [];

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    if (widget.points == 0) return;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0),
      end: const Offset(0.0, -3),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _showPointsGained();
  }

  void initParticleTrajectories() {
    _particleTrajectories.clear();
    for (int i = 0; i < widget.points.abs(); i++) {
      final angle = _random.nextDouble() * (pi / 2) +
          pi / 4; // Random angle in the V-shaped range.
      const baseSpeed = 20; // Initial base speed.
      const exponentialFactor = 30; // Factor for exponential growth.
      final speedMultiplier = _random.nextDouble(); // Random speed multiplier.
      final speed = baseSpeed *
          pow(exponentialFactor, speedMultiplier); // Exponential speed.
      _particleTrajectories
          .add(Offset(speed * cos(angle), -speed * sin(angle)));
    }
  }

  void initSwayAnimations() {
    _swayAnimation.clear();
    initParticleTrajectories();

    for (int i = 0; i < widget.points; i++) {
      _swayAnimation.add(
        Tween<double>(
          begin: 0.0,
          end: 2 * pi,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.linear,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showPointsGained() {
    initSwayAnimations();
    _controller.reset();
    _controller.forward().then(
      (_) {
        if (!mounted) return;
        MatrixState.pAnyState.closeOverlay(widget.targetID);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points == 0) {
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
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: IgnorePointer(
            ignoring: _controller.isAnimating,
            child: Stack(
              children: List.generate(widget.points.abs(), (index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final progress = _controller.value;
                    final trajectory = _particleTrajectories[index];
                    return Transform.translate(
                      offset: Offset(
                        trajectory.dx * pow(progress, 2),
                        trajectory.dy * pow(progress, 2),
                      ),
                      child: plusWidget,
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
