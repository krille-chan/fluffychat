import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

Future<int?> showPermissionChooser(
  BuildContext context, {
  int currentLevel = 0,
}) async {
  final customLevel = await showTextInputDialog(
    context: context,
    title: L10n.of(context)!.setPermissionsLevel,
    textFields: [
      DialogTextField(
        initialText: currentLevel.toString(),
        keyboardType: TextInputType.number,
        autocorrect: false,
        validator: (text) {
          if (text == null) {
            return L10n.of(context)!.pleaseEnterANumber;
          }
          final level = int.tryParse(text);
          if (level == null) {
            return L10n.of(context)!.pleaseEnterANumber;
          }
          return null;
        },
      ),
    ],
  );
  if (customLevel == null) return null;
  return int.tryParse(customLevel.first);
}
