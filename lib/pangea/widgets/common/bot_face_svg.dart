import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

enum BotExpression { gold, nonGold, addled, idle, surprised }

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
  StateMachineController? _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadRiveFile().then((_) => _scheduleNextRun());
  }

  @override
  void didUpdateWidget(BotFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expression != widget.expression) {
      _controller!.setInputValue(
        _controller!.stateMachine.inputs[0].id,
        mapExpressionToInput(widget.expression),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _scheduleNextRun() {
    final int nextInterval =
        _random.nextInt(21) + 20; // Random interval between 20-40 seconds

    Future.delayed(Duration(seconds: nextInterval), () {
      if (mounted) {
        _loadRiveFile();
        _scheduleNextRun();
      }
    });
  }

  double mapExpressionToInput(BotExpression expression) {
    switch (expression) {
      case BotExpression.gold:
        return 1.0;
      case BotExpression.nonGold:
        return 2.0;
      case BotExpression.surprised:
        return 3.0;
      case BotExpression.addled:
        return 4.0;
      default:
        return 0.0;
    }
  }

  Future<void> _loadRiveFile() async {
    final riveFile =
        await RiveFile.asset('assets/pangea/bot_faces/pangea_bot.riv');

    final artboard = riveFile.mainArtboard;
    _controller =
        StateMachineController.fromArtboard(artboard, 'BotIconStateMachine');

    if (_controller != null) {
      artboard.addController(_controller!);
      _controller!.setInputValue(
        _controller!.stateMachine.inputs[0].id,
        mapExpressionToInput(widget.expression),
      );
    }

    if (mounted) {
      setState(() {
        _artboard = artboard;
      });
    }
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
