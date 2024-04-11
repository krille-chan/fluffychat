import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tawkie/pages/sub/sub_change.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
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
        this.customerInfo = customerInfo;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_offerings!.current!.availablePackages.isNotEmpty)
                    _buildActiveSubscriptionWidget(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionChangePage(
                                  offerings: _offerings,
                                  activeSubscriptionId:
                                      _findActiveSubscriptionId(customerInfo)!,
                                )),
                      );
                    },
                    child: Text('Changer de forfait'),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildActiveSubscriptionWidget() {
    final activePackage =
        _offerings!.current!.availablePackages.firstWhereOrNull(
      (package) => _isSubscriptionActive(package.storeProduct.identifier),
    );
    if (activePackage != null) {
      return SubscriptionCard(
        name: activePackage.storeProduct.title,
        price: activePackage.storeProduct.price.toString(),
        description: activePackage.storeProduct.description,
        isActive: true,
      );
    } else {
      return const SizedBox.shrink(); // If not sub
    }
  }

  bool _isSubscriptionActive(String packageIdentifier) {
    if (customerInfo != null && customerInfo!.activeSubscriptions.isNotEmpty) {
      final active =
          customerInfo!.activeSubscriptions.contains(packageIdentifier);
      return active;
    } else {
      return false;
    }
  }

  String? _findActiveSubscriptionId(CustomerInfo? customerInfo) {
    if (customerInfo != null && customerInfo.activeSubscriptions.isNotEmpty) {
      for (final subscription in customerInfo.activeSubscriptions) {
        return subscription;
      }
    }
    return null;
  }
}
