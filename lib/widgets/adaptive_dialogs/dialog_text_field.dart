// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? initialText;
  final String? counterText;
  final String? prefixText;
  final String? suffixText;
  final String? errorText;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool readOnly;
  final TextStyle? textStyle;
  final VoidCallback? onDispose;

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
    this.onDispose,
  });

  @override
  State<DialogTextField> createState() => _DialogTextFieldState();
}

class _DialogTextFieldState extends State<DialogTextField> {
  final bool isDestructive = false;

  final bool autocorrect = true;

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onDispose?.call(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefixText = widget.prefixText;
    final suffixText = widget.suffixText;
    final errorText = widget.errorText;
    final theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextField(
          readOnly: widget.readOnly,
          controller: widget.controller,
          obscureText: widget.obscureText,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          autocorrect: autocorrect,
          style: widget.textStyle,
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
            hintText: widget.hintText,
            labelText: widget.labelText,
            prefixText: prefixText,
            suffixText: suffixText,
            counterText: widget.counterText,
          ),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        final placeholder = widget.labelText ?? widget.hintText;
        return Column(
          children: [
            SizedBox(
              height: placeholder == null
                  ? null
                  : ((widget.maxLines ?? 1) + 1) * 20,
              child: CupertinoTextField(
                controller: widget.controller,
                readOnly: widget.readOnly,
                obscureText: widget.obscureText,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                keyboardType: widget.keyboardType,
                autocorrect: autocorrect,
                style: widget.textStyle,
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
