import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/onboarding/onboarding_steps_enum.dart';

class OnboardingStep extends StatelessWidget {
  final OnboardingStepsEnum step;

  final bool isComplete;
  final VoidCallback onPressed;

  const OnboardingStep({
    super.key,
    required this.step,
    this.isComplete = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isColumnMode ? 20.0 : 8.0,
        vertical: isColumnMode ? 24.0 : 8.0,
      ),
      margin: isColumnMode
          ? const EdgeInsets.only(
              bottom: 10.0,
            )
          : const EdgeInsets.all(0.0),
      decoration: isColumnMode && isComplete
          ? ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: AppConfig.success,
                ),
                borderRadius: BorderRadius.circular(
                  24,
                ),
              ),
            )
          : null,
      child: Row(
        spacing: isColumnMode ? 24.0 : 12.0,
        children: [
          Icon(
            Icons.task_alt,
            size: isColumnMode ? 30.0 : 18.0,
            color: isComplete
                ? AppConfig.success
                : Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: isColumnMode ? 16.0 : 8.0,
              children: [
                Text(
                  isComplete
                      ? step.completeMessage(
                          L10n.of(context),
                        )
                      : step.description(
                          L10n.of(context),
                        ),
                  style: TextStyle(
                    fontSize: isColumnMode ? 20.0 : 12.0,
                  ),
                ),
                if (!isComplete)
                  ElevatedButton(
                    onPressed: onPressed,
                    child: Row(
                      spacing: 8.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        step.icon(18.0),
                        Text(
                          step.buttonText(
                            L10n.of(
                              context,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
