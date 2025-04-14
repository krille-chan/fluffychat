import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/choreographer/widgets/it_feedback_stars.dart';
import '../../bot/utils/bot_style.dart';
import '../../common/utils/error_handler.dart';
import '../controllers/it_controller.dart';

class TranslationFeedback extends StatefulWidget {
  final int vocabCount;
  final int grammarCount;
  final String feedbackText;
  final ITController controller;

  const TranslationFeedback({
    super.key,
    required this.controller,
    required this.vocabCount,
    required this.grammarCount,
    required this.feedbackText,
  });

  @override
  State<TranslationFeedback> createState() => _TranslationFeedbackState();
}

class _TranslationFeedbackState extends State<TranslationFeedback>
    with TickerProviderStateMixin {
  late final int starRating;
  late final int vocabCount;
  late final int grammarCount;

  // Animation controllers for each component
  late AnimationController _starsController;
  late AnimationController _vocabController;
  late AnimationController _grammarController;

  // Animations for opacity and scale
  late Animation<double> _starsOpacity;
  late Animation<double> _starsScale;
  late Animation<double> _vocabOpacity;
  late Animation<double> _grammarOpacity;

  // Constants for animation timing
  static const vocabDelay = Duration(milliseconds: 800);
  static const grammarDelay = Duration(milliseconds: 1400);

  // Duration for each individual animation
  static const elementAnimDuration = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    vocabCount = widget.vocabCount;
    grammarCount = widget.grammarCount;

    final altTranslator = widget.controller.choreographer.altTranslator;
    starRating = altTranslator.starRating;

    // Initialize animation controllers
    _starsController = AnimationController(
      vsync: this,
      duration: elementAnimDuration,
    );

    _vocabController = AnimationController(
      vsync: this,
      duration: elementAnimDuration,
    );

    _grammarController = AnimationController(
      vsync: this,
      duration: elementAnimDuration,
    );

    // Define animations
    _starsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _starsController, curve: Curves.easeInOut),
    );

    _starsScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _starsController, curve: Curves.elasticOut),
    );

    _vocabOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _vocabController, curve: Curves.easeInOut),
    );

    _grammarOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _grammarController, curve: Curves.easeInOut),
    );

    // Start animations with appropriate delays
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Start stars animation immediately
        _starsController.forward();

        // Start vocab animation after delay if there's vocab to show
        if (vocabCount > 0) {
          Future.delayed(vocabDelay, () {
            if (mounted) _vocabController.forward();
          });
        }

        // Start grammar animation after delay if there's grammar to show
        if (grammarCount > 0) {
          Future.delayed(grammarDelay, () {
            if (mounted) _grammarController.forward();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _starsController.dispose();
    _vocabController.dispose();
    _grammarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated stars
          AnimatedBuilder(
            animation: _starsController,
            builder: (context, child) {
              return Opacity(
                opacity: _starsOpacity.value,
                child: Transform.scale(
                  scale: _starsScale.value,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FillingStars(rating: starRating),
                  ),
                ),
              );
            },
          ),

          if (vocabCount > 0 || grammarCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (vocabCount > 0)
                    AnimatedBuilder(
                      animation: _vocabController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _vocabOpacity.value,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Symbols.dictionary,
                                  color: ProgressIndicatorEnum.wordsUsed
                                      .color(context),
                                  size: 24,
                                ),
                                const SizedBox(width: 4.0),
                                AnimatedCounter(
                                  key: const ValueKey("vocabCounter"),
                                  endValue: vocabCount,
                                  // Only start counter animation when opacity animation is complete
                                  startAnimation: _vocabOpacity.value > 0.9,
                                  style: TextStyle(
                                    color: ProgressIndicatorEnum.wordsUsed
                                        .color(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  if (grammarCount > 0)
                    AnimatedBuilder(
                      animation: _grammarController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _grammarOpacity.value,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Symbols.toys_and_games,
                                  color: ProgressIndicatorEnum.morphsUsed
                                      .color(context),
                                  size: 24,
                                ),
                                const SizedBox(width: 4.0),
                                AnimatedCounter(
                                  key: const ValueKey("grammarCounter"),
                                  endValue: grammarCount,
                                  // Only start counter animation when opacity animation is complete
                                  startAnimation: _grammarOpacity.value > 0.9,
                                  style: TextStyle(
                                    color: ProgressIndicatorEnum.morphsUsed
                                        .color(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            )
          else
            AnimatedBuilder(
              animation: _starsController,
              builder: (context, child) {
                return Opacity(
                  opacity: _starsOpacity.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.feedbackText,
                      textAlign: TextAlign.center,
                      style: BotStyle.text(context),
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 8.0),
        ],
      );
    } catch (err, stack) {
      debugPrint("Error in TranslationFeedback: $err");
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {},
      );
      // Fallback to a simple message if anything goes wrong
      return Center(child: Text(L10n.of(context).niceJob));
    }
  }
}

class AnimatedCounter extends StatefulWidget {
  final int endValue;
  final TextStyle? style;
  final Duration duration;
  final String prefix;
  final bool startAnimation;

  const AnimatedCounter({
    super.key,
    required this.endValue,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
    this.prefix = "+ ",
    this.startAnimation = true,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
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

    // Only start animation if startAnimation is true
    if (widget.startAnimation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.forward();
          _hasAnimated = true;
        }
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Start animation when startAnimation changes to true
    if (!oldWidget.startAnimation && widget.startAnimation && !_hasAnimated) {
      _controller.forward();
      _hasAnimated = true;
    }

    if (oldWidget.endValue != widget.endValue) {
      if (_hasAnimated) {
        _animation = IntTween(
          begin: _animation.value,
          end: widget.endValue,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
          ),
        );

        _controller.forward(from: 0.0);
      } else if (widget.startAnimation) {
        _animation = IntTween(
          begin: 0,
          end: widget.endValue,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
          ),
        );

        _controller.forward();
        _hasAnimated = true;
      }
    }
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
        return Text(
          "${widget.prefix}${_animation.value}",
          style: widget.style,
        );
      },
    );
  }
}
