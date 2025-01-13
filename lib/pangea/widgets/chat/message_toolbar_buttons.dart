import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/pressable_button.dart';

class ToolbarButtons extends StatelessWidget {
  final Event event;
  final MessageOverlayController overlayController;

  const ToolbarButtons({
    required this.event,
    required this.overlayController,
    super.key,
  });

  double? get proportionOfActivitiesCompleted =>
      overlayController.pangeaMessageEvent?.proportionOfActivitiesCompleted;

  List<MessageMode> get modes => MessageMode.values
      .where((mode) => mode.shouldShowAsToolbarButton(event))
      .toList();

  static const double iconWidth = 36.0;
  static const double buttonSize = 40.0;
  static const double width = 250.0;

  @override
  Widget build(BuildContext context) {
    if (!overlayController.showToolbarButtons) {
      return const SizedBox();
    }

    return SizedBox(
      width: width,
      height: AppConfig.toolbarButtonsHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: width,
                height: 12,
                decoration: BoxDecoration(
                  color: MessageModeExtension.barAndLockedButtonColor(context),
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                ),
                margin: const EdgeInsets.symmetric(horizontal: iconWidth / 2),
              ),
              AnimatedContainer(
                duration: FluffyThemes.animationDuration,
                height: 12,
                width: overlayController.isPracticeComplete
                    ? width
                    : min(width, width * proportionOfActivitiesCompleted!),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  color: AppConfig.success,
                ),
                margin: const EdgeInsets.symmetric(horizontal: iconWidth / 2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: modes.mapIndexed((index, mode) {
              final enabled = mode.isUnlocked(
                proportionOfActivitiesCompleted!,
                overlayController.isPracticeComplete,
              );
              final color = mode.iconButtonColor(
                context,
                overlayController.toolbarMode,
                proportionOfActivitiesCompleted!,
                overlayController.isPracticeComplete,
              );
              return mode.showButton
                  ? ToolbarButton(
                      mode: mode,
                      overlayController: overlayController,
                      enabled: enabled,
                      buttonSize: buttonSize,
                      color: color,
                    )
                  : const SizedBox(width: buttonSize);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class DisabledAnimation extends StatefulWidget {
  final double size;

  const DisabledAnimation({
    this.size = 40.0,
    super.key,
  });

  @override
  DisabledAnimationState createState() => DisabledAnimationState();
}

class DisabledAnimationState extends State<DisabledAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 0.9),
        weight: 1.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.9, end: 0.9),
        weight: 1.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.9, end: 0),
        weight: 1.0,
      ),
    ]).animate(_controller);
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
      builder: (context, _) {
        return GestureDetector(
          onTap: () {
            _controller.forward().then((_) => _controller.reset());
            if (!kIsWeb) {
              HapticFeedback.mediumImpact();
            }
          },
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Opacity(
              opacity: _animation.value,
              child: const Icon(
                Icons.lock,
                color: AppConfig.primaryColor,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ToolbarButton extends StatelessWidget {
  final MessageMode mode;
  final MessageOverlayController overlayController;
  final bool enabled;
  final double buttonSize;
  final Color color;

  const ToolbarButton({
    required this.mode,
    required this.overlayController,
    required this.enabled,
    required this.buttonSize,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: mode.tooltip(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PressableButton(
            borderRadius: BorderRadius.circular(20),
            depressed: !enabled || mode == overlayController.toolbarMode,
            color: color,
            onPressed: enabled
                ? () => overlayController.updateToolbarMode(mode)
                : null,
            playSound: true,
            child: AnimatedContainer(
              duration: FluffyThemes.animationDuration,
              height: buttonSize,
              width: buttonSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                mode.icon,
                size: 20,
                color:
                    mode == overlayController.toolbarMode ? Colors.white : null,
              ),
            ),
          ),
          if (!enabled) const DisabledAnimation(),
        ],
      ),
    );
  }
}
