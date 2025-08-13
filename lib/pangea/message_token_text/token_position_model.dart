import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';

class TokenPosition {
  final PangeaToken? token;
  final int startIndex;
  final int endIndex;

  const TokenPosition({
    this.token,
    required this.startIndex,
    required this.endIndex,
  });
}

class TokensUtil {
  /// A cache of calculated adjacent token positions
  static final Map<String, _TokenPositionCacheItem> _tokenPositionCache = {};

  static const Duration _cacheDuration = Duration(minutes: 1);

  static List<TokenPosition>? _getCachedTokenPositions(String eventID) {
    final cacheItem = _tokenPositionCache[eventID];
    if (cacheItem == null) return null;
    if (cacheItem.timestamp.isBefore(DateTime.now().subtract(_cacheDuration))) {
      _tokenPositionCache.remove(eventID);
      return null;
    }

    return cacheItem.positions;
  }

  static void _setCachedTokenPositions(
    String eventID,
    List<TokenPosition> positions,
  ) {
    _tokenPositionCache[eventID] = _TokenPositionCacheItem(
      positions,
      DateTime.now(),
    );
  }

  /// Given a list of tokens, returns a list of positions for tokens and adjacent punctuation
  /// This list may include gaps in the actual message for non-token elements,
  /// so should not be used to fully reconstruct the original message.
  static List<TokenPosition> getAdjacentTokenPositions(
    String eventID,
    List<PangeaToken> tokens,
  ) {
    final cached = _getCachedTokenPositions(eventID);
    if (cached != null) {
      return cached;
    }

    final List<TokenPosition> positions = [];
    for (int i = 0; i < tokens.length; i++) {
      final PangeaToken token = tokens[i];

      PangeaToken? currentToken = token;
      PangeaToken? nextToken = i < tokens.length - 1 ? tokens[i + 1] : null;

      final isPunct = token.pos == 'PUNCT';
      final nextIsPunct = nextToken?.pos == 'PUNCT';

      final int startIndex = i;
      if (isPunct || nextIsPunct) {
        while (nextToken != null && currentToken?.end == nextToken.start) {
          i++;
          currentToken = nextToken;
          nextToken = i < tokens.length - 1 ? tokens[i + 1] : null;
        }
      }

      final adjacentTokens = tokens.sublist(startIndex, i + 1);
      if (adjacentTokens.every((t) => t.pos == 'PUNCT')) {
        continue;
      }

      final position = TokenPosition(
        token: adjacentTokens.firstWhere((t) => t.pos != 'PUNCT'),
        startIndex: startIndex,
        endIndex: i,
      );
      positions.add(position);
    }

    _setCachedTokenPositions(eventID, positions);
    return positions;
  }

  /// Given a list of tokens, reconstructs an original message, including gaps for non-token elements.
  static List<TokenPosition> getGlobalTokenPositions(
    List<PangeaToken> tokens,
  ) {
    final List<TokenPosition> tokenPositions = [];
    int tokenPointer = 0;
    int globalPointer = 0;

    while (tokenPointer < tokens.length) {
      int endIndex = tokenPointer;
      PangeaToken token = tokens[tokenPointer];

      if (token.text.offset > globalPointer) {
        // If the token starts after the current global pointer, we need to
        // create a new token position for the gap
        tokenPositions.add(
          TokenPosition(
            startIndex: globalPointer,
            endIndex: token.text.offset,
          ),
        );

        globalPointer = token.text.offset;
      }

      // move the end index if the next token is right next to the current token
      // and either the current token is punctuation or the next token is punctuation
      while (endIndex < tokens.length - 1) {
        final PangeaToken currentToken = tokens[endIndex];
        final PangeaToken nextToken = tokens[endIndex + 1];

        final currentIsPunct = currentToken.pos == 'PUNCT' &&
            currentToken.text.content.trim().isNotEmpty;
        final nextIsPunct = nextToken.pos == 'PUNCT' &&
            nextToken.text.content.trim().isNotEmpty;

        if (currentToken.text.offset + currentToken.text.length !=
            nextToken.text.offset) {
          break;
        }

        if ((currentIsPunct && nextIsPunct) ||
            (currentIsPunct && nextToken.text.content.trim().isNotEmpty) ||
            (nextIsPunct && currentToken.text.content.trim().isNotEmpty)) {
          if (token.pos == 'PUNCT' && !nextIsPunct) {
            token = nextToken;
          }

          endIndex++;
        } else {
          break;
        }
      }

      tokenPositions.add(
        TokenPosition(
          token: token,
          startIndex: tokens[tokenPointer].text.offset,
          endIndex: tokens[endIndex].text.offset + tokens[endIndex].text.length,
        ),
      );

      // Move to the next token
      tokenPointer = tokenPointer + (endIndex - tokenPointer) + 1;
      globalPointer =
          tokens[endIndex].text.offset + tokens[endIndex].text.length;
    }

    return tokenPositions;
  }
}

class _TokenPositionCacheItem {
  final List<TokenPosition> positions;
  final DateTime timestamp;

  _TokenPositionCacheItem(
    this.positions,
    this.timestamp,
  );
}
