import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

enum MessageMode {
  practiceActivity,
  textToSpeech,
  translation,
  speechToText,
  wordZoom,
  noneSelected,
  messageMeaning,
}

extension MessageModeExtension on MessageMode {
  IconData get icon {
    switch (this) {
      case MessageMode.translation:
        return Icons.g_translate;
      case MessageMode.textToSpeech:
        return Symbols.text_to_speech;
      case MessageMode.speechToText:
        return Symbols.speech_to_text;
      case MessageMode.practiceActivity:
        return Symbols.fitness_center;
      case MessageMode.wordZoom:
        return Symbols.dictionary;
      case MessageMode.noneSelected:
        return Icons.error;
      case MessageMode.messageMeaning:
        return Icons.star;
    }
  }

  String title(BuildContext context) {
    switch (this) {
      case MessageMode.translation:
        return L10n.of(context).translations;
      case MessageMode.textToSpeech:
        return L10n.of(context).messageAudio;
      case MessageMode.speechToText:
        return L10n.of(context).speechToTextTooltip;
      case MessageMode.practiceActivity:
        return L10n.of(context).practice;
      case MessageMode.wordZoom:
        return L10n.of(context).vocab;
      case MessageMode.noneSelected:
        return '';
      case MessageMode.messageMeaning:
        return L10n.of(context).meaning;
    }
  }

  String tooltip(BuildContext context) {
    switch (this) {
      case MessageMode.translation:
        return L10n.of(context).translationTooltip;
      case MessageMode.textToSpeech:
        return L10n.of(context).audioTooltip;
      case MessageMode.speechToText:
        return L10n.of(context).speechToTextTooltip;
      case MessageMode.practiceActivity:
        return L10n.of(context).practice;
      case MessageMode.wordZoom:
        return L10n.of(context).vocab;
      case MessageMode.noneSelected:
        return '';
      case MessageMode.messageMeaning:
        return L10n.of(context).meaning;
    }
  }

  double get pointOnBar {
    switch (this) {
      case MessageMode.practiceActivity:
        return 0;
      case MessageMode.textToSpeech:
        return 0.33;
      case MessageMode.translation:
        return 1;
      case MessageMode.speechToText:
      case MessageMode.wordZoom:
      case MessageMode.noneSelected:
      case MessageMode.messageMeaning:
        return 0;
    }
  }

  bool isUnlocked(
    double proportionOfActivitiesCompleted,
    bool totallyDone,
  ) {
    if (totallyDone) return true;

    switch (this) {
      case MessageMode.translation:
      case MessageMode.textToSpeech:
        return proportionOfActivitiesCompleted >= pointOnBar;
      case MessageMode.speechToText:
      case MessageMode.practiceActivity:
      case MessageMode.wordZoom:
      case MessageMode.noneSelected:
      case MessageMode.messageMeaning:
        return true;
    }
  }

  bool get showButton => this != MessageMode.practiceActivity;

  Color iconButtonColor(
    BuildContext context,
    MessageMode currentMode,
    double proportionOfActivitiesUnlocked,
    bool totallyDone,
  ) {
    //locked
    if (!isUnlocked(proportionOfActivitiesUnlocked, totallyDone)) {
      return barAndLockedButtonColor(context);
    }

    //unlocked and active
    if (this == currentMode) return Theme.of(context).colorScheme.primary;

    //unlocked and inactive
    return Theme.of(context).colorScheme.primaryContainer;
  }

  static Color barAndLockedButtonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.grey[200]!;
  }
}
