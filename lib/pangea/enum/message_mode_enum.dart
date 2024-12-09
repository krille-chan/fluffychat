import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

enum MessageMode {
  practiceActivity,
  textToSpeech,
  definition,
  translation,
  speechToText,
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
      //TODO change icon for audio messages
      case MessageMode.definition:
        return Icons.book;
      case MessageMode.practiceActivity:
        return Symbols.fitness_center;
      default:
        return Icons.error; // Icon to indicate an error or unsupported mode
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
      case MessageMode.definition:
        return L10n.of(context).definitions;
      case MessageMode.practiceActivity:
        return L10n.of(context).practice;
      default:
        return L10n.of(context)
            .oopsSomethingWentWrong; // Title to indicate an error or unsupported mode
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
      case MessageMode.definition:
        return L10n.of(context).define;
      case MessageMode.practiceActivity:
        return L10n.of(context).practice;
      default:
        return L10n.of(context)
            .oopsSomethingWentWrong; // Title to indicate an error or unsupported mode
    }
  }

  bool shouldShowAsToolbarButton(Event event) {
    switch (this) {
      case MessageMode.translation:
        return event.messageType == MessageTypes.Text;
      case MessageMode.textToSpeech:
        return event.messageType == MessageTypes.Text;
      case MessageMode.definition:
        return event.messageType == MessageTypes.Text;
      case MessageMode.speechToText:
        return event.messageType == MessageTypes.Audio;
      case MessageMode.practiceActivity:
        return true;
    }
  }

  bool isUnlocked(
    int index,
    int numActivitiesCompleted,
    bool totallyDone,
  ) =>
      numActivitiesCompleted >= index || totallyDone;

  Color iconButtonColor(
    BuildContext context,
    int index,
    MessageMode currentMode,
    int numActivitiesCompleted,
    bool totallyDone,
  ) {
    //locked
    if (!isUnlocked(index, numActivitiesCompleted, totallyDone)) {
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
