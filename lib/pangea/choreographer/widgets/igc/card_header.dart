import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../bot/widgets/bot_face_svg.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({
    super.key,
    required this.text,
    required this.botExpression,
    this.onClose,
  });

  final BotExpression botExpression;
  final String text;
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                BotFace(
                  width: 50.0,
                  expression: botExpression,
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  child: Text(
                    text,
                    style: BotStyle.text(context),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5.0),
          IconButton(
            icon: const Icon(Icons.close_outlined),
            onPressed: () {
              if (onClose != null) onClose!();
              MatrixState.pAnyState.closeOverlay();
            },
          ),
        ],
      ),
    );
  }
}
