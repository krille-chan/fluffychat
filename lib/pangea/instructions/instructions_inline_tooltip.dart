import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';

class InstructionsInlineTooltip extends StatefulWidget {
  final InstructionsEnum instructionsEnum;
  final bool bold;
  final bool animate;
  final double padding;

  const InstructionsInlineTooltip({
    super.key,
    required this.instructionsEnum,
    this.bold = false,
    this.animate = true,
    this.padding = 0.0,
  });

  @override
  InstructionsInlineTooltipState createState() =>
      InstructionsInlineTooltipState();
}

class InstructionsInlineTooltipState extends State<InstructionsInlineTooltip>
    with TickerProviderStateMixin {
  bool _isToggledOff = true;
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void didUpdateWidget(covariant InstructionsInlineTooltip oldWidget) {
    if (oldWidget.instructionsEnum != widget.instructionsEnum) {
      setToggled();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    setToggled();
  }

  void setToggled() {
    _isToggledOff = widget.instructionsEnum.isToggledOff;

    if (widget.animate) {
      // Initialize AnimationController and Animation only if animate is true
      _controller = AnimationController(
        duration: FluffyThemes.animationDuration,
        vsync: this,
      );

      _animation = CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOut,
      );

      // Start in correct state
      if (!_isToggledOff) _controller!.forward();
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _closeTooltip() {
    widget.instructionsEnum.setToggledOff(true);
    setState(() {
      _isToggledOff = true;
      if (widget.animate) {
        _controller?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.animate
        ? SizeTransition(
            sizeFactor: _animation!,
            axisAlignment: -1.0,
            child: _buildTooltipContent(context),
          )
        : (_isToggledOff
            ? const SizedBox.shrink()
            : _buildTooltipContent(context));
  }

  Widget _buildTooltipContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          color: Color.alphaBlend(
            Theme.of(context).colorScheme.surface.withAlpha(70),
            AppConfig.gold,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lightbulb,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Center(
                  child: Text(
                    widget.instructionsEnum.body(L10n.of(context)),
                    style: FluffyThemes.isColumnMode(context)
                        ? Theme.of(context).textTheme.titleLarge
                        : Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.close_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: _closeTooltip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
