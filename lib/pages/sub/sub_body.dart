import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  CustomerInfo? customerInfo;
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      Offerings offerings = await Purchases.getOfferings();
      setState(() {
        _offerings = offerings;
      });
    } on PlatformException catch (e) {
      // optional error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer mon abonnement'),
      ),
      body: Center(
        child: _offerings != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vos abonnements disponibles :',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  for (final package in _offerings!.current!.availablePackages)
                    SubscriptionCard(
                        name: package.storeProduct.title,
                        price: package.storeProduct.price.toString(),
                        isActive: customerInfo?.activeSubscriptions.single ==
                            package.storeProduct.identifier),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String name;
  final String price;
  final bool isActive;

  SubscriptionCard(
      {required this.name, required this.price, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Prix : $price',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
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
