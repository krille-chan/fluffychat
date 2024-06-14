import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

enum BotExpression { surprised, right, addled, left, down, shocked }

class BotFace extends StatefulWidget {
  final double width;
  final Color? forceColor;
  final BotExpression expression;

  const BotFace({
    super.key,
    required this.width,
    required this.expression,
    this.forceColor,
  });

  @override
  BotFaceState createState() => BotFaceState();
}

class BotFaceState extends State<BotFace> {
  Artboard? _artboard;
  SMINumber? _input;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  double mapExpressionToInput(BotExpression expression) {
    switch (expression) {
      case BotExpression.surprised:
        return 1.0;
      case BotExpression.right:
        return 2.0;
      case BotExpression.shocked:
        return 3.0;
      case BotExpression.addled:
        return 4.0;
      default:
        return 0.0;
    }
  }

  Future<void> _loadRiveFile() async {
    final riveFile = await RiveFile.asset('assets/pangea/bot_faces/pangea_bot.riv');

    final artboard = riveFile.mainArtboard;
    final controller = StateMachineController
        .fromArtboard(artboard, 'BotIconStateMachine');

    if (controller != null) {
      artboard.addController(controller);
      _input = controller.findInput("Enter State") as SMINumber?;
      controller.setInputValue(
        890,  // this should be the id of the input
        mapExpressionToInput(widget.expression),
      );
    }

    setState(() {
      _artboard = artboard;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: widget.width,
      height: widget.width,
      child: _artboard != null
        ? Rive(
          artboard: _artboard!,
          fit: BoxFit.cover,
        )
        : Container(),
    );
  }
}

// extension ParseToString on BotExpressions {
//   String toShortString() {
//     return toString().split('.').last;
//   }
// }
