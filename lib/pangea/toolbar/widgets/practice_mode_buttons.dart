import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_button.dart';

class PracticeModeButtons extends StatelessWidget {
  final MessageOverlayController overlayController;

  const PracticeModeButtons({
    required this.overlayController,
    super.key,
  });

  static const double iconWidth = 36.0;
  static const double buttonSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 4.0,
          children: [
            Container(
              width: buttonSize + 4,
              height: buttonSize + 4,
              alignment: Alignment.center,
              child: ToolbarButton(
                mode: MessageMode.listening,
                overlayController: overlayController,
                buttonSize: buttonSize,
              ),
            ),
            Container(
              width: buttonSize + 4,
              height: buttonSize + 4,
              alignment: Alignment.center,
              child: ToolbarButton(
                mode: MessageMode.wordMorph,
                overlayController: overlayController,
                buttonSize: buttonSize,
              ),
            ),
            Container(
              width: buttonSize + 4,
              height: buttonSize + 4,
              alignment: Alignment.center,
              child: ToolbarButton(
                mode: MessageMode.wordMeaning,
                overlayController: overlayController,
                buttonSize: buttonSize,
              ),
            ),
            Container(
              width: buttonSize + 4,
              height: buttonSize + 4,
              alignment: Alignment.center,
              child: ToolbarButton(
                mode: MessageMode.wordEmoji,
                overlayController: overlayController,
                buttonSize: buttonSize,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
      ],
    );
  }
}
