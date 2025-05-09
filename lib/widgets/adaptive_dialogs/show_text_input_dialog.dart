import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/dialog_text_field.dart';

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
}) {
  return showAdaptiveDialog<String>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (context) => TextInputDialog(
      title: title,
      message: message,
      okLabel: okLabel,
      cancelLabel: cancelLabel,
      hintText: hintText,
      labelText: labelText,
      initialText: initialText,
      prefixText: prefixText,
      suffixText: suffixText,
      obscureText: obscureText,
      isDestructive: isDestructive,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      keyboardType: keyboardType,
      maxLength: maxLength,
      autocorrect: autocorrect,
    ),
  );
}

class TextInputDialog extends StatefulWidget {
  final String title;
  final String? message;
  final String? okLabel;
  final String? cancelLabel;
  final bool useRootNavigator;
  final String? hintText;
  final String? labelText;
  final String? initialText;
  final String? prefixText;
  final String? suffixText;
  final bool obscureText;
  final bool isDestructive;
  final int? minLines;
  final int? maxLines;
  final String? Function(String input)? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool autocorrect;

  const TextInputDialog({
    super.key,
    required this.title,
    this.message,
    this.okLabel,
    this.cancelLabel,
    this.useRootNavigator = true,
    this.hintText,
    this.labelText,
    this.initialText,
    this.prefixText,
    this.suffixText,
    this.obscureText = false,
    this.isDestructive = false,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.keyboardType,
    this.validator,
    this.autocorrect = true,
  });

  @override
  State<TextInputDialog> createState() => TextInputDialogState();
}

class TextInputDialogState extends State<TextInputDialog> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String? error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _onSubmitted() {
    final input = controller.text;
    final errorText = widget.validator?.call(input);
    if (errorText != null) {
      setState(() => error = errorText);
      return;
    }
    Navigator.of(context).pop<String>(input);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 512),
      child: AlertDialog.adaptive(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: Text(widget.title),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.message != null)
                SelectableLinkify(
                  text: widget.message!,
                  textScaleFactor: MediaQuery.textScalerOf(context).scale(1),
                  linkStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decorationColor: Theme.of(context).colorScheme.primary,
                  ),
                  options: const LinkifyOptions(humanize: false),
                  onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
                ),
              const SizedBox(height: 16),
              DialogTextField(
                hintText: widget.hintText,
                errorText: error,
                labelText: widget.labelText,
                controller: controller,
                initialText: widget.initialText,
                prefixText: widget.prefixText,
                suffixText: widget.suffixText,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                keyboardType: widget.keyboardType,
                focusNode: focusNode,
                onSubmitted: (_) => _onSubmitted,
              ),
            ],
          ),
        ),
        actions: [
          AdaptiveDialogAction(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(widget.cancelLabel ?? L10n.of(context).cancel),
          ),
          AdaptiveDialogAction(
            onPressed: _onSubmitted,
            autofocus: true,
            child: Text(
              widget.okLabel ?? L10n.of(context).ok,
              style: widget.isDestructive
                  ? TextStyle(color: Theme.of(context).colorScheme.error)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
