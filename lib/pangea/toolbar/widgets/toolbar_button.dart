import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class ToolbarButton extends StatelessWidget {
  final MessageMode mode;
  final MessageOverlayController overlayController;
  final void Function(MessageMode) onPressed;
  final double buttonSize;

  const ToolbarButton({
    required this.mode,
    required this.overlayController,
    required this.buttonSize,
    required this.onPressed,
    super.key,
  });

  Color color(BuildContext context) => mode.iconButtonColor(
        context,
        overlayController,
      );

  bool get enabled => mode == MessageMode.messageTranslation
      ? overlayController.isTranslationUnlocked
      : true;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: mode.tooltip(context),
      child: PressableButton(
        borderRadius: BorderRadius.circular(20),
        depressed: mode == overlayController.toolbarMode,
        color: color(context),
        onPressed: () => onPressed(mode),
        playSound: true,
        colorFactor:
            Theme.of(context).brightness == Brightness.light ? 0.55 : 0.3,
        child: AnimatedContainer(
          duration: FluffyThemes.animationDuration,
          height: buttonSize,
          width: buttonSize,
          decoration: BoxDecoration(
            color: color(context),
            shape: BoxShape.circle,
          ),
          child: Icon(
            mode.icon,
            size: 20,
            color: mode == overlayController.toolbarMode ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
