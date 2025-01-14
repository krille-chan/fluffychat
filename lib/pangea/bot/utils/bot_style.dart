import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';

class BotStyle {
  static TextStyle text(
    BuildContext context, {
    TextStyle? existingStyle,
    bool setColor = true,
    bool big = false,
    bool italics = false,
    bool bold = false,
  }) {
    try {
      final TextStyle botStyle = TextStyle(
        fontWeight: bold ? FontWeight.w700 : null,
        fontSize: AppConfig.messageFontSize *
            AppConfig.fontSizeFactor *
            (big == true ? 1.2 : 1),
        fontStyle: italics ? FontStyle.italic : null,
        color: setColor ? Theme.of(context).colorScheme.primary : null,
        inherit: true,
        height: 1.3,
      );

      return existingStyle?.merge(botStyle) ?? botStyle;
    } catch (err, stack) {
      ErrorHandler.logError(
        m: "error getting styles",
        s: stack,
        data: {},
      );
      return existingStyle ?? const TextStyle();
    }
  }
}
