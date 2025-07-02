import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/dialog_text_field.dart';

Future<int?> showPermissionChooser(
  BuildContext context, {
  int currentLevel = 0,
  int maxLevel = 100,
}) async {
  final controller = TextEditingController();
  final error = ValueNotifier<String?>(null);
  return await showAdaptiveDialog<int>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(L10n.of(context).chatPermissions),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12.0,
          children: [
            Text(L10n.of(context).setPermissionsLevelDescription),
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
          bigButtons: true,
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
          child: Text(L10n.of(context).setCustomPermissionLevel),
        ),
        if (maxLevel >= 100 && currentLevel != 100)
          AdaptiveDialogAction(
            bigButtons: true,
            onPressed: () => Navigator.of(context).pop<int>(100),
            child: Text(L10n.of(context).admin),
          ),
        if (maxLevel >= 50 && currentLevel != 50)
          AdaptiveDialogAction(
            bigButtons: true,
            onPressed: () => Navigator.of(context).pop<int>(50),
            child: Text(L10n.of(context).moderator),
          ),
        if (currentLevel != 0)
          AdaptiveDialogAction(
            bigButtons: true,
            onPressed: () => Navigator.of(context).pop<int>(0),
            child: Text(L10n.of(context).normalUser),
          ),
      ],
    ),
  );
}
