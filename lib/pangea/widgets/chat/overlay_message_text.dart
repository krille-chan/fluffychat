import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
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
  final PangeaController pangeaController = MatrixState.pangeaController;
  List<PangeaToken>? tokens;

  @override
  void initState() {
    tokens = widget.pangeaMessageEvent.originalSent?.tokens;
    if (widget.pangeaMessageEvent.originalSent != null && tokens == null) {
      widget.pangeaMessageEvent.originalSent!
          .tokensGlobal(context)
          .then((tokens) {
        // this isn't currently working because originalSent's _event is null
        setState(() => this.tokens = tokens);
      });
    }
    super.initState();
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

    if (tokens == null || tokens!.isEmpty) {
      return Text(
        widget.pangeaMessageEvent.event.calcLocalizedBodyFallback(
          MatrixLocals(L10n.of(context)!),
          hideReply: true,
        ),
        style: style,
      );
    }

    int lastEnd = 0;
    final List<TokenPosition> tokenPositions = [];

    for (int i = 0; i < tokens!.length; i++) {
      final token = tokens![i];
      final start = token.start;
      final end = token.end;

      if (lastEnd < start) {
        tokenPositions.add(TokenPosition(start: lastEnd, end: start));
      }

      tokenPositions.add(
        TokenPosition(
          start: start,
          end: end,
          tokenIndex: i,
          token: token,
        ),
      );
      lastEnd = end;
    }

    //TODO - take out of build function of every message
    return RichText(
      text: TextSpan(
        children: tokenPositions.map((tokenPosition) {
          if (tokenPosition.token != null) {
            final isSelected =
                widget.overlayController.isTokenSelected(tokenPosition.token!);
            return TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print(
                    'tokenPosition.tokenIndex: ${tokenPosition.tokenIndex}',
                  );
                  widget.overlayController.onClickOverlayMessageToken(
                    tokenPosition.token!,
                  );
                  setState(() {});
                },
              text: tokenPosition.token!.text.content,
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
              text: widget.pangeaMessageEvent.event.body.substring(
                tokenPosition.start,
                tokenPosition.end,
              ),
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
