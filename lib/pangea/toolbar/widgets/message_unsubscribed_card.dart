import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/widgets/matrix.dart';

class MessageUnsubscribedCard extends StatelessWidget {
  const MessageUnsubscribedCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
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
