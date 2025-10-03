import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';

class ActivityFeedbackResponseDialog extends StatelessWidget {
  final String feedback;
  const ActivityFeedbackResponseDialog({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SizedBox(
          width: 325.0,
          child: Column(
            spacing: 20.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        L10n.of(context).feedbackTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                        child: Icon(Icons.flag_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  spacing: 20.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BotFace(
                      width: 60.0,
                      expression: BotExpression.idle,
                    ),
                    Text(
                      feedback,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      L10n.of(context).feedbackRespDesc,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
