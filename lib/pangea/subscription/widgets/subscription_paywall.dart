// Flutter imports:

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/subscription/widgets/subscription_options.dart';

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
        leading: const CloseButton(),
        title: Text(
          L10n.of(context).getAccess,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pangeaController.matrixState.client.rooms.length > 1) ...[
                Text(
                  L10n.of(context).welcomeBack,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
              ],
              Text(
                L10n.of(context).subscriptionDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              Center(
                child: SubscriptionOptions(
                  pangeaController: pangeaController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
