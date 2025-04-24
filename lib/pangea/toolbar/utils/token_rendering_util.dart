import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/toolbar/enums/reading_assistance_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class TokenRenderingUtil {
  final PangeaMessageEvent? pangeaMessageEvent;
  final ReadingAssistanceMode? readingAssistanceMode;
  final MessageOverlayController? overlayController;
  final bool isTransitionAnimation;
  final TextStyle existingStyle;

  static final Map<String, double> _tokensWidthCache = {};

  TokenRenderingUtil({
    required this.pangeaMessageEvent,
    required this.readingAssistanceMode,
    required this.existingStyle,
    this.overlayController,
    this.isTransitionAnimation = false,
  });

  bool get showCenterStyling {
    if (overlayController == null) return false;
    if (!isTransitionAnimation) return true;
    return readingAssistanceMode == ReadingAssistanceMode.transitionMode;
  }

  double? _fontSize(BuildContext context) => showCenterStyling
      ? overlayController != null && overlayController!.maxWidth > 600
          ? Theme.of(context).textTheme.titleLarge?.fontSize
          : Theme.of(context).textTheme.bodyLarge?.fontSize
      : null;

  TextStyle style(
    BuildContext context, {
    Color? color,
  }) =>
      existingStyle.copyWith(
        fontSize: _fontSize(context),
        decoration: TextDecoration.underline,
        decorationThickness: 4,
        decorationColor: color ?? Colors.white.withAlpha(0),
      );

  double tokenTextWidthForContainer(BuildContext context, String text) {
    final tokenSizeKey = "$text-${_fontSize(context)}";
    if (_tokensWidthCache.containsKey(tokenSizeKey)) {
      return _tokensWidthCache[tokenSizeKey]!;
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style(context),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final width = textPainter.width;
    textPainter.dispose();

    _tokensWidthCache[tokenSizeKey] = width;
    return width;
  }

  // Only one token on the screen can have the token's unique key at a time.
  // When readingAssistanceMode is not null, there are two messages - the centered message and the transition message.
  // When in word mode, the key goes to the transition message.
  // If actively transitioning, neither gets the keys.
  // If in message mode, the key goes to the centered message (isTransitionAnimation == false).
  bool get assignTokenKey {
    if (readingAssistanceMode == null) {
      return false;
    }

    switch (readingAssistanceMode!) {
      case ReadingAssistanceMode.selectMode:
        return isTransitionAnimation;
      case ReadingAssistanceMode.transitionMode:
        return false;
      case ReadingAssistanceMode.practiceMode:
        return !isTransitionAnimation;
    }
  }

  Color backgroundColor(BuildContext context, bool selected) {
    return selected
        ? Theme.of(context).colorScheme.primary
        : Colors.white.withAlpha(0);
  }
}
