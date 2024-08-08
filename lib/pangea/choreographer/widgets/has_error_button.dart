import 'package:flutter/material.dart';

import '../../controllers/pangea_controller.dart';
import '../controllers/error_service.dart';

class ChoreographerHasErrorButton extends StatelessWidget {
  final ChoreoError error;
  final PangeaController pangeaController;

  const ChoreographerHasErrorButton(
    this.pangeaController,
    this.error, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (error.type == ChoreoErrorType.unknown) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              content: Text(
                "${error.title(context)} ${error.description(context)}",
              ),
            ),
          );
        }
      },
      mini: true,
      child: Icon(error.icon),
    );
  }
}
