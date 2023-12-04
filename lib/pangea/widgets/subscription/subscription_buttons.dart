import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/pages/settings_subscription/settings_subscription.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SubscriptionButtons extends StatelessWidget {
  final SubscriptionManagementController controller;
  final PangeaController pangeaController = MatrixState.pangeaController;
  SubscriptionButtons({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: pangeaController
          .subscriptionController.subscription!.availableSubscriptions.length,
      itemBuilder: (BuildContext context, int i) => Column(
        children: [
          ListTile(
            title: pangeaController.subscriptionController.subscription!
                    .availableSubscriptions[i].isTrial
                ? Text(L10n.of(context)!.oneWeekTrial)
                : Text(
                    pangeaController.subscriptionController.subscription!
                        .availableSubscriptions[i]
                        .displayName(context),
                  ),
            subtitle: Text(
              pangeaController.subscriptionController.subscription!
                  .availableSubscriptions[i]
                  .displayPrice(context),
            ),
            trailing: const Icon(Icons.keyboard_arrow_right_outlined),
            selected: controller.selectedSubscription ==
                pangeaController.subscriptionController.subscription!
                    .availableSubscriptions[i],
            selectedTileColor:
                Theme.of(context).colorScheme.secondary.withAlpha(16),
            onTap: () {
              final SubscriptionDetails selected = pangeaController
                  .subscriptionController
                  .subscription!
                  .availableSubscriptions[i];
              controller.selectSubscription(selected);
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
