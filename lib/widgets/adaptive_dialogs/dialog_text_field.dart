// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
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
  final bool obscureText;
  final bool isDestructive = false;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool autocorrect = true;
  final bool readOnly;
  final TextStyle? textStyle;

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
    this.obscureText = false,
    this.readOnly = false,
    this.textStyle,
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
          readOnly: readOnly,
          controller: controller,
          obscureText: obscureText,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          autocorrect: autocorrect,
          style: textStyle,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceBright,
            errorText: errorText,
            hintText: hintText,
            labelText: labelText,
            prefixText: prefixText,
            suffixText: suffixText,
            counterText: counterText,
          ),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        final placeholder = labelText ?? hintText;
        return Column(
          children: [
            SizedBox(
              height: placeholder == null ? null : ((maxLines ?? 1) + 1) * 20,
              child: CupertinoTextField(
                controller: controller,
                readOnly: readOnly,
                obscureText: obscureText,
                minLines: minLines,
                maxLines: maxLines,
                maxLength: maxLength,
                keyboardType: keyboardType,
                autocorrect: autocorrect,
                style: textStyle,
                prefix: prefixText != null ? Text(prefixText) : null,
                suffix: suffixText != null ? Text(suffixText) : null,
                placeholder: placeholder,
              ),
            ),
            if (errorText != null)
              Text(
                errorText,
                style: TextStyle(fontSize: 11, color: theme.colorScheme.error),
                textAlign: TextAlign.left,
              ),
          ],
        );
    }
  }
}
