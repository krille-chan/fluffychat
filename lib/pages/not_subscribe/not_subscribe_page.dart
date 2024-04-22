import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tawkie/pages/not_subscribe/subscription_content.dart';

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
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SubscriptionContent(),
      ),
    );
  }

  // Method to redirect to the '/rooms' page
  void _redirectToRooms() {
    context.go('/rooms');
  }
}
