import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/message_analytics_controller.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/utils/message_text_util.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Question - does this need to be stateful or does this work?
/// Need to test.
class MessageTokenText extends StatelessWidget {
  final PangeaMessageEvent _pangeaMessageEvent;

  final List<PangeaToken>? _tokens;

  final TextStyle _style;

  final bool Function(PangeaToken)? _isSelected;
  final void Function(PangeaToken)? _onClick;

  const MessageTokenText({
    super.key,
    required PangeaMessageEvent pangeaMessageEvent,
    required List<PangeaToken>? tokens,
    required TextStyle style,
    required void Function(PangeaToken)? onClick,
    bool Function(PangeaToken)? isSelected,
  })  : _onClick = onClick,
        _isSelected = isSelected,
        _style = style,
        _tokens = tokens,
        _pangeaMessageEvent = pangeaMessageEvent;

  MessageAnalyticsEntry? get messageAnalyticsEntry => _tokens != null
      ? MatrixState.pangeaController.getAnalytics.perMessage.get(
          _tokens!,
          _pangeaMessageEvent,
        )
      : null;

  @override
  Widget build(BuildContext context) {
    if (_tokens == null) {
      return Text(
        _pangeaMessageEvent.messageDisplayText,
        style: _style,
      );
    }

    void callOnClick(TokenPosition tokenPosition) {
      _onClick != null && tokenPosition.token != null
          ? _onClick!(tokenPosition.token!)
          : null;
    }

    return MessageTextWidget(
      pangeaMessageEvent: _pangeaMessageEvent,
      style: _style,
      messageAnalyticsEntry: messageAnalyticsEntry,
      isSelected: _isSelected,
      onClick: callOnClick,
    );
  }
}

class TokenPosition {
  /// Start index of the full substring in the message
  final int start;

  /// End index of the full substring in the message
  final int end;

  /// Start index of the token in the message
  final int tokenStart;

  /// End index of the token in the message
  final int tokenEnd;

  final bool selected;
  final bool hideContent;
  final PangeaToken? token;

  const TokenPosition({
    required this.start,
    required this.end,
    required this.tokenStart,
    required this.tokenEnd,
    required this.hideContent,
    required this.selected,
    this.token,
  });
}

class HiddenText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const HiddenText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.size.width;
    final textHeight = textPainter.size.height;

    textPainter.dispose();

    return SizedBox(
      height: textHeight,
      child: Stack(
        children: [
          Container(
            width: textWidth,
            height: textHeight,
            color: Colors.transparent,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: textWidth,
              height: 1,
              color: style.color,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTextWidget extends StatelessWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final TextStyle style;
  final MessageAnalyticsEntry? messageAnalyticsEntry;
  final bool Function(PangeaToken)? isSelected;
  final void Function(TokenPosition tokenPosition)? onClick;

  final bool? softWrap;
  final int? maxLines;
  final TextOverflow? overflow;

  const MessageTextWidget({
    super.key,
    required this.pangeaMessageEvent,
    required this.style,
    this.messageAnalyticsEntry,
    this.isSelected,
    this.onClick,
    this.softWrap,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final Characters messageCharacters =
        pangeaMessageEvent.messageDisplayText.characters;

    final tokenPositions = MessageTextUtil.getTokenPositions(
      pangeaMessageEvent,
      messageAnalyticsEntry: messageAnalyticsEntry,
      isSelected: isSelected,
    );

    if (tokenPositions == null) {
      return Text(
        pangeaMessageEvent.messageDisplayText,
        style: style,
        softWrap: softWrap,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final hideTokenHighlights = messageAnalyticsEntry != null &&
        (messageAnalyticsEntry!.hasHiddenWordActivity ||
            messageAnalyticsEntry!.hasMessageMeaningActivity);

    return RichText(
      softWrap: softWrap ?? true,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(
        children:
            tokenPositions.mapIndexed((int i, TokenPosition tokenPosition) {
          final shouldDo = pangeaMessageEvent.shouldDoActivity(
            token: tokenPosition.token,
            a: ActivityTypeEnum.wordMeaning,
            feature: null,
            tag: null,
          );

          final didMeaningActivity =
              tokenPosition.token?.didActivitySuccessfully(
                    ActivityTypeEnum.wordMeaning,
                  ) ??
                  true;

          final substring = messageCharacters
              .skip(tokenPosition.start)
              .take(tokenPosition.end - tokenPosition.start)
              .toString();

          Color backgroundColor = Colors.transparent;
          if (!hideTokenHighlights) {
            if (tokenPosition.selected) {
              backgroundColor = AppConfig.primaryColor.withAlpha(80);
            } else if (isSelected != null && shouldDo) {
              backgroundColor = !didMeaningActivity
                  ? AppConfig.success.withAlpha(60)
                  : AppConfig.gold.withAlpha(60);
            }
          }

          if (tokenPosition.token != null) {
            if (tokenPosition.hideContent) {
              return WidgetSpan(
                child: GestureDetector(
                  onTap: onClick != null
                      ? () => onClick?.call(tokenPosition)
                      : null,
                  child: HiddenText(text: substring, style: style),
                ),
              );
            }

            // if the tokenPosition is a combination of the token and preceding / following punctuation
            // split them so that only the token itself is highlighted when clicked
            String start = '';
            String middle = '';
            String end = '';

            final startSplitIndex =
                tokenPosition.tokenStart - tokenPosition.start;
            final endSplitIndex = tokenPosition.tokenEnd - tokenPosition.start;

            start = substring.substring(0, startSplitIndex);
            end = substring.substring(endSplitIndex);
            middle = substring.substring(
              startSplitIndex,
              endSplitIndex,
            );

            return WidgetSpan(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onClick != null
                      ? () => onClick?.call(tokenPosition)
                      : null,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        if (start.isNotEmpty)
                          LinkifySpan(
                            text: start,
                            style: style,
                            linkStyle: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onPrimary,
                            ),
                            onOpen: (url) =>
                                UrlLauncher(context, url.url).launchUrl(),
                          ),
                        LinkifySpan(
                          text: middle,
                          style: style.merge(
                            TextStyle(
                              backgroundColor: backgroundColor,
                            ),
                          ),
                          linkStyle: TextStyle(
                            decoration: TextDecoration.underline,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onPrimary,
                          ),
                          onOpen: (url) =>
                              UrlLauncher(context, url.url).launchUrl(),
                        ),
                        if (end.isNotEmpty)
                          LinkifySpan(
                            text: end,
                            style: style,
                            linkStyle: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onPrimary,
                            ),
                            onOpen: (url) =>
                                UrlLauncher(context, url.url).launchUrl(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            if ((i > 0 || i < tokenPositions.length - 1) &&
                tokenPositions[i + 1].hideContent &&
                tokenPositions[i - 1].hideContent) {
              return WidgetSpan(
                child: GestureDetector(
                  onTap: onClick != null
                      ? () => onClick?.call(tokenPosition)
                      : null,
                  child: HiddenText(text: substring, style: style),
                ),
              );
            }
            return LinkifySpan(
              text: substring,
              style: style,
              options: const LinkifyOptions(humanize: false),
              linkStyle: TextStyle(
                decoration: TextDecoration.underline,
                color: Theme.of(context).colorScheme.primary,
              ),
              onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
            );
          }
        }).toList(),
      ),
    );
  }
}
