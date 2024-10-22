import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/common/bot_face_svg.dart';
import 'package:fluffychat/pangea/widgets/igc/card_header.dart';
import 'package:flutter/material.dart';

class CardErrorWidget extends StatelessWidget {
  final Object? error;
  final Choreographer? choreographer;
  final int? offset;
  const CardErrorWidget({
    super.key,
    this.error,
    this.choreographer,
    this.offset,
  });

  @override
  Widget build(BuildContext context) {
    final ErrorCopy errorCopy = ErrorCopy(context, error);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CardHeader(
            text: errorCopy.title,
            botExpression: BotExpression.addled,
            onClose: () => choreographer?.onMatchError(
              cursorOffset: offset,
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: Text(
              errorCopy.body,
              style: BotStyle.text(context),
            ),
          ),
        ],
      ),
    );
  }
}
