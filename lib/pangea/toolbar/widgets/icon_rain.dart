import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class IconRain extends StatefulWidget {
  final Widget icon;
  final int burstCount;
  final int taperCount;
  final Duration burstDuration;
  final Duration taperDuration;
  final Duration fallDuration;
  final double swayAmplitude; // in pixels
  final double swayFrequency; // in Hz
  final bool addStars;

  const IconRain({
    super.key,
    required this.icon,
    this.burstCount = 20,
    this.taperCount = 8,
    this.burstDuration = const Duration(milliseconds: 300),
    this.taperDuration = const Duration(milliseconds: 900),
    this.fallDuration = const Duration(seconds: 2),
    this.swayAmplitude = 32.0,
    this.swayFrequency = 0.8,
    this.addStars = false,
  });

  @override
  State<IconRain> createState() => _IconRainState();
}

class _IconRainState extends State<IconRain> with TickerProviderStateMixin {
  final List<_FallingIcon> _icons = [];
  final Random _random = Random();
  Timer? _burstTimer;
  Timer? _taperTimer;
  int _burstSpawned = 0;
  int _taperSpawned = 0;

  @override
  void initState() {
    super.initState();
    _startBurst();
  }

  Widget _getIcon() {
    if (widget.addStars && _random.nextBool()) {
      return const Text('⭐', style: TextStyle(fontSize: 12));
    }
    return widget.icon;
  }

  void _startBurst() {
    final burstInterval = widget.burstDuration ~/ widget.burstCount;
    _burstTimer = Timer.periodic(burstInterval, (timer) {
      if (!mounted) return;
      setState(() {
        _icons.add(
          _FallingIcon(
            key: UniqueKey(),
            icon: _getIcon(),
            startX: _random.nextDouble(),
            duration: widget.fallDuration,
            swayAmplitude: widget.swayAmplitude,
            swayFrequency: widget.swayFrequency,
            fadeMidpoint: 0.4 + _random.nextDouble() * 0.2, // 40-60% down
            onComplete: () {
              if (mounted) {
                setState(() {
                  _icons.removeWhere((i) => i.key == _icons.first.key);
                });
              }
            },
          ),
        );
        _burstSpawned++;
        if (_burstSpawned >= widget.burstCount) {
          _burstTimer?.cancel();
          _startTaper();
        }
      });
    });
  }

  void _startTaper() {
    if (widget.taperCount == 0) return;
    final taperInterval = widget.taperDuration ~/ widget.taperCount;
    _taperTimer = Timer.periodic(taperInterval, (timer) {
      if (!mounted) return;
      setState(() {
        _icons.add(
          _FallingIcon(
            key: UniqueKey(),
            icon: _getIcon(),
            startX: _random.nextDouble(),
            duration: widget.fallDuration,
            swayAmplitude: widget.swayAmplitude,
            swayFrequency: widget.swayFrequency,
            fadeMidpoint: 0.4 + _random.nextDouble() * 0.2, // 40-60% down
            onComplete: () {
              if (mounted) {
                setState(() {
                  _icons.removeWhere((i) => i.key == _icons.first.key);
                });
              }
            },
          ),
        );
        _taperSpawned++;
        if (_taperSpawned >= widget.taperCount) {
          _taperTimer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _burstTimer?.cancel();
    _taperTimer?.cancel();
    _icons.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: _icons.map((icon) {
            return icon.build(
              context,
              constraints.maxWidth,
              constraints.maxHeight,
            );
          }).toList(),
        );
      },
    );
  }
}

class _FallingIcon {
  final Key key;
  final Widget icon;
  final double startX;
  final Duration duration;
  final double swayAmplitude;
  final double swayFrequency;
  final double fadeMidpoint;
  final VoidCallback onComplete;

  _FallingIcon({
    required this.key,
    required this.icon,
    required this.startX,
    required this.duration,
    required this.swayAmplitude,
    required this.swayFrequency,
    required this.fadeMidpoint,
    required this.onComplete,
  });

  Widget build(BuildContext context, double maxWidth, double maxHeight) {
    return _AnimatedFallingIcon(
      key: key,
      icon: icon,
      startX: startX,
      duration: duration,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      swayAmplitude: swayAmplitude,
      swayFrequency: swayFrequency,
      fadeMidpoint: fadeMidpoint,
      onComplete: onComplete,
    );
  }
}

class _AnimatedFallingIcon extends StatefulWidget {
  final Widget icon;
  final double startX;
  final Duration duration;
  final double maxWidth;
  final double maxHeight;
  final double swayAmplitude;
  final double swayFrequency;
  final double fadeMidpoint;
  final VoidCallback onComplete;

  const _AnimatedFallingIcon({
    super.key,
    required this.icon,
    required this.startX,
    required this.duration,
    required this.maxWidth,
    required this.maxHeight,
    required this.swayAmplitude,
    required this.swayFrequency,
    required this.fadeMidpoint,
    required this.onComplete,
  });

  @override
  State<_AnimatedFallingIcon> createState() => _AnimatedFallingIconState();
}

class _AnimatedFallingIconState extends State<_AnimatedFallingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: -40, end: widget.maxHeight + 40).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progress = _controller.value;
        final sway = widget.swayAmplitude *
            sin(
              2 * pi * widget.swayFrequency * progress + widget.startX * 2 * pi,
            );
        // Fade out after fadeMidpoint
        double opacity = 1.0;
        if (progress > widget.fadeMidpoint) {
          final fadeProgress =
              (progress - widget.fadeMidpoint) / (1 - widget.fadeMidpoint);
          opacity = 1.0 - fadeProgress.clamp(0.0, 1.0);
        }
        return Positioned(
          left: widget.startX * (widget.maxWidth - 40) + sway,
          top: _animation.value,
          child: Opacity(
            opacity: opacity,
            child: SizedBox(width: 40, height: 40, child: widget.icon),
          ),
        );
      },
    );
  }
}
