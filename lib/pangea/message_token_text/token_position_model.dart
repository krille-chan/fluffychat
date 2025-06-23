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
  static List<TokenPosition> getTokenPositions(
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
