import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class MessageAnalyticsFeedback extends StatefulWidget {
  final String overlayId;
  final int newGrammarConstructs;
  final int newVocabConstructs;

  const MessageAnalyticsFeedback({
    required this.overlayId,
    required this.newGrammarConstructs,
    required this.newVocabConstructs,
    super.key,
  });

  @override
  State<MessageAnalyticsFeedback> createState() =>
      MessageAnalyticsFeedbackState();
}

class MessageAnalyticsFeedbackState extends State<MessageAnalyticsFeedback>
    with TickerProviderStateMixin {
  late AnimationController _vocabController;
  late AnimationController _grammarController;
  late AnimationController _bubbleController;

  late Animation<double> _vocabOpacity;
  late Animation<double> _grammarOpacity;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  static const counterDelay = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _grammarController = AnimationController(
      vsync: this,
      duration: FluffyThemes.animationDuration,
    );

    _grammarOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _grammarController, curve: Curves.easeInOut),
    );

    _vocabController = AnimationController(
      vsync: this,
      duration: FluffyThemes.animationDuration,
    );

    _vocabOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _vocabController, curve: Curves.easeInOut),
    );

    _bubbleController = AnimationController(
      vsync: this,
      duration: FluffyThemes.animationDuration,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 0.9).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _bubbleController.forward();

      Future.delayed(counterDelay, () {
        if (mounted) {
          _vocabController.forward();
          _grammarController.forward();
        }
      });

      Future.delayed(const Duration(milliseconds: 4000), () {
        if (!mounted) return;
        _bubbleController.reverse().then((_) {
          MatrixState.pAnyState.closeOverlay(widget.overlayId);
        });
      });
    });
  }

  @override
  void dispose() {
    _vocabController.dispose();
    _grammarController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  void _showAnalyticsDialog(ConstructTypeEnum? type) {
    showDialog<AnalyticsPopupWrapper>(
      context: context,
      builder: (context) => AnalyticsPopupWrapper(
        view: type ?? ConstructTypeEnum.vocab,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.newVocabConstructs <= 0 && widget.newGrammarConstructs <= 0) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => _showAnalyticsDialog(null),
        child: ScaleTransition(
          scale: _scaleAnimation,
          alignment: Alignment.bottomRight,
          child: AnimatedBuilder(
            animation: _bubbleController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withAlpha((_opacityAnimation.value * 255).round()),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(4.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.newVocabConstructs > 0)
                      NewConstructsBadge(
                        controller: _vocabController,
                        opacityAnimation: _vocabOpacity,
                        newConstructs: widget.newVocabConstructs,
                        type: ConstructTypeEnum.vocab,
                        tooltip: L10n.of(context).newVocab,
                        onTap: () => _showAnalyticsDialog(
                          ConstructTypeEnum.vocab,
                        ),
                      ),
                    if (widget.newGrammarConstructs > 0)
                      NewConstructsBadge(
                        controller: _grammarController,
                        opacityAnimation: _grammarOpacity,
                        newConstructs: widget.newGrammarConstructs,
                        type: ConstructTypeEnum.morph,
                        tooltip: L10n.of(context).newGrammar,
                        onTap: () => _showAnalyticsDialog(
                          ConstructTypeEnum.morph,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class NewConstructsBadge extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> opacityAnimation;

  final int newConstructs;
  final ConstructTypeEnum type;
  final String tooltip;
  final VoidCallback onTap;

  const NewConstructsBadge({
    required this.controller,
    required this.opacityAnimation,
    required this.newConstructs,
    required this.type,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Opacity(
              opacity: opacityAnimation.value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type.indicator.icon,
                      color: type.indicator.color(context),
                      size: 24,
                    ),
                    const SizedBox(width: 4.0),
                    AnimatedCounter(
                      key: ValueKey("$type-counter"),
                      endValue: newConstructs,
                      startAnimation: opacityAnimation.value > 0.9,
                      style: TextStyle(
                        color: type.indicator.color(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final int endValue;
  final TextStyle? style;
  final bool startAnimation;

  const AnimatedCounter({
    super.key,
    required this.endValue,
    this.style,
    this.startAnimation = true,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: FluffyThemes.animationDuration,
    );

    _animation = IntTween(
      begin: 0,
      end: widget.endValue,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    if (widget.startAnimation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.startAnimation && widget.startAnimation && !_hasAnimated) {
      _controller.forward();
    }
  }

  bool get _hasAnimated => _controller.isCompleted || _controller.isAnimating;

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
        return Text(
          "+ ${_animation.value}",
          style: widget.style,
        );
      },
    );
  }
}
