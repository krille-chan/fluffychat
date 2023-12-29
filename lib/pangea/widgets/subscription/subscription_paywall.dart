// Flutter imports:

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/widgets/subscription/subscription_options.dart';

class SubscriptionPaywall extends StatelessWidget {
  final PangeaController pangeaController;
  const SubscriptionPaywall({
    super.key,
    required this.pangeaController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: CloseButton(onPressed: Navigator.of(context).pop),
        title: Text(
          L10n.of(context)!.getAccess,
          style: const TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            if (pangeaController.matrixState.client.rooms.length > 1) ...[
              Text(
                L10n.of(context)!.welcomeBack,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              L10n.of(context)!.subscriptionDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            pangeaController.userController.inTrialWindow
                ? FreeTrialCard(
                    pangeaController: pangeaController,
                  )
                : SubscriptionOptions(
                    pangeaController: pangeaController,
                  ),
          ],
        ),
      ),
    );
  }
}

class FreeTrialCard extends StatelessWidget {
  final PangeaController pangeaController;
  const FreeTrialCard({super.key, required this.pangeaController});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Card(
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
                  L10n.of(context)!.freeTrial,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  L10n.of(context)!.freeTrialDesc,
                  textAlign: TextAlign.center,
                ),
                OutlinedButton(
                  onPressed: () {
                    pangeaController.subscriptionController
                        .activateNewUserTrial();
                    Navigator.of(context).pop();
                  },
                  child: Text(L10n.of(context)!.activateTrial),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
