import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

enum MessageMode { conversion, translation, definition }

extension MessageModeExtension on MessageMode {
  IconData icon(bool isAudioMessage) {
    switch (this) {
      case MessageMode.translation:
        return Icons.g_translate;
      case MessageMode.conversion:
        return Icons.play_arrow;
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
      case MessageMode.conversion:
        return L10n.of(context)!.messageAudio;
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
      case MessageMode.conversion:
        return L10n.of(context)!.audioTooltip;
      case MessageMode.definition:
        return L10n.of(context)!.define;
      default:
        return L10n.of(context)!
            .oopsSomethingWentWrong; // Title to indicate an error or unsupported mode
    }
  }
}
