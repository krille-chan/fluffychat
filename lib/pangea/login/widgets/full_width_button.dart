import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';

class FullWidthButton extends StatefulWidget {
  final String title;
  final Widget? icon;

  final void Function()? onPressed;
  final bool depressed;
  final String? error;
  final bool loading;
  final bool enabled;

  const FullWidthButton({
    required this.title,
    required this.onPressed,
    this.icon,
    this.depressed = false,
    this.error,
    this.loading = false,
    this.enabled = true,
    super.key,
  });

  @override
  FullWidthButtonState createState() => FullWidthButtonState();
}

class FullWidthButtonState extends State<FullWidthButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 4, widget.error == null ? 4 : 0),
          child: AnimatedOpacity(
            duration: FluffyThemes.animationDuration,
            opacity: widget.enabled ? 1 : 0.5,
            child: PressableButton(
              depressed: widget.depressed || !widget.enabled,
              onPressed: widget.onPressed,
              borderRadius: BorderRadius.circular(36),
              color: Theme.of(context).colorScheme.primary,
              child: Container(
                // internal padding
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                decoration: BoxDecoration(
                  color: widget.enabled
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.loading
                        ? const Expanded(
                            child: SizedBox(
                              height: 18,
                              child: Center(child: LinearProgressIndicator()),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.icon != null) widget.icon!,
                              if (widget.icon != null)
                                const SizedBox(width: 10),
                              Text(
                                widget.title,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: FluffyThemes.animationDuration,
          child: widget.error == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 5,
                  ),
                  child: Text(
                    widget.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class FullWidthTextField extends StatelessWidget {
  final String hintText;
  final bool autocorrect;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  final String? labelText;
  final List<String>? autofillHints;
  final bool autoFocus;
  final Widget? suffix;

  const FullWidthTextField({
    required this.hintText,
    this.autocorrect = false,
    this.obscureText = false,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.controller,
    this.onSubmitted,
    this.labelText,
    this.autofillHints,
    this.autoFocus = false,
    this.suffix,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        obscureText: obscureText,
        autocorrect: autocorrect,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        autofocus: autoFocus,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 8.0,
          ),
          isDense: true,
          suffixIcon: suffix,
        ),
        validator: validator,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: controller,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}
