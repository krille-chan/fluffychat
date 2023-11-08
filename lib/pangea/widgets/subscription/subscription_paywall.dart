import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/widgets/subscription/subscription_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SubscriptionPaywall extends StatelessWidget {
  final PangeaController pangeaController;
  const SubscriptionPaywall({
    Key? key,
    required this.pangeaController,
  }) : super(key: key);

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
        child: Column(
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
            SubscriptionOptions(
              pangeaController: pangeaController,
            ),
          ],
        ),
      ),
    );
  }
}
