import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/choice_animation.dart';
import 'package:fluffychat/pangea/text_to_speech/tts_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../bot/utils/bot_style.dart';

typedef ChoiceCallback = void Function(String value, int index);

class ChoicesArray extends StatelessWidget {
  final bool isLoading;
  final List<Choice>? choices;
  final ChoiceCallback onPressed;
  final ChoiceCallback? onLongPress;
  final int? selectedChoiceIndex;

  final bool enableAudio;

  /// language code for the TTS
  final String? langCode;

  /// Used to unqiuely identify the keys for choices, in cases where multiple
  /// choices could have identical text, like in back-to-back practice activities
  final String? id;

  final String Function(String)? getDisplayCopy;
  final bool enabled;

  const ChoicesArray({
    super.key,
    required this.isLoading,
    required this.choices,
    required this.onPressed,
    required this.selectedChoiceIndex,
    this.enableAudio = true,
    this.langCode,
    this.onLongPress,
    this.getDisplayCopy,
    this.id,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading && (choices == null || choices!.length <= 1)
        ? Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            runSpacing: 4,
            children: List.generate(3, (_) {
              return ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(50, 36),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withAlpha(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                  ),
                  onPressed: null,
                  child: const Text(
                    "          ", // 10 spaces
                    style: TextStyle(color: Colors.transparent, fontSize: 16),
                  ),
                ),
              );
            }),
          )
        : Wrap(
            alignment: WrapAlignment.center,
            spacing: 4.0,
            children: [
              ...choices!.mapIndexed(
                (index, entry) => ChoiceItem(
                  onLongPress: onLongPress,
                  onPressed: (String value, int index) {
                    onPressed(value, index);
                    if (enableAudio && langCode != null) {
                      TtsController.tryToSpeak(
                        value,
                        targetID: null,
                        langCode: langCode!,
                      );
                    }
                  },
                  entry: MapEntry(index, entry),
                  isSelected: selectedChoiceIndex == index,
                  id: id,
                  getDisplayCopy: getDisplayCopy,
                  enabled: enabled,
                ),
              ),
            ],
          );
  }
}

class Choice {
  Choice({this.color, required this.text, this.isGold = false});

  final Color? color;
  final String text;
  final bool isGold;
}

class ChoiceItem extends StatelessWidget {
  final MapEntry<int, Choice> entry;
  final ChoiceCallback? onLongPress;
  final ChoiceCallback onPressed;
  final bool isSelected;
  final String? id;
  final String Function(String)? getDisplayCopy;
  final double? fontSize;
  final bool enabled;

  const ChoiceItem({
    super.key,
    required this.onLongPress,
    required this.onPressed,
    required this.entry,
    required this.isSelected,
    required this.id,
    this.getDisplayCopy,
    this.fontSize,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: onLongPress != null ? L10n.of(context).holdForInfo : "",
      waitDuration: onLongPress != null
          ? const Duration(milliseconds: 500)
          : const Duration(days: 1),
      child: CompositedTransformTarget(
        link: MatrixState.pAnyState
            .layerLinkAndKey("${entry.value.text}$id")
            .link,
        child: ChoiceAnimationWidget(
          isSelected: isSelected,
          isCorrect: entry.value.isGold,
          key: MatrixState.pAnyState
              .layerLinkAndKey("${entry.value.text}$id")
              .key,
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConfig.borderRadius),
              ),
              border: Border.all(
                color: isSelected
                    ? entry.value.color ?? theme.colorScheme.primary
                    : Colors.transparent,
                style: BorderStyle.solid,
                width: 2.0,
              ),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                backgroundColor:
                    entry.value.color?.withAlpha(50) ??
                    theme.colorScheme.primary.withAlpha(10),
                textStyle: BotStyle.text(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                ),
              ),
              onLongPress: onLongPress != null && enabled
                  ? () => onLongPress!(entry.value.text, entry.key)
                  : null,
              onPressed: enabled
                  ? () => onPressed(entry.value.text, entry.key)
                  : null,
              child: Text(
                getDisplayCopy != null
                    ? getDisplayCopy!(entry.value.text)
                    : entry.value.text,
                style: BotStyle.text(context).copyWith(fontSize: fontSize),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
