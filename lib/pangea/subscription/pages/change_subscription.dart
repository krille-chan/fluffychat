import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/subscription/pages/settings_subscription.dart';
import 'package:fluffychat/pangea/subscription/widgets/subscription_buttons.dart';
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
    return controller.subscriptionsAvailable
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                L10n.of(context).selectYourPlan,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              const Divider(height: 1),
              SubscriptionButtons(controller: controller),
              const SizedBox(height: 32),
              IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      onPressed: controller.selectedSubscription != null
                          ? () => controller.submitChange()
                          : null,
                      child: controller.loading
                          ? const CircularProgressIndicator.adaptive()
                          : Text(
                              controller.selectedSubscription?.isTrial ?? false
                                  ? L10n.of(context).activateTrial
                                  : L10n.of(context).pay,
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          )
        : const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
              ),
            ),
          );
  }
}
