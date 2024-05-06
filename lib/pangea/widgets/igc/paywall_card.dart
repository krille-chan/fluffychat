import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/widgets/common/bot_face_svg.dart';
import 'package:fluffychat/pangea/widgets/igc/card_header.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class PaywallCard extends StatelessWidget {
  const PaywallCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool inTrialWindow =
        MatrixState.pangeaController.userController.inTrialWindow;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CardHeader(
          text: L10n.of(context)!.subscriptionPopupTitle,
          botExpression: BotExpression.addled,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10n.of(context)!.subscriptionPopupDesc,
                style: BotStyle.text(context),
                textAlign: TextAlign.center,
              ),
              Text(
                L10n.of(context)!.noPaymentInfo,
                style: BotStyle.text(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    inTrialWindow
                        ? MatrixState.pangeaController.subscriptionController
                            .activateNewUserTrial()
                        : MatrixState.pangeaController.subscriptionController
                            .showPaywall(context);
                    MatrixState.pAnyState.closeOverlay();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      (AppConfig.primaryColor).withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    inTrialWindow
                        ? L10n.of(context)!.activateTrial
                        : L10n.of(context)!.seeOptions,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      AppConfig.primaryColor.withOpacity(0.1),
                    ),
                  ),
                  onPressed: () {
                    MatrixState.pangeaController.subscriptionController
                        .dismissPaywall();
                    MatrixState.pAnyState.closeOverlay();
                  },
                  child: Center(
                    child: Text(L10n.of(context)!.continuedWithoutSubscription),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
