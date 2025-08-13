import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/message_token_text/token_position_model.dart';
import 'package:fluffychat/pangea/toolbar/models/speech_to_text_models.dart';

class SttTranscriptTokens extends StatelessWidget {
  final SpeechToTextModel model;
  final TextStyle? style;

  final void Function(PangeaToken)? onClick;
  final bool Function(PangeaToken)? isSelected;

  const SttTranscriptTokens({
    super.key,
    required this.model,
    this.onClick,
    this.isSelected,
    this.style,
  });

  List<PangeaToken> get tokens =>
      model.transcript.sttTokens.map((t) => t.token).toList();

  @override
  Widget build(BuildContext context) {
    if (model.transcript.sttTokens.isEmpty) {
      return Text(
        model.transcript.text,
        style: style ?? DefaultTextStyle.of(context).style,
        textScaler: TextScaler.noScaling,
      );
    }

    final messageCharacters = model.transcript.text.characters;
    return RichText(
      textScaler: TextScaler.noScaling,
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children:
            TokensUtil.getGlobalTokenPositions(tokens).map((tokenPosition) {
          final text = messageCharacters
              .skip(tokenPosition.startIndex)
              .take(tokenPosition.endIndex - tokenPosition.startIndex)
              .toString();

          if (tokenPosition.token == null) {
            return TextSpan(
              text: text,
              style: style ?? DefaultTextStyle.of(context).style,
            );
          }

          final token = tokenPosition.token!;
          final selected = isSelected?.call(token) ?? false;

          return WidgetSpan(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onClick != null ? () => onClick?.call(token) : null,
                child: RichText(
                  text: TextSpan(
                    text: text,
                    style:
                        (style ?? DefaultTextStyle.of(context).style).copyWith(
                      decoration: TextDecoration.underline,
                      decorationThickness: 4,
                      decorationColor: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white.withAlpha(0),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
