import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';

class ResetInstructionsListTile extends StatelessWidget {
  const ResetInstructionsListTile({
    super.key,
    required this.controller,
  });

  final SettingsLearningController controller;

  @override
  Widget build(BuildContext context) {
    //TODO: add to L10n
    return ListTile(
      leading: const Icon(Icons.lightbulb),
      title: const Text(
        "Reset instruction tooltips",
      ),
      subtitle: const Text(
        "Click to show instruction tooltips like for a brand new user.",
      ),
      onTap: () => showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Reset instruction tooltips?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.resetInstructionTooltips();
                  Navigator.of(context).pop();
                },
                child: const Text("Reset"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      ),
    );
  }
}
