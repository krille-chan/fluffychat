import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../controllers/pangea_controller.dart';

class ClassCodeUtil {
  static const codeLength = 6;

  static bool isValidCode(String? classcode) {
    return classcode == null || classcode.length > 4;
  }

  static String generateClassCode() {
    final r = Random();
    const chars = 'AaBbCcDdEeFfGgHhiJjKkLMmNnoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(codeLength, (index) => chars[r.nextInt(chars.length)])
        .join();
  }

  static Future<void> joinWithClassCodeDialog(
    BuildContext context,
    PangeaController pangeaController,
  ) async {
    final List<String>? classCode = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.joinWithClassCode,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(hintText: L10n.of(context)!.joinWithClassCodeHint),
      ],
    );
    if (classCode == null || classCode.single.isEmpty) return;

    try {
      await pangeaController.classController.joinClasswithCode(
        context,
        classCode.first,
      );
    } catch (err) {
      messageSnack(
        context,
        ErrorCopy(context, err).body,
      );
    }
  }

  static messageDialog(
    BuildContext context,
    String title,
    void Function()? action,
  ) =>
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) => AlertDialog(
          content: Text(title),
          actions: [
            TextButton(
              onPressed: action,
              child: Text(L10n.of(context)!.ok),
            ),
          ],
        ),
      );

  static void messageSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Text(message),
      ),
    );
  }
}
