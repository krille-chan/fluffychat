import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/common/utils/overlay.dart';
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
  Animation<double>? _opacityAnim;
  Animation<double>? _moveAnim;
  Animation<double>? _backgroundFadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _opacityAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(_controller!);

    _backgroundFadeAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(_controller!);

    _moveAnim = CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    if (_controller == null || _opacityAnim == null || _moveAnim == null) {
      return;
    }

    OverlayUtil.showOverlay(
      context: context,
      closePrevOverlay: false,
      ignorePointer: true,
      offset: const Offset(0, 45),
      targetAnchor: Alignment.center,
      overlayKey: widget.transformTargetId,
      transformTargetId: widget.transformTargetId,
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          final opacity = _opacityAnim!.value;
          final move = _moveAnim!.value;
          final moveY = -move * 60;

          return Transform.translate(
            offset: Offset(0, moveY),
            child: Opacity(
              opacity: opacity,
              child: const NewVocabBubble(),
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
            opacity: _backgroundFadeAnim!.value,
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

class NewVocabBubble extends StatelessWidget {
  const NewVocabBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.toys_and_games,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 4.0),
          Text(
            "+ 1",
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
