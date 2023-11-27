// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fluffychat/config/app_config.dart';
import '../../../widgets/matrix.dart';
import '../../utils/bot_style.dart';
import '../common/bot_face_svg.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({
    Key? key,
    required this.text,
    required this.botExpression,
    this.onClose,
  }) : super(key: key);

  final BotExpression botExpression;
  final String text;
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: BotFace(
              width: 50.0,
              expression: botExpression,
            ),
          ),
          const SizedBox(width: 5.0),
          Expanded(
            child: Text(
              text,
              style: BotStyle.text(context),
              textAlign: TextAlign.left,
            ),
          ),
          CircleAvatar(
            backgroundColor: AppConfig.primaryColor.withOpacity(0.1),
            child: IconButton(
              icon: const Icon(Icons.close_outlined),
              onPressed: () {
                if (onClose != null) onClose!();
                MatrixState.pAnyState.closeOverlay();
              },
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppConfig.primaryColorLight
                  : AppConfig.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
