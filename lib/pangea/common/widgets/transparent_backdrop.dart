import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import '../../../config/themes.dart';
import '../../../widgets/matrix.dart';

class TransparentBackdrop extends StatefulWidget {
  final Color? backgroundColor;
  final VoidCallback? onDismiss;
  final bool blurBackground;

  const TransparentBackdrop({
    super.key,
    this.onDismiss,
    this.backgroundColor,
    this.blurBackground = false,
  });

  @override
  TransparentBackdropState createState() => TransparentBackdropState();
}

class TransparentBackdropState extends State<TransparentBackdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityTween;
  late Animation<double> _blurTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:
          const Duration(milliseconds: AppConfig.overlayAnimationDuration),
      vsync: this,
    );
    _opacityTween = Tween<double>(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: FluffyThemes.animationCurve,
      ),
    );
    _blurTween = Tween<double>(begin: 0.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: FluffyThemes.animationCurve,
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityTween,
      builder: (context, _) {
        return Material(
          borderOnForeground: false,
          color: widget.backgroundColor
                  ?.withAlpha((_opacityTween.value * 255).round()) ??
              Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              if (widget.onDismiss != null) {
                widget.onDismiss!();
              }
              MatrixState.pAnyState.closeOverlay();
            },
            child: AnimatedBuilder(
              animation: _blurTween,
              builder: (context, _) {
                return BackdropFilter(
                  filter: widget.blurBackground
                      ? ImageFilter.blur(
                          sigmaX: _blurTween.value,
                          sigmaY: _blurTween.value,
                        )
                      : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
