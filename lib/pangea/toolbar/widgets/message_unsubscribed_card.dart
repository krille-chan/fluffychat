import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/widgets/matrix.dart';

class MessageUnsubscribedCard extends StatelessWidget {
  final MessageOverlayController controller;

  const MessageUnsubscribedCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool inTrialWindow =
        MatrixState.pangeaController.userController.inTrialWindow();

    return Container(
      constraints: const BoxConstraints(
        maxWidth: AppConfig.toolbarMinWidth,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            style: BotStyle.text(context),
            L10n.of(context).subscribedToUnlockTools,
            textAlign: TextAlign.center,
          ),
          if (inTrialWindow) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  MatrixState.pangeaController.subscriptionController
                      .activateNewUserTrial();
                  controller.updateToolbarMode(controller.toolbarMode);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    (Theme.of(context).colorScheme.primary).withAlpha(25),
                  ),
                ),
                child: Text(L10n.of(context).activateTrial),
              ),
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                controller.widget.chatController.clearSelectedEvents();
                MatrixState.pangeaController.subscriptionController
                    .showPaywall(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  (Theme.of(context).colorScheme.primary).withAlpha(25),
                ),
              ),
              child: Text(L10n.of(context).getAccess),
            ),
          ),
        ],
      ),
    );
  }
}
