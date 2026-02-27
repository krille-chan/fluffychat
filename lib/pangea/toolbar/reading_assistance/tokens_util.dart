import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class _TokenPositionCacheItem {
  final List<TokenPosition> positions;
  final DateTime timestamp;

  _TokenPositionCacheItem(this.positions, this.timestamp);
}

class _NewTokenCacheItem {
  final List<PangeaTokenText> tokens;
  final DateTime timestamp;

  _NewTokenCacheItem(this.tokens, this.timestamp);
}

class TokenPosition {
  final PangeaToken? token;
  final int startIndex;
  final int endIndex;

  const TokenPosition({
    this.token,
    required this.startIndex,
    required this.endIndex,
  });

  Map<String, dynamic> toJson() => {
    'token': token?.toJson(),
    'startIndex': startIndex,
    'endIndex': endIndex,
  };
}

class TokensUtil {
  /// A cache of calculated adjacent token positions
  static final Map<String, _TokenPositionCacheItem> _tokenPositionCache = {};
  static final Map<String, _NewTokenCacheItem> _newTokenCache = {};
  static PangeaTokenText? _lastCollected;

  static const Duration _cacheDuration = Duration(minutes: 1);

  static List<PangeaTokenText>? _getCachedNewTokens(String cacheKey) {
    final cacheItem = _newTokenCache[cacheKey];
    if (cacheItem == null) return null;
    if (cacheItem.timestamp.isBefore(DateTime.now().subtract(_cacheDuration))) {
      _newTokenCache.remove(cacheKey);
      return null;
    }

    return cacheItem.tokens;
  }

  static void _setCachedNewTokens(
    String cacheKey,
    List<PangeaTokenText> tokens,
  ) {
    _newTokenCache[cacheKey] = _NewTokenCacheItem(tokens, DateTime.now());
  }

  static List<PangeaTokenText> getNewTokens(
    String cacheKey,
    List<PangeaToken> tokens,
    String tokensLangCode, {
    int? maxTokens,
  }) {
    if (MatrixState
        .pangeaController
        .matrixState
        .analyticsDataService
        .isInitializing) {
      return [];
    }

    final messageInUserL2 =
        tokensLangCode.split('-').first ==
        MatrixState.pangeaController.userController.userL2?.langCodeShort;

    final cached = _getCachedNewTokens(cacheKey);
    if (cached != null) {
      if (!messageInUserL2) {
        _newTokenCache.remove(cacheKey);
        return [];
      }
      return cached;
    }

    if (!messageInUserL2) return [];

    final List<PangeaTokenText> newTokens = [];
    final analyticsService =
        MatrixState.pangeaController.matrixState.analyticsDataService;

    for (final token in tokens) {
      final cId = token.vocabConstructID;
      if (!token.lemma.saveVocab || !cId.isContentWord) {
        continue;
      }

      if (analyticsService.hasUsedConstruct(cId) ||
          analyticsService.isConstructBlocked(cId)) {
        continue;
      }

      if (newTokens.any((t) => t == token.text)) continue;

      newTokens.add(token.text);
      if (maxTokens != null && newTokens.length >= maxTokens) break;
    }

    _setCachedNewTokens(cacheKey, newTokens);
    return newTokens;
  }

  static List<PangeaTokenText> getNewTokensByEvent(PangeaMessageEvent event) {
    if (!event.eventId.isValidMatrixId ||
        (MatrixState.pangeaController.subscriptionController.isSubscribed ==
            false) ||
        MatrixState
            .pangeaController
            .matrixState
            .analyticsDataService
            .isInitializing) {
      return [];
    }

    final messageInUserL2 =
        event.messageDisplayLangCode.split("-")[0] ==
        MatrixState.pangeaController.userController.userL2?.langCodeShort;

    final cached = _getCachedNewTokens(event.eventId);
    if (cached != null) {
      if (!messageInUserL2) {
        _newTokenCache.remove(event.eventId);
        return [];
      }
      return cached;
    }

    final tokens = event.messageDisplayRepresentation?.tokens;
    if (!messageInUserL2 || tokens == null || tokens.isEmpty) {
      return [];
    }

    return getNewTokens(
      event.eventId,
      tokens,
      event.messageDisplayLangCode,
      maxTokens: 3,
    );
  }

  static bool isNewTokenByEvent(PangeaToken token, PangeaMessageEvent event) {
    final newTokens = getNewTokensByEvent(event);
    return newTokens.any((t) => t == token.text);
  }

  static void clearNewTokenCache() {
    _newTokenCache.clear();
  }

  static void collectToken(String cachedKey, PangeaTokenText token) {
    _newTokenCache[cachedKey]?.tokens.remove(token);
    _lastCollected = token;
  }

  static bool isRecentlyCollected(PangeaTokenText token) =>
      _lastCollected == token;

  static void clearRecentlyCollected() => _lastCollected = null;

  static List<TokenPosition>? _getCachedTokenPositions(String cacheKey) {
    final cacheItem = _tokenPositionCache[cacheKey];
    if (cacheItem == null) return null;
    if (cacheItem.timestamp.isBefore(DateTime.now().subtract(_cacheDuration))) {
      _tokenPositionCache.remove(cacheKey);
      return null;
    }

    return cacheItem.positions;
  }

  static void _setCachedTokenPositions(
    String cacheKey,
    List<TokenPosition> positions,
  ) {
    _tokenPositionCache[cacheKey] = _TokenPositionCacheItem(
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
        bool punctPickup = true;
        while (nextToken != null &&
            currentToken?.end == nextToken.start &&
            punctPickup) {
          i++;
          currentToken = nextToken;
          nextToken = i < tokens.length - 1 ? tokens[i + 1] : null;
          punctPickup = nextToken?.pos == 'PUNCT';
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
  static List<TokenPosition> getGlobalTokenPositions(List<PangeaToken> tokens) {
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
          TokenPosition(startIndex: globalPointer, endIndex: token.text.offset),
        );

        globalPointer = token.text.offset;
      }

      // move the end index if the next token is right next to the current token
      // and either the current token is punctuation or the next token is punctuation
      while (endIndex < tokens.length - 1) {
        final PangeaToken currentToken = tokens[endIndex];
        final PangeaToken nextToken = tokens[endIndex + 1];

        final currentIsPunct =
            currentToken.pos == 'PUNCT' &&
            currentToken.text.content.trim().isNotEmpty;
        final nextIsPunct =
            nextToken.pos == 'PUNCT' &&
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
