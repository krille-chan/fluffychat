import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tawkie/pages/subscription/model/style.dart';
import 'package:tawkie/pages/subscription/paywall.dart';

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

  void checkSubscriptionStatusAndRedirect(BuildContext context) async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all['tawkie_sub'] != null &&
        customerInfo.entitlements.all['tawkie_sub']?.isActive == true) {
      // Connect to Matrix
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        print(e.message);
      }

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to user
      } else {
        // current offering is available, show paywall
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: kColorBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Paywall(
                offering: offerings!.current!,
              );
            });
          },
        );
      }
    }
  }
}
