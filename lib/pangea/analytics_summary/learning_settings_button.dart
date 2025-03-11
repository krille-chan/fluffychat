import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';

/// A badge that represents one learning progress indicator (i.e., construct uses)
class LearningSettingsButton extends StatelessWidget {
  final String? l2;
  final VoidCallback onTap;

  const LearningSettingsButton({
    super.key,
    this.l2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4.0,
      children: [
        Text(
          l2 ?? "?",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Tooltip(
          message: L10n.of(context).learningSettings,
          child: PressableButton(
            buttonHeight: 2.5,
            borderRadius: BorderRadius.circular(15),
            onPressed: onTap,
            color: Theme.of(context).colorScheme.surfaceBright,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.surfaceBright,
              ),
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                size: 14,
                Icons.language_outlined,
                color: Theme.of(context).colorScheme.primary,
                weight: 1000,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
