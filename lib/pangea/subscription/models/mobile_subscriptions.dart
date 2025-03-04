import 'dart:io';

import 'package:flutter/material.dart';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/subscription/models/base_subscription_info.dart';

class MobileSubscriptionInfo extends CurrentSubscriptionInfo {
  MobileSubscriptionInfo({
    required super.userID,
    required super.availableSubscriptionInfo,
  });

  @override
  Future<void> configure() async {
    final PurchasesConfiguration configuration = Platform.isAndroid
        ? PurchasesConfiguration(Environment.rcGoogleKey)
        : PurchasesConfiguration(Environment.rcIosKey);
    try {
      await Purchases.configure(
        configuration..appUserID = userID,
      );
      await super.configure();
      await setMobilePackages();
    } catch (err) {
      ErrorHandler.logError(
        m: "Failed to configure revenuecat SDK",
        s: StackTrace.current,
        data: {},
      );
    }
  }

  Future<void> setMobilePackages() async {
    if (availableSubscriptionInfo.allProducts == null) return;

    final Offerings offerings = await Purchases.getOfferings();
    final Offering? offering = offerings.all[Environment.rcOfferingName];
    if (offering == null) return;

    final products = availableSubscriptionInfo.allProducts;
    for (final package in offering.availablePackages) {
      final int productIndex = products!.indexWhere(
        (product) => product.id.contains(package.storeProduct.identifier),
      );

      if (productIndex < 0) continue;
      final SubscriptionDetails updated =
          availableSubscriptionInfo.allProducts![productIndex];
      updated.package = package;
      updated.localizedPrice = package.storeProduct.priceString;
      availableSubscriptionInfo.allProducts![productIndex] = updated;
    }
  }

  @override
  Future<void> setCurrentSubscription() async {
    if (availableSubscriptionInfo.allProducts == null) return;

    CustomerInfo info;
    try {
      // await Purchases.syncPurchases();
      info = await Purchases.getCustomerInfo();
    } catch (err) {
      ErrorHandler.logError(
        m: "Failed to fetch revenuecat customer info",
        s: StackTrace.current,
        data: {},
      );
      return;
    }

    final List<EntitlementInfo> activeEntitlements =
        info.entitlements.all.entries
            .where(
              (MapEntry<String, EntitlementInfo> entry) =>
                  entry.value.expirationDate == null ||
                  DateTime.parse(entry.value.expirationDate!)
                      .isAfter(DateTime.now()),
            )
            .map((MapEntry<String, EntitlementInfo> entry) => entry.value)
            .toList();

    if (activeEntitlements.length > 1) {
      debugPrint(
        "User has more than one active entitlement.",
      );
    } else if (activeEntitlements.isEmpty) {
      debugPrint("User has no active entitlements");
      if (!isNewUserTrial) {
        resetSubscription();
      }
      return;
    }

    final EntitlementInfo activeEntitlement = activeEntitlements[0];
    currentSubscriptionId = activeEntitlement.productIdentifier;
    expirationDate = activeEntitlement.expirationDate != null
        ? DateTime.parse(activeEntitlement.expirationDate!)
        : null;

    if (activeEntitlement.periodType == PeriodType.trial) {
      currentSubscription?.makeTrial();
    }
    if (currentSubscriptionId != null && currentSubscription == null) {
      Sentry.addBreadcrumb(
        Breadcrumb(message: "mismatch of productIds and currentSubscriptionID"),
      );
    }
  }
}
