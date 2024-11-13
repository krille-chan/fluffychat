import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MessageTokenText extends StatelessWidget {
  final PangeaController pangeaController = MatrixState.pangeaController;

  final bool ownMessage;

  /// this must match the tokens or we've got problems
  final String fullText;

  /// this must match the fullText or we've got problems
  final List<TokenWithDisplayInstructions>? tokensWithDisplay;
  final void Function(PangeaToken)? onClick;

  MessageTokenText({
    super.key,
    required this.ownMessage,
    required this.fullText,
    required this.tokensWithDisplay,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: ownMessage
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSurface,
      height: 1.3,
      fontSize: AppConfig.messageFontSize * AppConfig.fontSizeFactor,
    );

    if (tokensWithDisplay == null || tokensWithDisplay!.isEmpty) {
      return Text(
        fullText,
        style: style,
      );
    }

    // Convert the entire message into a list of characters
    final Characters messageCharacters = fullText.characters;

    // When building token positions, use grapheme cluster indices
    final List<TokenPosition> tokenPositions = [];
    int globalIndex = 0;

    for (int i = 0; i < tokensWithDisplay!.length; i++) {
      final tokenWithDisplay = tokensWithDisplay![i];
      final start = tokenWithDisplay.token.start;
      final end = tokenWithDisplay.token.end;

      // Calculate the number of grapheme clusters up to the start and end positions
      final int startIndex = messageCharacters.take(start).length;
      final int endIndex = messageCharacters.take(end).length;

      if (globalIndex < startIndex) {
        tokenPositions.add(TokenPosition(start: globalIndex, end: startIndex));
      }

      tokenPositions.add(
        TokenPosition(
          start: startIndex,
          end: endIndex,
          tokenIndex: i,
          token: tokenWithDisplay,
        ),
      );
      globalIndex = endIndex;
    }

    //TODO - take out of build function of every message
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
                ..onTap = () => onClick != null
                    ? onClick!(tokenPosition.token!.token)
                    : null,
              text: !tokenPosition.token!.hideContent ? substring : '_____',
              style: style.merge(
                TextStyle(
                  backgroundColor: tokenPosition.token!.highlight
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

class TokenWithDisplayInstructions {
  final PangeaToken token;
  final bool highlight;
  final bool hideContent;

  TokenWithDisplayInstructions({
    required this.token,
    required this.highlight,
    required this.hideContent,
  });
}

class TokenPosition {
  final int start;
  final int end;
  final TokenWithDisplayInstructions? token;
  final int tokenIndex;

  const TokenPosition({
    required this.start,
    required this.end,
    this.token,
    this.tokenIndex = -1,
  });
}
