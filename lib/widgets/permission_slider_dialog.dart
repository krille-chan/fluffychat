import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';

Future<int?> showPermissionChooser(
  BuildContext context, {
  int currentLevel = 0,
}) async {
  final customLevel = await showTextInputDialog(
    context: context,
    title: L10n.of(context).setPermissionsLevel,
    initialText: currentLevel.toString(),
    keyboardType: TextInputType.number,
    autocorrect: false,
    validator: (text) {
      if (text.isEmpty) {
        return L10n.of(context).pleaseEnterANumber;
      }
      final level = int.tryParse(text);
      if (level == null) {
        return L10n.of(context).pleaseEnterANumber;
      }
      return null;
    },
  );
  if (customLevel == null) return null;
  return int.tryParse(customLevel);
}
