import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_button.dart';

class MessageMeaningButton extends StatelessWidget {
  final MessageOverlayController overlayController;
  final double buttonSize;

  const MessageMeaningButton({
    super.key,
    required this.overlayController,
    required this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: overlayController.isPracticeComplete
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: FluffyThemes.animationDuration,
      firstChild: ToolbarButton(
        mode: MessageMode.messageMeaning,
        overlayController: overlayController,
        buttonSize: buttonSize,
      ),
      secondChild: Container(
        width: buttonSize,
        height: buttonSize,
        alignment: Alignment.center,
        child: Icon(
          MessageMode.messageMeaning.icon,
          color: AppConfig.gold,
          size: buttonSize,
        ),
      ),
    );
  }
}
