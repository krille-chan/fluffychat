import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class MessageMeaningCard extends StatelessWidget {
  final MessageOverlayController controller;

  const MessageMeaningCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppConfig.toolbarMinWidth,
        maxHeight: AppConfig.toolbarMaxHeight,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_martial_arts,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: TextButton(
                  onPressed: () => controller.onRequestForMeaningChallenge(),
                  child: Text(
                    L10n.of(context).clickForMeaningActivity,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
