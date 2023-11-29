// Flutter imports:
// Project imports:
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SubscriptionOptions extends StatelessWidget {
  final PangeaController pangeaController;
  const SubscriptionOptions({
    super.key,
    required this.pangeaController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: pangeaController
            .subscriptionController.subscription!.availableSubscriptions
            .map(
              (subscription) => SubscriptionCard(
                subscription: subscription,
                pangeaController: pangeaController,
              ),
            )
            .toList(),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final SubscriptionDetails subscription;
  final PangeaController pangeaController;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.pangeaController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: AppConfig.primaryColorLight.withAlpha(64),
        ),
        borderRadius: const BorderRadius.all(Radius.zero),
      ),
      child: SizedBox(
        height: 250,
        width: AppConfig.columnWidth * 0.75,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                subscription.isTrial
                    ? L10n.of(context)!.oneWeekTrial
                    : subscription.displayName(context),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                subscription.displayPrice(context),
                textAlign: TextAlign.center,
              ),
              OutlinedButton(
                onPressed: () {
                  pangeaController.subscriptionController
                      .submitSubscriptionChange(subscription, context);
                },
                child: Text(L10n.of(context)!.subscribe),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
