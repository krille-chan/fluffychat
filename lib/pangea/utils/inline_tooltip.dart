import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/enum/instructions_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class InlineTooltip extends StatefulWidget {
  final InstructionsEnum instructionsEnum;

  const InlineTooltip({
    super.key,
    required this.instructionsEnum,
  });

  @override
  InlineTooltipState createState() => InlineTooltipState();
}

class InlineTooltipState extends State<InlineTooltip>
    with SingleTickerProviderStateMixin {
  bool _isToggledOff = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _isToggledOff = widget.instructionsEnum.toggledOff();

    // Initialize AnimationController and Animation
    _controller = AnimationController(
      duration: FluffyThemes.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start in correct state
    if (!_isToggledOff) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeTooltip() {
    MatrixState.pangeaController.instructions.setToggledOff(
      widget.instructionsEnum,
      true,
    );
    setState(() {
      _isToggledOff = true;
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axisAlignment: -1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            color: Theme.of(context).colorScheme.primary.withAlpha(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lightbulb,
                  size: _isToggledOff ? 0 : 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Center(
                    child: Text(
                      widget.instructionsEnum.body(L10n.of(context)),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                IconButton(
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.close_outlined,
                    size: _isToggledOff ? 0 : 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: _closeTooltip,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
