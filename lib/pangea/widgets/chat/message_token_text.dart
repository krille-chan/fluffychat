import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/controllers/message_analytics_controller.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/utils/message_text_util.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
  final int start;
  final int end;
  final bool highlight;
  final bool hideContent;
  final PangeaToken? token;

  const TokenPosition({
    required this.start,
    required this.end,
    required this.hideContent,
    required this.highlight,
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

  const MessageTextWidget({
    super.key,
    required this.pangeaMessageEvent,
    required this.style,
    this.messageAnalyticsEntry,
    this.isSelected,
    this.onClick,
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
      );
    }

    return RichText(
      text: TextSpan(
        children:
            tokenPositions.mapIndexed((int i, TokenPosition tokenPosition) {
          final substring = messageCharacters
              .skip(tokenPosition.start)
              .take(tokenPosition.end - tokenPosition.start)
              .toString();

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
            return TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap =
                    onClick != null ? () => onClick?.call(tokenPosition) : null,
              text: substring,
              style: style.merge(
                TextStyle(
                  backgroundColor: tokenPosition.highlight
                      ? Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.4)
                          : Colors.white.withOpacity(0.4)
                      : Colors.transparent,
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
            return TextSpan(
              text: substring,
              style: style,
            );
          }
        }).toList(),
      ),
    );
  }
}
