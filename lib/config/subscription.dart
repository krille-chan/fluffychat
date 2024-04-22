import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:tawkie/config/app_config.dart';

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
      if (customerInfo.entitlements.active.isNotEmpty &&
          customerInfo.entitlements.all[AppConfig.tawkieSubscriptionIdentifier]!
              .isActive) {
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

  Future<bool> restoreSub() async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      if (customerInfo.entitlements.active.isNotEmpty) {
        //user has access to some entitlement
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      // Error restoring purchases
      print('error: $e');
      return false;
    }
  }
}
