import 'package:flutter/cupertino.dart';
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
  // #Pangea
  bool autoSubmit = false,
  // Pangea#
}) {
  final theme = Theme.of(context);
  return showAdaptiveDialog<String>(
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
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 256),
                  child: Text(message),
                ),
              const SizedBox(height: 16),
              ValueListenableBuilder<String?>(
                valueListenable: error,
                builder: (context, error, _) {
                  switch (theme.platform) {
                    case TargetPlatform.android:
                    case TargetPlatform.fuchsia:
                    case TargetPlatform.linux:
                    case TargetPlatform.windows:
                      return TextField(
                        controller: controller,
                        obscureText: obscureText,
                        // #Pangea
                        // minLines: minLines,
                        // maxLines: maxLines,
                        minLines: autoSubmit ? 1 : minLines,
                        maxLines: autoSubmit ? 1 : maxLines,
                        onSubmitted: autoSubmit
                            ? (_) {
                                final input = controller.text;
                                final errorText = validator?.call(input);
                                if (errorText != null) {
                                  error = errorText;
                                  return;
                                }
                                Navigator.of(context).pop<String>(input);
                              }
                            : null,
                        // Pangea#
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
                    case TargetPlatform.iOS:
                    case TargetPlatform.macOS:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoTextField(
                            controller: controller,
                            obscureText: obscureText,
                            // #Pangea
                            // minLines: minLines,
                            // maxLines: maxLines,
                            minLines: autoSubmit ? 1 : minLines,
                            maxLines: autoSubmit ? 1 : maxLines,
                            onSubmitted: autoSubmit
                                ? (_) {
                                    final input = controller.text;
                                    final errorText = validator?.call(input);
                                    if (errorText != null) {
                                      error = errorText;
                                      return;
                                    }
                                    Navigator.of(context).pop<String>(input);
                                  }
                                : null,
                            // Pangea#
                            maxLength: maxLength,
                            keyboardType: keyboardType,
                            autocorrect: autocorrect,
                            prefix:
                                prefixText != null ? Text(prefixText) : null,
                            suffix:
                                suffixText != null ? Text(suffixText) : null,
                            placeholder: labelText ?? hintText,
                          ),
                          if (error != null)
                            Text(
                              error!,
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.error,
                              ),
                              textAlign: TextAlign.left,
                            ),
                        ],
                      );
                  }
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
}
