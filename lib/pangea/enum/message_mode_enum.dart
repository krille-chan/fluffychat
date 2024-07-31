import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

enum MessageMode {
  translation,
  definition,
  speechToText,
  textToSpeech,
  practiceActivity
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
        return L10n.of(context)!.translations;
      case MessageMode.textToSpeech:
        return L10n.of(context)!.messageAudio;
      case MessageMode.speechToText:
        return L10n.of(context)!.speechToTextTooltip;
      case MessageMode.definition:
        return L10n.of(context)!.definitions;
      case MessageMode.practiceActivity:
        return L10n.of(context)!.practice;
      default:
        return L10n.of(context)!
            .oopsSomethingWentWrong; // Title to indicate an error or unsupported mode
    }
  }

  String tooltip(BuildContext context) {
    switch (this) {
      case MessageMode.translation:
        return L10n.of(context)!.translationTooltip;
      case MessageMode.textToSpeech:
        return L10n.of(context)!.audioTooltip;
      case MessageMode.speechToText:
        return L10n.of(context)!.speechToTextTooltip;
      case MessageMode.definition:
        return L10n.of(context)!.define;
      case MessageMode.practiceActivity:
        return L10n.of(context)!.practice;
      default:
        return L10n.of(context)!
            .oopsSomethingWentWrong; // Title to indicate an error or unsupported mode
    }
  }

  bool isValidMode(Event event) {
    switch (this) {
      case MessageMode.translation:
      case MessageMode.textToSpeech:
      case MessageMode.definition:
        return event.messageType == MessageTypes.Text;
      case MessageMode.speechToText:
        return event.messageType == MessageTypes.Audio;
      case MessageMode.practiceActivity:
        return true;
    }
  }

  Color? iconColor(
    PangeaMessageEvent event,
    MessageMode? currentMode,
    BuildContext context,
  ) {
    final bool isPracticeActivity = this == MessageMode.practiceActivity;
    final bool practicing = currentMode == MessageMode.practiceActivity;
    final bool practiceEnabled = event.hasUncompletedActivity;

    // if this is the practice activity icon, and there's no practice activities available,
    // and the current mode is not practice, return lower opacity color.
    if (isPracticeActivity && !practicing && !practiceEnabled) {
      return Theme.of(context).iconTheme.color?.withOpacity(0.5);
    }

    // if this is not a practice activity icon, and practice activities are available,
    // then return lower opacity color if the current mode is practice.
    if (!isPracticeActivity && practicing && practiceEnabled) {
      return Theme.of(context).iconTheme.color?.withOpacity(0.5);
    }

    // if this is the current mode, return primary color.
    return currentMode == this ? Theme.of(context).colorScheme.primary : null;
  }
}
