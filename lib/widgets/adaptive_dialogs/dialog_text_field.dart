import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? initialText;
  final String? counterText;
  final String? prefixText;
  final String? suffixText;
  final String? errorText;
  final bool obscureText = false;
  final bool isDestructive = false;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool autocorrect = true;
  // #Pangea
  final void Function(String)? onSubmitted;
  // Pangea#

  const DialogTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.initialText,
    this.prefixText,
    this.suffixText,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.maxLength,
    this.controller,
    this.counterText,
    this.errorText,
    // #Pangea
    this.onSubmitted,
    // Pangea#
  });

  @override
  Widget build(BuildContext context) {
    final prefixText = this.prefixText;
    final suffixText = this.suffixText;
    final errorText = this.errorText;
    final theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextField(
          controller: controller,
          obscureText: obscureText,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          autocorrect: autocorrect,
          decoration: InputDecoration(
            errorText: errorText,
            hintText: hintText,
            labelText: labelText,
            prefixText: prefixText,
            suffixText: suffixText,
            counterText: counterText,
          ),
          // #Pangea
          onSubmitted: onSubmitted,
          // Pangea#
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoTextField(
              controller: controller,
              obscureText: obscureText,
              minLines: minLines,
              maxLines: maxLines,
              maxLength: maxLength,
              keyboardType: keyboardType,
              autocorrect: autocorrect,
              prefix: prefixText != null ? Text(prefixText) : null,
              suffix: suffixText != null ? Text(suffixText) : null,
              placeholder: labelText ?? hintText,
              // #Pangea
              onSubmitted: onSubmitted,
              // Pangea#
            ),
            if (errorText != null)
              Text(
                errorText,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.left,
              ),
          ],
        );
    }
  }
}
