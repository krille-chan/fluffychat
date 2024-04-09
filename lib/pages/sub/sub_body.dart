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
        title: Text('Mon abonnement'),
      ),
      body: Center(
        child: _offerings != null
            ? SubscriptionChangePage(
                offerings: _offerings,
                activeSubscriptionId: _findActiveSubscriptionId(customerInfo)!,
              )
            : CircularProgressIndicator(),
      ),
    );
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
