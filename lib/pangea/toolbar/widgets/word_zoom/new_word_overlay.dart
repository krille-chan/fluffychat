import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/message_token_text/tokens_util.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewWordOverlay extends StatefulWidget {
  final Color overlayColor;
  final String transformTargetId;
  final VoidCallback? onDismiss;

  const NewWordOverlay({
    super.key,
    required this.overlayColor,
    required this.transformTargetId,
    this.onDismiss,
  });

  @override
  State<NewWordOverlay> createState() => _NewWordOverlayState();
}

class _NewWordOverlayState extends State<NewWordOverlay>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _xpScaleAnim;
  Animation<double>? _fadeAnim;
  Animation<double>? _moveAnim;
  bool columnMode = false;

  Widget? get svg => ConstructLevelEnum.seeds.icon();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1850),
    );

    _xpScaleAnim = CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _moveAnim = CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      columnMode = FluffyThemes.isColumnMode(context);
      _showFlyingWidget();
      _controller?.forward().then((_) {
        TokensUtil.clearNewTokenCache();
        widget.onDismiss?.call();
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    MatrixState.pAnyState.closeOverlay(widget.transformTargetId);
    super.dispose();
  }

  void _showFlyingWidget() {
    if (_controller == null ||
        _xpScaleAnim == null ||
        _fadeAnim == null ||
        _moveAnim == null) {
      return;
    }

    OverlayUtil.showOverlay(
      context: context,
      closePrevOverlay: false,
      ignorePointer: true,
      offset: const Offset(0, 65),
      targetAnchor: Alignment.center,
      overlayKey: widget.transformTargetId,
      transformTargetId: widget.transformTargetId,
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          final scale = _xpScaleAnim!.value;
          final fade = 1.0 - (_fadeAnim!.value);
          final move = _moveAnim!.value;

          final seedSize = 75 * scale;
          final moveY = -move * 60;

          return Transform.translate(
            offset: Offset(0, moveY),
            child: Opacity(
              opacity: fade,
              child: Transform.rotate(
                angle: scale * 2 * pi,
                child: SizedBox(
                  width: seedSize,
                  height: seedSize,
                  child: svg ?? const SizedBox(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return Positioned(
          left: 5,
          right: 5,
          top: 50,
          bottom: 5,
          child: Opacity(
            opacity: 1 - _fadeAnim!.value,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: widget.overlayColor,
            ),
          ),
        );
      },
    );
  }
}
