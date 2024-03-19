import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tawkie/pages/subscription/model/style.dart';
import 'package:tawkie/pages/subscription/paywall.dart';

class SubscriptionManager {
  static bool _isSubscribed = false;

  // Méthode statique pour initialiser et écouter les changements d'abonnement
  static void initAndListen() {
    // Initialiser l'état de l'abonnement
    _checkSubscriptionStatus();

    // Écouter les mises à jour de l'état d'abonnement
    Purchases.addCustomerInfoUpdateListener((purchaserInfo) {
      _checkSubscriptionStatus();
    });
  }

  // Méthode privée pour vérifier l'état de l'abonnement
  static void _checkSubscriptionStatus() {
    // Vérifier si l'utilisateur est abonné
    Purchases.getCustomerInfo().then((purchaserInfo) {
      if (purchaserInfo.entitlements.active.containsKey("tawkie_sub")) {
        _isSubscribed = true;
      } else {
        _isSubscribed = false;
      }
    });
  }

  // Méthode statique pour vérifier si l'utilisateur est abonné
  static bool isSubscribed() {
    // Renvoyer l'état de l'abonnement
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
