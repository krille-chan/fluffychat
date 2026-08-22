// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class PulsatingWidget extends StatefulWidget {
  final Color color;
  final Widget child;
  final double spreadRadius;
  const PulsatingWidget({
    required this.child,
    this.color = Colors.red,
    this.spreadRadius = 1.0,
    super.key,
  });

  @override
  State<PulsatingWidget> createState() => _PulsatingWidgetState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _PulsatingWidgetState extends State<PulsatingWidget>
    with TickerProviderStateMixin {
  late final DecorationTween decorationTween = DecorationTween(
    begin: BoxDecoration(
      borderRadius: BorderRadius.circular(128),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: widget.color.withAlpha(16),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ],
    ),
    end: BoxDecoration(
      borderRadius: BorderRadius.circular(128),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: widget.color.withAlpha(128),
          blurRadius: 0.0,
          spreadRadius: widget.spreadRadius,
        ),
      ],
    ),
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return DecoratedBoxTransition(
      decoration: decorationTween.animate(_controller),
      child: widget.child,
    );
  }
}
