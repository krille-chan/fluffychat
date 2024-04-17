import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/config/subscription.dart';
import 'package:tawkie/utils/platform_infos.dart';

class NotSubscribePage extends StatefulWidget {
  const NotSubscribePage({super.key});

  @override
  State<NotSubscribePage> createState() => _NotSubscribePageState();
}

class _NotSubscribePageState extends State<NotSubscribePage> {
  @override
  void initState() {
    super.initState();

    // Listener for subscription updates
    Purchases.addCustomerInfoUpdateListener((info) {
      if (info.entitlements.active.isNotEmpty) {
        //user has access to some entitlement
        _redirectToRooms();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          L10n.of(context)!.subscription,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              L10n.of(context)!.sub_subNeed,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (PlatformInfos.shouldInitializePurchase()) {
                  SubscriptionManager().checkSubscriptionStatusAndRedirect();
                } else {
                  // Todo: make purchases for Web, Windows and Linux
                }
              },
              child: Text(L10n.of(context)!.sub_payWallButton),
            ),
            const SizedBox(height: 20),
            if (PlatformInfos.shouldInitializePurchase())
              ElevatedButton(
                onPressed: () async {
                  await SubscriptionManager().restoreSub();
                },
                child: Text(L10n.of(context)!.sub_restore),
              ),
          ],
        ),
      ),
    );
  }

  // Method to redirect to the '/rooms' page
  void _redirectToRooms() {
    context.go('/rooms');
  }
}
