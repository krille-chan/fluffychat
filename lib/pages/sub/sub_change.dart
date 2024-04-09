import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';

class SubscriptionChangePage extends StatelessWidget {
  final Offerings? offerings;
  final String activeSubscriptionId;

  const SubscriptionChangePage({
    super.key,
    required this.offerings,
    required this.activeSubscriptionId,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> activeSubscriptionCards = [];
    List<Widget> inactiveSubscriptionCards = [];

    if (offerings != null) {
      for (final package in offerings!.current!.availablePackages) {
        final isActive =
            package.storeProduct.identifier == activeSubscriptionId;
        final card = SubscriptionCard(
          name: package.storeProduct.title,
          price: package.storeProduct.price.toString(),
          description: package.storeProduct.description,
          isActive: isActive,
        );
        if (isActive) {
          activeSubscriptionCards.add(card);
        } else {
          inactiveSubscriptionCards.add(card);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        if (activeSubscriptionCards.isNotEmpty) ...activeSubscriptionCards,
        const SizedBox(height: 20),
        Text(
          'Tous les abonnements disponibles :',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        if (inactiveSubscriptionCards.isNotEmpty) ...inactiveSubscriptionCards,
      ],
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final bool isActive;

  const SubscriptionCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          isActive
              ? Text(
                  'Statut : Actif',
                  style: TextStyle(fontSize: 16, color: Colors.green),
                )
              : Container(),
        ],
      ),
    );
  }
}
