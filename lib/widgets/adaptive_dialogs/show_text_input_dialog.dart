import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';

Future<String?> showTextInputDialog({
  required BuildContext context,
  required String title,
  String? message,
  String? okLabel,
  String? cancelLabel,
  bool useRootNavigator = true,
  String? hintText,
  String? labelText,
  String? initialText,
  String? prefixText,
  String? suffixText,
  bool obscureText = false,
  bool isDestructive = false,
  int? minLines,
  int? maxLines,
  String? Function(String input)? validator,
  TextInputType? keyboardType,
  int? maxLength,
  bool autocorrect = true,
}) =>
    showAdaptiveDialog<String>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (context) {
        final controller = TextEditingController(text: initialText);
        final error = ValueNotifier<String?>(null);
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512),
          child: AlertDialog.adaptive(
            title: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 256),
              child: Text(title),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 256),
                      child: Text(message),
                    ),
                  ),
                ValueListenableBuilder<String?>(
                  valueListenable: error,
                  builder: (context, error, _) {
                    return TextField(
                      controller: controller,
                      obscureText: obscureText,
                      minLines: minLines,
                      maxLines: maxLines,
                      maxLength: maxLength,
                      keyboardType: keyboardType,
                      autocorrect: autocorrect,
                      decoration: InputDecoration(
                        errorText: error,
                        hintText: hintText,
                        labelText: labelText,
                        prefixText: prefixText,
                        suffixText: suffixText,
                      ),
                    );
                  },
                ),
              ],
            ),
            actions: [
              AdaptiveDialogAction(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(cancelLabel ?? L10n.of(context).cancel),
              ),
              AdaptiveDialogAction(
                onPressed: () {
                  final input = controller.text;
                  final errorText = validator?.call(input);
                  if (errorText != null) {
                    error.value = errorText;
                    return;
                  }
                  Navigator.of(context).pop<String>(input);
                },
                autofocus: true,
                child: Text(
                  okLabel ?? L10n.of(context).ok,
                  style: isDestructive
                      ? TextStyle(color: Theme.of(context).colorScheme.error)
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
