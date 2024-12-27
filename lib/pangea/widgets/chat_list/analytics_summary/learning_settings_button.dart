import 'package:fluffychat/pangea/widgets/pressable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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
    return Tooltip(
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
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                size: 14,
                Icons.language,
                color: Theme.of(context).colorScheme.primary,
                weight: 1000,
              ),
              const SizedBox(width: 5),
              Text(
                l2 ?? "?",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
