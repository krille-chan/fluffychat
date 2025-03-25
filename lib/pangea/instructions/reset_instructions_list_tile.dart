import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';

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
      title: Text(
        L10n.of(context).resetInstructionTooltipsTitle,
      ),
      subtitle: Text(
        L10n.of(context).resetInstructionTooltipsDesc,
      ),
      onTap: () async {
        final resp = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
        );
        if (resp == OkCancelResult.ok) {
          controller.resetInstructionTooltips();
        }
      },
    );
  }
}
