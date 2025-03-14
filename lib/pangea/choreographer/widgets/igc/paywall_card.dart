import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/card_header.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PaywallCard extends StatelessWidget {
  final ChatController chatController;
  const PaywallCard({
    super.key,
    required this.chatController,
  });

  @override
  Widget build(BuildContext context) {
    final bool inTrialWindow =
        MatrixState.pangeaController.userController.inTrialWindow();

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CardHeader(
          text: L10n.of(context).clickMessageTitle,
          botExpression: BotExpression.addled,
          onClose: () {
            MatrixState.pangeaController.subscriptionController
                .dismissPaywall();
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                L10n.of(context).subscribedToUnlockTools,
                style: BotStyle.text(context),
                textAlign: TextAlign.center,
              ),
              // if (inTrialWindow)
              //   Text(
              //     L10n.of(context).noPaymentInfo,
              //     style: BotStyle.text(context),
              //     textAlign: TextAlign.center,
              //   ),
              if (inTrialWindow) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      MatrixState.pangeaController.subscriptionController
                          .activateNewUserTrial();
                      MatrixState.pAnyState.closeOverlay();
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
                    chatController.clearSelectedEvents();
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
        ),
      ],
    );
  }
}
