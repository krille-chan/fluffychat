import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

enum MessageMode { translation, definition, speechToText, textToSpeech }

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
      default:
        return L10n.of(context)!
            .oopsSomethingWentWrong; // Title to indicate an error or unsupported mode
    }
  }
}
