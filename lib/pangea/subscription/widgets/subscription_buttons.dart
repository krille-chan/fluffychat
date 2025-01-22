import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/subscription/pages/settings_subscription.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SubscriptionButtons extends StatelessWidget {
  final SubscriptionManagementController controller;
  final PangeaController pangeaController = MatrixState.pangeaController;
  SubscriptionButtons({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool inTrialWindow = pangeaController.userController.inTrialWindow();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.subscriptionController.availableSubscriptionInfo!
          .availableSubscriptions.length,
      itemBuilder: (BuildContext context, int i) {
        final SubscriptionDetails subscription = pangeaController
            .subscriptionController
            .availableSubscriptionInfo!
            .availableSubscriptions[i];
        return Column(
          children: [
            ListTile(
              title: Text(
                subscription.displayName(context),
              ),
              subtitle: Text(
                subscription.isTrial && !inTrialWindow
                    ? L10n.of(context).trialPeriodExpired
                    : subscription.displayPrice(context),
              ),
              trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              selected: controller.selectedSubscription == subscription,
              selectedTileColor:
                  Theme.of(context).colorScheme.secondary.withAlpha(16),
              enabled: (!subscription.isTrial || inTrialWindow) &&
                  !controller.isCurrentSubscription(subscription),
              onTap: () {
                controller.selectSubscription(subscription);
              },
            ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }
}
