import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/enum/instructions_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class InlineTooltip extends StatelessWidget {
  final InstructionsEnum instructionsEnum;
  final VoidCallback onClose;

  const InlineTooltip({
    super.key,
    required this.instructionsEnum,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (instructionsEnum.toggledOff(context)) {
      return const SizedBox();
    }

    return Padding(
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
            children: [
              // Lightbulb icon on the left
              Icon(
                Icons.lightbulb,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              // Text in the middle
              Expanded(
                child: Center(
                  child: Text(
                    instructionsEnum.body(context),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              // Close button on the right
              IconButton(
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.close_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  MatrixState.pangeaController.instructions.setToggledOff(
                    instructionsEnum,
                    true,
                  );
                  onClose();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
