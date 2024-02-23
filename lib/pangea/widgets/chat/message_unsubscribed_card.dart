import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class MessageUnsubscribedCard extends StatelessWidget {
  final String languageTool;

  const MessageUnsubscribedCard({
    super.key,
    required this.languageTool,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          Text(
            style: BotStyle.text(context),
            "${L10n.of(context)!.subscribedToUnlockTools} $languageTool",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                MatrixState.pangeaController.subscriptionController
                    .showPaywall(context);
                MatrixState.pAnyState.closeOverlay();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  (AppConfig.primaryColor).withOpacity(0.1),
                ),
              ),
              child: Text(L10n.of(context)!.getAccess),
            ),
          ),
        ],
      ),
    );
  }
}
