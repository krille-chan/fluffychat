import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';

class SubscriptionChangePage extends StatelessWidget {
  final Offerings? offerings;
  final String activeSubscriptionId;

  const SubscriptionChangePage(
      {super.key, required this.offerings, required this.activeSubscriptionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Changer de forfait'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tous les abonnements disponibles :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (offerings != null)
              Column(
                children: [
                  for (final package in offerings!.current!.availablePackages)
                    SubscriptionCard(
                      name: package.storeProduct.title,
                      price: package.storeProduct.price.toString(),
                      description: package.storeProduct.description,
                      isActive: package.storeProduct.identifier ==
                          activeSubscriptionId,
                    ),
                ],
              ),
          ],
        ),
      ),
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
            Text(
              isActive ? 'Statut : Actif' : 'Statut : Inactif',
              style: TextStyle(
                  fontSize: 16, color: isActive ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
