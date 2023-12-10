import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pangea/utils/error_handler.dart';
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

  static void joinWithClassCodeDialog(
    BuildContext outerContext,
    PangeaController pangeaController,
    String? classCode,
  ) {
    final TextEditingController textFieldController = TextEditingController(
      text: classCode,
    );

    showDialog(
      context: outerContext,
      useRootNavigator: false,
      builder: (BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          title: Text(L10n.of(context)!.joinWithClassCode),
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(
              hintText: L10n.of(context)!.joinWithClassCodeHint,
            ),
          ),
          actions: [
            TextButton(
              child: Text(L10n.of(context)!.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(L10n.of(context)!.ok),
              onPressed: () => showFutureLoadingDialog(
                context: context,
                future: () async {
                  try {
                    await pangeaController.classController.joinClasswithCode(
                      outerContext,
                      textFieldController.text,
                    );
                  } catch (err) {
                    messageSnack(
                      outerContext,
                      ErrorCopy(outerContext, err).body,
                    );
                  } finally {
                    context.go("/rooms");
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
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
