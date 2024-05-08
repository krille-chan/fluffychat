import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/material.dart';

class BotStyle {
  static TextStyle text(
    BuildContext context, {
    TextStyle? existingStyle,
    bool setColor = true,
    bool big = false,
    bool italics = false,
    bool bold = true,
  }) {
    try {
      final TextStyle botStyle = TextStyle(
        fontFamily: 'Inconsolata',
        fontWeight: bold ? FontWeight.w700 : null,
        fontSize: AppConfig.messageFontSize *
            AppConfig.fontSizeFactor *
            (big == true ? 1.2 : 1),
        fontStyle: italics ? FontStyle.italic : null,
        color: setColor
            ? Theme.of(context).brightness == Brightness.dark
                ? AppConfig.primaryColorLight
                : AppConfig.primaryColor
            : null,
        inherit: true,
      );

      return existingStyle?.merge(botStyle) ?? botStyle;
    } catch (err, stack) {
      ErrorHandler.logError(m: "error getting styles", s: stack);
      return existingStyle ?? const TextStyle();
    }
  }
}
