import 'package:fluffychat/pangea/controllers/message_analytics_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Question - does this need to be stateful or does this work?
/// Need to test.
class MessageTokenTextStateful extends StatelessWidget {
  final PangeaController pangeaController = MatrixState.pangeaController;

  final MessageAnalyticsEntry messageAnalyticsEntry;

  final TextStyle style;

  final void Function(PangeaToken)? onClick;

  bool get ownMessage => messageAnalyticsEntry.pmEvent.ownMessage;

  MessageTokenTextStateful({
    super.key,
    required this.messageAnalyticsEntry,
    required this.style,
    required this.onClick,
  });

  PangeaMessageEvent get pangeaMessageEvent => messageAnalyticsEntry.pmEvent;

  @override
  Widget build(BuildContext context) {
    // Convert the entire message into a list of characters
    final Characters messageCharacters =
        pangeaMessageEvent.messageDisplayText.characters;

    // When building token positions, use grapheme cluster indices
    final List<TokenPosition> tokenPositions = [];
    int globalIndex = 0;

    for (final token in messageAnalyticsEntry.tokensWithXp) {
      final start = token.token.start;
      final end = token.token.end;

      // Calculate the number of grapheme clusters up to the start and end positions
      final int startIndex = messageCharacters.take(start).length;
      final int endIndex = messageCharacters.take(end).length;

      if (globalIndex < startIndex) {
        tokenPositions.add(
          TokenPosition(
            start: globalIndex,
            end: startIndex,
            hideContent: false,
            highlight: false,
          ),
        );
      }

      tokenPositions.add(
        TokenPosition(
          start: startIndex,
          end: endIndex,
          token: token.token,
          hideContent:
              token.targetTypes.contains(ActivityTypeEnum.hiddenWordListening),
          highlight: false,
        ),
      );
      globalIndex = endIndex;
    }

    return RichText(
      text: TextSpan(
        children: tokenPositions.map((tokenPosition) {
          final substring = messageCharacters
              .skip(tokenPosition.start)
              .take(tokenPosition.end - tokenPosition.start)
              .toString();

          if (tokenPosition.token != null) {
            return TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => onClick != null && tokenPosition.token != null
                    ? onClick!(tokenPosition.token!)
                    : null,
              text: !tokenPosition.hideContent ? substring : '_____',
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
