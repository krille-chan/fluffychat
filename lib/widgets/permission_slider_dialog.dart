import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/dialog_text_field.dart';

Future<int?> showPermissionChooser(
  BuildContext context, {
  int currentLevel = 0,
  int maxLevel = 100,
}) async {
  final controller = TextEditingController(text: currentLevel.toString());
  final error = ValueNotifier<String?>(null);
  return await showAdaptiveDialog<int>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Center(child: Text(L10n.of(context).chatPermissions)),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          spacing: 12.0,
          children: [
            Text(L10n.of(context).setPowerLevelDescription),
            ValueListenableBuilder(
              valueListenable: error,
              builder: (context, errorText, _) => DialogTextField(
                controller: controller,
                hintText: currentLevel.toString(),
                keyboardType: TextInputType.number,
                labelText: L10n.of(context).custom,
                errorText: errorText,
              ),
            ),
          ],
        ),
      ),
      actions: [
        AdaptiveDialogAction(
          onPressed: () {
            final level = int.tryParse(controller.text.trim());
            if (level == null) {
              error.value = L10n.of(context).pleaseEnterANumber;
              return;
            }
            if (level > maxLevel) {
              error.value = L10n.of(context).noPermission;
              return;
            }
            Navigator.of(context).pop<int>(level);
          },
          child: Text(L10n.of(context).setPowerLevel),
        ),
        AdaptiveDialogAction(
          onPressed: () => Navigator.of(context).pop<int>(null),
          child: Text(L10n.of(context).cancel),
        ),
      ],
    ),
  );
}
