import 'package:fluffychat/pangea/controllers/message_analytics_controller.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/message_token_text.dart';
import 'package:flutter/material.dart';

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

      for (final token
          in pangeaMessageEvent.messageDisplayRepresentation!.tokens!) {
        final start = token.start;
        final end = token.end;

        // Calculate the number of grapheme clusters up to the start and end positions
        final int startIndex = messageCharacters.take(start).length;
        final int endIndex = messageCharacters.take(end).length;

        final hideContent =
            messageAnalyticsEntry?.isTokenInHiddenWordActivity(token) ?? false;

        final hasHiddenContent =
            messageAnalyticsEntry?.hasHiddenWordActivity ?? false;

        if (globalIndex < startIndex) {
          tokenPositions.add(
            TokenPosition(
              start: globalIndex,
              end: startIndex,
              hideContent: false,
              highlight:
                  (isSelected?.call(token) ?? false) && !hasHiddenContent,
            ),
          );
        }

        tokenPositions.add(
          TokenPosition(
            start: startIndex,
            end: endIndex,
            token: token,
            hideContent: hideContent,
            highlight: (isSelected?.call(token) ?? false) &&
                !hideContent &&
                !hasHiddenContent,
          ),
        );
        globalIndex = endIndex;
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
