import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class SubscriptionManager {
  static bool _isSubscribed = false;

  // Static method for initializing and listening for subscription changes
  static void initAndListen() {
    // Initialize subscription status
    _checkSubscriptionStatus();

    // Listen to subscription status updates
    Purchases.addCustomerInfoUpdateListener((purchaserInfo) {
      _checkSubscriptionStatus();
    });
  }

  // Private method for checking subscription status
  static void _checkSubscriptionStatus() {
    // Check if the user is a subscriber
    Purchases.getCustomerInfo().then((purchaserInfo) {
      if (purchaserInfo.entitlements.active.containsKey("tawkie_sub")) {
        _isSubscribed = true;
      } else {
        _isSubscribed = false;
      }
    });
  }

  // Static method to check if the user is a subscriber
  static bool isSubscribed() {
    // Resend subscription status
    return _isSubscribed;
  }

  void presentPaywall() async {
    final paywallResult = await RevenueCatUI.presentPaywall();
    log('Paywall result: $paywallResult');
  }

  void presentPaywallIfNeeded() async {
    final paywallResult =
        await RevenueCatUI.presentPaywallIfNeeded("tawkie_sub");
    log('Paywall result: $paywallResult');
  }

  void checkSubscriptionStatusAndRedirect() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all['tawkie_sub'] != null &&
        customerInfo.entitlements.all['tawkie_sub']?.isActive == true) {
      // Connect to Matrix
    } else {
      SubscriptionManager().presentPaywall();
    }
  }
}
