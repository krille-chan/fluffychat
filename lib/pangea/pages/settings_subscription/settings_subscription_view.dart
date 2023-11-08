import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/pages/settings_subscription/change_subscription.dart';
import 'package:fluffychat/pangea/pages/settings_subscription/settings_subscription.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';

class SettingsSubscriptionView extends StatelessWidget {
  final SubscriptionManagementController controller;
  final PangeaController pangeaController = MatrixState.pangeaController;
  SettingsSubscriptionView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentSubscriptionTitle = pangeaController
            .subscriptionController.subscription?.currentSubscription
            ?.displayName(context) ??
        "";
    final String currentSubscriptionPrice = pangeaController
            .subscriptionController.subscription?.currentSubscription
            ?.displayPrice(context) ??
        "";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          L10n.of(context)!.subscriptionManagement,
        ),
      ),
      body: ListTileTheme(
        iconColor: Theme.of(context).textTheme.bodyLarge!.color,
        child: MaxWidthBody(
          child: !(pangeaController.subscriptionController.isSubscribed)
              ? ChangeSubscription(controller: controller)
              : Column(
                  children: [
                    if (pangeaController.subscriptionController.subscription!
                            .currentSubscription !=
                        null)
                      ListTile(
                        title: Text(L10n.of(context)!.currentSubscription),
                        subtitle: Text(currentSubscriptionTitle),
                        trailing: Text(currentSubscriptionPrice),
                      ),
                    Column(
                      children: [
                        ListTile(
                          title: Text(L10n.of(context)!.cancelSubscription),
                          enabled: controller.showManagementOptions,
                          onTap: () => controller.launchMangementUrl(
                            ManagementOption.cancel,
                          ),
                          trailing: const Icon(Icons.cancel_outlined),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: Text(L10n.of(context)!.paymentMethod),
                          trailing: const Icon(Icons.credit_card),
                          onTap: () => controller.launchMangementUrl(
                            ManagementOption.paymentMethod,
                          ),
                          enabled: controller.showManagementOptions,
                        ),
                        ListTile(
                          title: Text(L10n.of(context)!.paymentHistory),
                          trailing:
                              const Icon(Icons.keyboard_arrow_right_outlined),
                          onTap: () => controller.launchMangementUrl(
                            ManagementOption.history,
                          ),
                          enabled: controller.showManagementOptions,
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    if (!(controller.showManagementOptions))
                      ManagementNotAvailableWarning(
                        controller: controller,
                        subscriptionController:
                            pangeaController.subscriptionController,
                      )
                  ],
                ),
        ),
      ),
    );
  }
}

class ManagementNotAvailableWarning extends StatelessWidget {
  final SubscriptionManagementController controller;
  final SubscriptionController subscriptionController;

  const ManagementNotAvailableWarning({
    required this.controller,
    required this.subscriptionController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool currentSubscriptionAvailable =
        controller.currentSubscriptionAvailable;
    final bool currentSubscriptionIsPromotional =
        controller.currentSubscriptionIsPromotional;
    final String? purchasePlatformDisplayName =
        controller.purchasePlatformDisplayName;
    final bool isLifetimeSubscription =
        subscriptionController.subscription?.isLifetimeSubscription ?? false;
    final DateTime? expirationDate =
        subscriptionController.subscription?.expirationDate;

    String warningText = L10n.of(context)!.subscriptionManagementUnavailable;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    if (currentSubscriptionAvailable) {
      warningText = L10n.of(context)!.subsciptionPlatformTooltip;
    } else if (currentSubscriptionIsPromotional) {
      if (isLifetimeSubscription) {
        warningText = L10n.of(context)!.promotionalSubscriptionDesc;
      } else {
        warningText = L10n.of(context)!.promoSubscriptionExpirationDesc(
          formatter.format(expirationDate!),
        );
      }
    }

    return Center(
      child: Column(
        children: [
          Text(
            warningText,
            textAlign: TextAlign.center,
          ),
          if (purchasePlatformDisplayName != null)
            Text(
              "${L10n.of(context)!.originalSubscriptionPlatform} $purchasePlatformDisplayName",
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
