import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:dart_animated_emoji/dart_animated_emoji.dart';
import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:lottie/lottie.dart';

import 'package:fluffychat/pages/settings_chat/settings_chat.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// takes a text as input and parses out Animated Emojis adn Linkifys it
class TextLinkifyEmojify extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? textColor;
  final TextDecoration? textDecoration;

  const TextLinkifyEmojify(
    this.text, {
    super.key,
    required this.fontSize,
    this.textColor,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    String text = this.text;
    final regex = emojiRegex();

    final animate =
        Matrix.of(context).client.autoplayAnimatedContent ?? !kIsWeb;

    final parts = <Widget>[];
    do {
      // in order to prevent animated rendering of partial emojis in case
      // the glyph is constructed from several code points, match on emojis in
      // general and then check whether the entire glyph is animatable
      final match = regex.allMatches(text).firstWhereOrNull(
            (match) =>
                AnimatedEmoji.all.any((emoji) => emoji.fallback == match[0]),
          );

      if (match == null || match.start != 0) {
        parts.add(_linkifyString(text.substring(0, match?.start), context));
      }
      if (match != null) {
        final emoji = AnimatedEmoji.all.firstWhere(
          (element) => element.fallback == match[0],
        );
        parts.add(_lottieBox(emoji, animate));
        text = text.substring(match.end);
      } else {
        text = '';
      }
    } while (regex.hasMatch(text));
    if (text.isNotEmpty) {
      parts.add(_linkifyString(text, context));
    }
    if (parts.length == 1) {
      return parts.single;
    } else {
      return Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 2,
        runSpacing: 2,
        children: parts,
      );
    }
  }

  Widget _linkifyString(String text, BuildContext context) {
    return Linkify(
      text: text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        decoration: textDecoration,
      ),
      options: const LinkifyOptions(humanize: false),
      linkStyle: TextStyle(
        color: textColor?.withAlpha(150),
        fontSize: fontSize,
        decoration: TextDecoration.underline,
        decorationColor: textColor?.withAlpha(150),
      ),
      onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
    );
  }

  Widget _lottieBox(AnimatedEmoji emoji, bool animate) {
    return AnimatedEmojiLottieView(
      emoji: emoji,
      size: fontSize * 1.25,
      textColor: textColor,
    );
  }
}

class AnimatedEmojiLottieView extends StatelessWidget {
  final AnimatedEmoji emoji;
  final double size;
  final Color? textColor;

  const AnimatedEmojiLottieView({
    super.key,
    required this.emoji,
    required this.size,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: size,
        child: AnimationEnabledContainerView(
          iconSize: size / 2.5,
          builder: (animate) {
            return Lottie.memory(
              key: ValueKey(emoji.name + size.toString()),
              Uint8List.fromList(emoji.lottieAnimation.codeUnits),
              animate: animate,
            );
          },
          textColor: textColor,
        ),
      );
}

typedef AnimatedChildBuilder = Widget Function(bool animate);

class AnimationEnabledContainerView extends StatefulWidget {
  final AnimatedChildBuilder builder;
  final double iconSize;
  final Color? textColor;
  final bool disableTapHandler;

  const AnimationEnabledContainerView({
    super.key,
    required this.builder,
    required this.iconSize,
    this.textColor,
    this.disableTapHandler = false,
  });

  @override
  State<AnimationEnabledContainerView> createState() =>
      _AnimationEnabledContainerViewState();
}

class _AnimationEnabledContainerViewState
    extends State<AnimationEnabledContainerView> {
  bool get autoplay =>
      Matrix.of(context).client.autoplayAnimatedContent ?? true;

  /// whether to animate though autoplay disabled
  bool animating = false;

  @override
  Widget build(BuildContext context) {
    final autoplay = this.autoplay;

    final box = widget.builder.call(autoplay || animating);

    if (autoplay) return box;

    return MouseRegion(
      onEnter: startAnimation,
      onHover: startAnimation,
      onExit: stopAnimation,
      child: GestureDetector(
        onTap: widget.disableTapHandler ? null : toggleAnimation,
        child: Stack(
          alignment: Alignment.bottomRight,
          fit: StackFit.loose,
          children: [
            box,
            if (!animating)
              Icon(
                Icons.gif,
                size: widget.iconSize,
                color: widget.textColor,
              ),
          ],
        ),
      ),
    );
  }

  void startAnimation(PointerEvent e) {
    if (e.kind == PointerDeviceKind.mouse) {
      setState(() => animating = true);
    }
  }

  void stopAnimation(PointerEvent e) {
    if (e.kind == PointerDeviceKind.mouse) {
      setState(() => animating = false);
    }
  }

  void toggleAnimation() => setState(() => animating = !animating);

  @override
  void didUpdateWidget(covariant AnimationEnabledContainerView oldWidget) {
    if (oldWidget.builder != widget.builder ||
        oldWidget.iconSize != widget.iconSize ||
        oldWidget.textColor != widget.textColor) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }
}
