// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

// Project imports:
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/pages/settings_subscription/settings_subscription.dart';
import 'package:fluffychat/pangea/widgets/subscription/subscription_buttons.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ChangeSubscription extends StatelessWidget {
  final SubscriptionManagementController controller;
  ChangeSubscription({
    required this.controller,
    super.key,
  });

  final PangeaController pangeaController = MatrixState.pangeaController;

  @override
  Widget build(BuildContext context) {
    void submitChange({bool isPromo = false}) {
      try {
        pangeaController.subscriptionController.submitSubscriptionChange(
          controller.selectedSubscription,
          context,
          isPromo: isPromo,
        );
      } catch (err) {
        showOkAlertDialog(
          context: context,
          title: L10n.of(context)!.oopsSomethingWentWrong,
          message: L10n.of(context)!.errorPleaseRefresh,
          okLabel: L10n.of(context)!.close,
        );
      }
    }

    return pangeaController.subscriptionController.subscription != null &&
            pangeaController.subscriptionController.subscription!
                .availableSubscriptions.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                L10n.of(context)!.selectYourPlan,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              const Divider(height: 1),
              SubscriptionButtons(controller: controller),
              const SizedBox(height: 32),
              if (controller.selectedSubscription != null)
                IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton(
                        onPressed: () => submitChange(),
                        child: Text(L10n.of(context)!.pay),
                      ),
                      const SizedBox(height: 10),
                      if (kIsWeb)
                        OutlinedButton(
                          onPressed: () => submitChange(isPromo: true),
                          child: Text(L10n.of(context)!.redeemPromoCode),
                        ),
                    ],
                  ),
                ),
              // if (controller.selectedSubscription != null && Platform.isIOS)
              //   TextButton(
              //     onPressed: () {
              //       try {
              //         pangeaController.subscriptionController
              //             .redeemPromoCode(context);
              //       } catch (err) {
              //         showOkAlertDialog(
              //           context: context,
              //           title: L10n.of(context)!.oopsSomethingWentWrong,
              //           message: L10n.of(context)!.errorPleaseRefresh,
              //           okLabel: L10n.of(context)!.close,
              //         );
              //       }
              //     },
              //     child: Text(L10n.of(context)!.redeemPromoCode),
              //   )
            ],
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(L10n.of(context)!.oopsSomethingWentWrong),
                Text(L10n.of(context)!.errorPleaseRefresh),
              ],
            ),
          );
  }
}
