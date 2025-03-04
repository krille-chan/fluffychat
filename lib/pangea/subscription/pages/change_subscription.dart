import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/subscription/pages/settings_subscription.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ChangeSubscription extends StatelessWidget {
  final SubscriptionManagementController controller;
  ChangeSubscription({
    required this.controller,
    super.key,
  });

  final PangeaController pangeaController = MatrixState.pangeaController;

  List<SubscriptionDetails> get subscriptions =>
      pangeaController.subscriptionController.availableSubscriptionInfo
          ?.availableSubscriptions ??
      [];

  bool get inTrialWindow => pangeaController.userController.inTrialWindow();

  String get trialEnds => DateFormat.yMMMd()
      .format(DateTime.now().add(const Duration(days: kIsWeb ? 0 : 7)));

  @override
  Widget build(BuildContext context) {
    if (!controller.subscriptionsAvailable) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Column(
      spacing: 16.0,
      children: [
        Text(
          L10n.of(context).selectYourPlan,
          style: const TextStyle(fontSize: 16),
        ),
        Column(
          children: [
            for (final subscription in subscriptions)
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        subscription.displayName(context),
                      ),
                      trailing: Icon(
                        controller.selectedSubscription?.id != subscription.id
                            ? Icons.keyboard_arrow_right_outlined
                            : Icons.keyboard_arrow_down_outlined,
                      ),
                      enabled: (!subscription.isTrial || inTrialWindow) &&
                          !controller.isCurrentSubscription(subscription),
                      onTap: () => controller.selectSubscription(subscription),
                    ),
                    AnimatedSize(
                      duration: FluffyThemes.animationDuration,
                      child: controller.selectedSubscription?.id !=
                              subscription.id
                          ? const SizedBox()
                          : Column(
                              children: [
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 400.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0),
                                    ),
                                  ),
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      if (!kIsWeb)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(16.0),
                                              topRight: Radius.circular(16.0),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                L10n.of(context).startingToday,
                                              ),
                                              Text(
                                                L10n.of(context)
                                                    .oneWeekFreeTrial,
                                              ),
                                            ],
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              L10n.of(context)
                                                  .paidSubscriptionStarts(
                                                trialEnds,
                                              ),
                                            ),
                                            Text(
                                              "${subscription.displayPrice(context)}/${subscription.duration?.value}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 400.0,
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        L10n.of(context)
                                            .cancelInSubscriptionSettings,
                                      ),
                                      if (!kIsWeb)
                                        Text(
                                          L10n.of(context)
                                              .cancelToAvoidCharges(trialEnds),
                                        ),
                                      const SizedBox(height: 20.0),
                                      ElevatedButton(
                                        onPressed: () => controller
                                            .submitChange(subscription),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            controller.loading
                                                ? const CircularProgressIndicator
                                                    .adaptive()
                                                : Text(
                                                    subscription.isTrial
                                                        ? L10n.of(context)
                                                            .activateTrial
                                                        : L10n.of(context).pay,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
