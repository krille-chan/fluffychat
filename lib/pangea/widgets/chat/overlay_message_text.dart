import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class OverlayMessageText extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overlayController;

  const OverlayMessageText({
    super.key,
    required this.pangeaMessageEvent,
    required this.overlayController,
  });

  @override
  OverlayMessageTextState createState() => OverlayMessageTextState();
}

class OverlayMessageTextState extends State<OverlayMessageText> {
  List<PangeaToken>? _tokens;

  @override
  void initState() {
    super.initState();
    _setTokens();
  }

  Future<void> _setTokens() async {
    final repEvent = widget.pangeaMessageEvent.messageDisplayRepresentation;
    if (repEvent != null) {
      _tokens = repEvent.tokens;
      _tokens ??= await repEvent.tokensGlobal(
        widget.pangeaMessageEvent.senderId,
        widget.pangeaMessageEvent.originServerTs,
      );
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ownMessage = widget.pangeaMessageEvent.event.senderId ==
        Matrix.of(context).client.userID;

    final style = TextStyle(
      color: ownMessage
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.onSurface,
      height: 1.3,
      fontSize: AppConfig.messageFontSize * AppConfig.fontSizeFactor,
    );

    if (_tokens == null || _tokens!.isEmpty) {
      return Text(
        widget.pangeaMessageEvent.event.calcLocalizedBodyFallback(
          MatrixLocals(L10n.of(context)),
          hideReply: true,
        ),
        style: style,
      );
    }

    // Convert the entire message into a list of characters
    final Characters messageCharacters =
        widget.pangeaMessageEvent.messageDisplayText.characters;

    // When building token positions, use grapheme cluster indices
    // We use grapheme cluster indices to avoid splitting emojis and other
    // complex characters that requires multiple code units.
    // For instance, the emoji 🇺🇸 is represented by two code units:
    // - \u{1F1FA}
    // - \u{1F1F8}
    final List<TokenPosition> tokenPositions = [];
    int globalIndex = 0;

    for (int i = 0; i < _tokens!.length; i++) {
      final token = _tokens![i];
      final start = token.start;
      final end = token.end;

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
          token: token,
        ),
      );
      globalIndex = endIndex;
    }

    // debug prints for fixing words sticking together
    // void printEscapedString(String input) {
    //   // Escaped string using Unicode escape sequences
    //   final String escapedString = input.replaceAllMapped(
    //     RegExp(r'[^\w\s]', unicode: true),
    //     (match) {
    //       final codeUnits = match.group(0)!.runes;
    //       String unicodeEscapes = '';
    //       for (final rune in codeUnits) {
    //         unicodeEscapes += '\\u{${rune.toRadixString(16)}}';
    //       }
    //       return unicodeEscapes;
    //     },
    //   );
    //   print("Escaped String: $escapedString");

    //   // Printing each character with its index
    //   int index = 0;
    //   for (final char in input.characters) {
    //     print("Index $index: $char");
    //     index++;
    //   }
    // }

    //TODO - take out of build function of every message
    return RichText(
      text: TextSpan(
        children: tokenPositions.map((tokenPosition) {
          final substring = messageCharacters
              .skip(tokenPosition.start)
              .take(tokenPosition.end - tokenPosition.start)
              .toString();

          if (tokenPosition.token != null) {
            final isSelected =
                widget.overlayController.isTokenSelected(tokenPosition.token!);
            return TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  debugPrint(
                    'tokenPosition.tokenIndex: ${tokenPosition.tokenIndex}',
                  );
                  widget.overlayController.onClickOverlayMessageToken(
                    tokenPosition.token!,
                  );
                  if (mounted) setState(() {});
                },
              text: substring,
              style: style.merge(
                TextStyle(
                  backgroundColor: isSelected
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
  final PangeaToken? token;
  final int tokenIndex;

  const TokenPosition({
    required this.start,
    required this.end,
    this.token,
    this.tokenIndex = -1,
  });
}
