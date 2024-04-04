import 'package:flutter/material.dart';
import 'package:tawkie/config/subscription.dart';
import 'package:tawkie/utils/platform_infos.dart';

class NotSubscribePage extends StatelessWidget {
  const NotSubscribePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Vous devez avoir un abonnement pour utiliser l\'application.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (PlatformInfos.shouldInitializePurchase()) {
                  SubscriptionManager().checkSubscriptionStatusAndRedirect();
                } else {
                  // Todo: make purchases for Web, Windows and Linux
                }
              },
              child: Text('Souscrire à un abonnement'),
            ),
          ],
        ),
      ),
    );
  }
}
