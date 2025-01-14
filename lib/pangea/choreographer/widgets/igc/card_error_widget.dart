import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/card_header.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';

class CardErrorWidget extends StatelessWidget {
  final Object error;
  final Choreographer? choreographer;
  final int? offset;
  final double maxWidth;
  final double padding;

  const CardErrorWidget({
    super.key,
    required this.error,
    this.choreographer,
    this.offset,
    this.maxWidth = 275,
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    final ErrorCopy errorCopy = ErrorCopy(context, error);

    return Container(
      padding: EdgeInsets.all(padding),
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CardHeader(
            text: errorCopy.title,
            botExpression: BotExpression.addled,
            onClose: () => choreographer?.onMatchError(
              cursorOffset: offset,
            ),
          ),
          const SizedBox(height: 6.0),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              errorCopy.body,
              style: BotStyle.text(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
