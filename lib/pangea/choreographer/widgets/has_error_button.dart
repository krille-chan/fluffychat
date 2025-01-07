import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import '../controllers/error_service.dart';

class ChoreographerHasErrorButton extends StatelessWidget {
  final ChoreoError error;
  final Choreographer choreographer;

  const ChoreographerHasErrorButton(
    this.error,
    this.choreographer, {
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
          choreographer.errorService.resetError();
        }
      },
      mini: true,
      child: Icon(error.icon),
    );
  }
}
