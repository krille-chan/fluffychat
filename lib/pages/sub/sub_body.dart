import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
    // Listener for subscription updates
    Purchases.addCustomerInfoUpdateListener((info) {
      _loadOfferings();
    });
  }

  Future<void> _loadOfferings() async {
    try {
      final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final Offerings offerings = await Purchases.getOfferings();
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
                expirationDate: getExpirationDate(customerInfo!),
              )
            : const CircularProgressIndicator(),
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

  String? getExpirationDate(CustomerInfo customerInfo) {
    if (customerInfo.entitlements.active.isNotEmpty) {
      // Recover the expiration date of the active subscription
      final String? expirationDate =
          customerInfo.entitlements.active.values.first.expirationDate;

      // Convert date string to DateTime object
      DateTime expirationDateTime = DateTime.parse(expirationDate!);

      // Set date to local time
      expirationDateTime = expirationDateTime.toLocal();

      // Format
      final String formattedExpirationDate =
          DateFormat('yyyy-MM-dd HH:mm').format(expirationDateTime);

      return formattedExpirationDate;
    }
    return null;
  }
}
