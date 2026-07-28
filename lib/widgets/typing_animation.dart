// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:fluffychat/config/themes.dart';
import 'package:flutter/material.dart';

class TypingAnimation extends StatefulWidget {
  final double size;
  const TypingAnimation({this.size = 8.0, super.key});

  @override
  State<TypingAnimation> createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation> {
  int _tick = 0;

  late final Timer _timer;

  static const Duration animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    _timer = Timer.periodic(animationDuration, (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _tick = (_tick + 1) % 4;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = widget.size;

    return Row(
      mainAxisSize: .min,
      children: [
        for (var i = 1; i <= 3; i++)
          AnimatedContainer(
            duration: animationDuration * 1.5,
            curve: FluffyThemes.animationCurve,
            width: size,
            height: _tick == i ? size * 2 : size,
            margin: EdgeInsets.symmetric(
              horizontal: size / 4,
              vertical: _tick == i ? 4 : 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 2),
              color: theme.colorScheme.secondary,
            ),
          ),
      ],
    );
  }
}
