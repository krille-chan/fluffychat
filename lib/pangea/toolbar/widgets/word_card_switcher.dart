import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_positioner.dart';
import 'package:fluffychat/pangea/toolbar/widgets/reading_assistance_content.dart';
import 'package:fluffychat/pangea/toolbar/widgets/select_mode_buttons.dart';

class WordCardSwitcher extends StatelessWidget {
  final MessageSelectionPositionerState controller;
  const WordCardSwitcher({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment:
          controller.ownMessage ? Alignment.bottomRight : Alignment.bottomLeft,
      duration: FluffyThemes.animationDuration,
      child:
          controller.widget.overlayController.selectedMode == SelectMode.emoji
              ? const SizedBox()
              : controller.widget.overlayController.selectedToken != null
                  ? ReadingAssistanceContent(
                      overlayController: controller.widget.overlayController,
                    )
                  : MessageReactionPicker(
                      chatController: controller.widget.chatController,
                    ),
    );
  }
}
