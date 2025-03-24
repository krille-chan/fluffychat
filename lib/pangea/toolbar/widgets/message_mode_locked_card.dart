import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:flutter/material.dart';

class MessageModeLockedCard extends StatelessWidget {
  final MessageOverlayController controller;

  const MessageModeLockedCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(
          Icons.lock_outline,
          size: 40,
          color: Theme.of(context).colorScheme.primary,
        ),
        if (!InstructionsEnum.completeActivitiesToUnlock.isToggledOff) ...[
          const SizedBox(height: 8),
          const InstructionsInlineTooltip(
            instructionsEnum: InstructionsEnum.completeActivitiesToUnlock,
            bold: true,
          ),
        ],
      ],
    );
  }
}
