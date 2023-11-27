// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/common/bot_face_svg.dart';
import 'package:fluffychat/pangea/widgets/igc/card_header.dart';

class CardErrorWidget extends StatelessWidget {
  final Object? error;
  final Choreographer? choreographer;
  final int? offset;
  const CardErrorWidget({
    Key? key,
    this.error,
    this.choreographer,
    this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ErrorCopy errorCopy = ErrorCopy(context, error);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CardHeader(
            text: errorCopy.title,
            botExpression: BotExpression.addled,
            onClose: () => choreographer != null
                ? choreographer!.onMatchError(
                    cursorOffset: offset,
                  )
                : null,
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
