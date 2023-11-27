// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/utils/instructions.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../widgets/common/bot_face_svg.dart';
import '../controllers/choreographer.dart';
import '../controllers/it_controller.dart';

class ITCloseButton extends StatelessWidget {
  const ITCloseButton({
    Key? key,
    required this.choreographer,
  }) : super(key: key);

  final Choreographer choreographer;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close_outlined),
      onPressed: () {
        if (choreographer.itController.isEditingSourceText) {
          choreographer.itController.setIsEditingSourceText(false);
        } else {
          choreographer.itController.closeIT();
        }
      },
    );
  }
}

class ITBotButton extends StatelessWidget {
  const ITBotButton({Key? key, required this.choreographer}) : super(key: key);

  final Choreographer choreographer;

  @override
  Widget build(BuildContext context) {
    choreographer.pangeaController.instructions.show(
      context,
      InstructionsEnum.itInstructions,
      choreographer.itBotTransformTargetKey,
      true,
    );

    return IconButton(
      icon: const BotFace(width: 40.0, expression: BotExpression.right),
      onPressed: () => choreographer.pangeaController.instructions.show(
        context,
        InstructionsEnum.itInstructions,
        choreographer.itBotTransformTargetKey,
        false,
      ),
    );
  }
}

class ITRestartButton extends StatelessWidget {
  ITRestartButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ITController controller;
  final PangeaController pangeaController = MatrixState.pangeaController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        controller.choreographer.errorService.resetError();
        controller.currentITStep = null;
        controller.choreographer.getLanguageHelp();
      },
      icon: const Icon(Icons.refresh_outlined),
    );
  }
}
