import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_misc/message_analytics_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_token_text.dart';

class MessageTextUtil {
  static List<TokenPosition>? getTokenPositions(
    PangeaMessageEvent pangeaMessageEvent, {
    MessageAnalyticsEntry? messageAnalyticsEntry,
    bool Function(PangeaToken)? isSelected,
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
        final token = tokens[pointer];
        final start = token.start;
        final end = token.end;

        // Calculate the number of grapheme clusters up to the start and end positions
        final int startIndex = messageCharacters.take(start).length;
        int endIndex = messageCharacters.take(end).length;

        final hideContent =
            messageAnalyticsEntry?.isTokenInHiddenWordActivity(token) ?? false;

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
            ),
          );
        }

        // group tokens with punctuation next to it so punctuation doesn't cause newline
        final List<PangeaToken> followingPunctTokens = [];
        int nextTokenPointer = pointer + 1;
        while (nextTokenPointer < tokens.length) {
          final nextToken = tokens[nextTokenPointer];
          if (nextToken.pos == 'PUNCT') {
            followingPunctTokens.add(nextToken);
            nextTokenPointer++;
            endIndex = messageCharacters.take(nextToken.end).length;
            continue;
          }
          break;
        }

        tokenPositions.add(
          TokenPosition(
            start: startIndex,
            end: endIndex,
            tokenStart: startIndex,
            tokenEnd: messageCharacters.take(end).length,
            token: token,
            hideContent: hideContent,
            selected: (isSelected?.call(token) ?? false) &&
                !hideContent &&
                !hasHiddenContent,
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
