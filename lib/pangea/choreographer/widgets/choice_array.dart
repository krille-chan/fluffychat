import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../utils/bot_style.dart';
import 'it_shimmer.dart';

class ChoicesArray extends StatelessWidget {
  final bool isLoading;
  final List<Choice>? choices;
  final void Function(int) onPressed;
  final void Function(int)? onLongPress;
  final int? selectedChoiceIndex;
  final String originalSpan;
  final String Function(int) uniqueKeyForLayerLink;
  const ChoicesArray({
    Key? key,
    required this.isLoading,
    required this.choices,
    required this.onPressed,
    required this.originalSpan,
    required this.uniqueKeyForLayerLink,
    required this.selectedChoiceIndex,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return isLoading && (choices == null || choices!.length <= 1)
        ? ItShimmer(originalSpan: originalSpan)
        : Wrap(
            alignment: WrapAlignment.center,
            children: choices
                    ?.asMap()
                    .entries
                    .map(
                      (entry) => ChoiceItem(
                        theme: theme,
                        onLongPress: onLongPress,
                        onPressed: onPressed,
                        entry: entry,
                        isSelected: selectedChoiceIndex == entry.key,
                      ),
                    )
                    .toList() ??
                [],
          );
  }
}

class Choice {
  Choice({
    this.color,
    required this.text,
  });

  final Color? color;
  final String text;
}

class ChoiceItem extends StatelessWidget {
  const ChoiceItem(
      {Key? key,
      required this.theme,
      required this.onLongPress,
      required this.onPressed,
      required this.entry,
      required this.isSelected})
      : super(key: key);

  final MapEntry<int, Choice> entry;
  final ThemeData theme;
  final void Function(int p1)? onLongPress;
  final void Function(int p1) onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    try {
      return Tooltip(
        message: onLongPress != null ? L10n.of(context)!.holdForInfo : "",
        waitDuration: onLongPress != null
            ? const Duration(milliseconds: 500)
            : const Duration(days: 1),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: EdgeInsets.zero,
          decoration: isSelected
              ? BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: entry.value.color ?? theme.colorScheme.primary,
                    style: BorderStyle.solid,
                    width: 2.0,
                  ),
                )
              : null,
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 7)),
              //if index is selected, then give the background a slight primary color
              backgroundColor: MaterialStateProperty.all<Color>(
                entry.value.color != null
                    ? entry.value.color!.withOpacity(0.2)
                    : theme.colorScheme.primary.withOpacity(0.1),
              ),
              textStyle: MaterialStateProperty.all(
                BotStyle.text(context),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onLongPress:
                onLongPress != null ? () => onLongPress!(entry.key) : null,
            onPressed: () => onPressed(entry.key),
            child: Text(
              entry.value.text,
              style: BotStyle.text(context),
            ),
          ),
        ),
      );
    } catch (e) {
      debugger(when: kDebugMode);
      return Container();
    }
  }
}
