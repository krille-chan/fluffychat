import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_button_and_progress_row.dart';

class ToolbarButton extends StatelessWidget {
  final MessageMode mode;
  final MessageOverlayController overlayController;
  final double buttonSize;

  const ToolbarButton({
    required this.mode,
    required this.overlayController,
    required this.buttonSize,
    super.key,
  });

  Color color(BuildContext context) => mode.iconButtonColor(
        context,
        overlayController.toolbarMode,
        overlayController.pangeaMessageEvent!.proportionOfActivitiesCompleted,
        overlayController.isPracticeComplete,
      );

  bool get enabled => mode.isUnlocked(
        overlayController.pangeaMessageEvent!.proportionOfActivitiesCompleted,
        overlayController.isPracticeComplete,
      );

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
            color: color(context),
            onPressed: enabled
                ? () => overlayController.updateToolbarMode(mode)
                : null,
            playSound: true,
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
