import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class SubscriptionManager {
  void presentPaywall() async {
    final paywallResult = await RevenueCatUI.presentPaywall();
    log('Paywall result: $paywallResult');
  }

  void presentPaywallIfNeeded() async {
    final paywallResult =
        await RevenueCatUI.presentPaywallIfNeeded("tawkie_sub");
    log('Paywall result: $paywallResult');
  }

  static Future<bool> checkSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // access latest customerInfo
      if (customerInfo.entitlements.active.isNotEmpty) {
        // Grant user "pro" access
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      // Error fetching customer info
      print(e);
      return false;
    }
  }

  void checkSubscriptionStatusAndRedirect() async {
    bool hasSub = await checkSubscriptionStatus();

    if (!hasSub) {
      SubscriptionManager().presentPaywall();
    }
  }
}
