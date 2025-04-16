import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../controllers/it_controller.dart';

class ITRestartButton extends StatelessWidget {
  ITRestartButton({
    super.key,
    required this.controller,
  });

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
