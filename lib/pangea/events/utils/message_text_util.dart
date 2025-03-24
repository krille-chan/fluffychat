import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/practice_activities/message_analytics_controller.dart';

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
  final bool isHighlighted;

  const TokenPosition({
    required this.start,
    required this.end,
    required this.tokenStart,
    required this.tokenEnd,
    required this.hideContent,
    required this.selected,
    required this.isHighlighted,
    this.token,
  });
}

class MessageTextUtil {
  static List<TokenPosition>? getTokenPositions(
    PangeaMessageEvent pangeaMessageEvent, {
    MessageAnalyticsEntry? messageAnalyticsEntry,
    bool Function(PangeaToken)? isSelected,
    bool Function(PangeaToken)? isHighlighted,
  }) {
    try {
      if (pangeaMessageEvent.messageDisplayRepresentation?.tokens == null) {
        return null;
      }

      // Convert the entire message into a list of characters
      final Characters messageCharacters =
          pangeaMessageEvent.messageDisplayText.characters;

      // When building token positions, use grapheme cluster indices
      final List<TokenPosition> tokenPositions = [];
      int globalIndex = 0;

      final tokens = pangeaMessageEvent.messageDisplayRepresentation!.tokens!;
      int pointer = 0;
      while (pointer < tokens.length) {
        PangeaToken token = tokens[pointer];
        final start = token.start;
        final end = token.end;

        // Calculate the number of grapheme clusters up to the start and end positions
        final int startIndex = messageCharacters.take(start).length;
        int endIndex = messageCharacters.take(end).length;

        final hasHiddenContent =
            messageAnalyticsEntry?.hasHiddenWordActivity ?? false;

        // if this is white space, add position without token
        if (globalIndex < startIndex) {
          tokenPositions.add(
            TokenPosition(
              start: globalIndex,
              end: startIndex,
              tokenStart: globalIndex,
              tokenEnd: startIndex,
              hideContent: false,
              selected: (isSelected?.call(token) ?? false) && !hasHiddenContent,
              isHighlighted: isHighlighted?.call(token) ?? false,
            ),
          );
        }

        // group tokens with punctuation before and after so punctuation doesn't cause newline
        int nextTokenPointer = pointer + 1;
        while (nextTokenPointer < tokens.length) {
          final nextToken = tokens[nextTokenPointer];
          if (token.pos == 'PUNCT' && token.end == nextToken.start) {
            token = nextToken;
            nextTokenPointer++;
            endIndex = messageCharacters.take(nextToken.end).length;
            continue;
          }
          break;
        }

        while (nextTokenPointer < tokens.length) {
          final nextToken = tokens[nextTokenPointer];

          if (nextToken.pos == 'PUNCT' && token.end == nextToken.start) {
            nextTokenPointer++;
            endIndex = messageCharacters.take(nextToken.end).length;
            continue;
          }
          break;
        }

        final hideContent =
            messageAnalyticsEntry?.isTokenInHiddenWordActivity(token) ?? false;

        tokenPositions.add(
          TokenPosition(
            start: startIndex,
            end: endIndex,
            tokenStart: messageCharacters.take(token.start).length,
            tokenEnd: messageCharacters.take(token.end).length,
            token: token,
            hideContent: hideContent,
            selected: (isSelected?.call(token) ?? false) &&
                !hideContent &&
                !hasHiddenContent,
            isHighlighted: isHighlighted?.call(token) ?? false,
          ),
        );

        globalIndex = endIndex;
        pointer = nextTokenPointer;
        continue;
      }

      return tokenPositions;
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          'pangeaMessageEvent': pangeaMessageEvent,
          'messageAnalyticsEntry': messageAnalyticsEntry,
          'isSelected': isSelected,
        },
      );
      return null;
    }
  }
}
