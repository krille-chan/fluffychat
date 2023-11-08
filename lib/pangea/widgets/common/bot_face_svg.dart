import 'package:flutter/material.dart';

enum BotExpression { surprised, right, addled, left, down, shocked }

class BotFace extends StatelessWidget {
  const BotFace({
    Key? key,
    required this.width,
    required this.expression,
    this.forceColor,
  }) : super(key: key);

  final double width;
  final Color? forceColor;
  final BotExpression expression;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/pangea/bot_faces/${expression.toString().split('.').last}.png',
      // 'assets/pangea/bot_faces/surprised.png',
      width: width,
      height: width,
      // color: forceColor ??
      //     (Theme.of(context).brightness == Brightness.light
      //         ? Theme.of(context).colorScheme.primary
      //         : Theme.of(context).colorScheme.primary),
    );
  }
}

// extension ParseToString on BotExpressions {
//   String toShortString() {
//     return toString().split('.').last;
//   }
// }