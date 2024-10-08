import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/models/base_subscription_info.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MobileSubscriptionInfo extends SubscriptionInfo {
  MobileSubscriptionInfo({required super.pangeaController}) : super();

  @override
  Future<void> configure() async {
    final PurchasesConfiguration configuration = Platform.isAndroid
        ? PurchasesConfiguration(Environment.rcGoogleKey)
        : PurchasesConfiguration(Environment.rcIosKey);
    try {
      await Purchases.configure(
        configuration..appUserID = pangeaController.userController.userId,
      );
    } catch (err) {
      ErrorHandler.logError(
        m: "Failed to configure revenuecat SDK for user ${pangeaController.userController.userId}",
        s: StackTrace.current,
      );
      debugPrint(
        "Failed to configure revenuecat SDK for user ${pangeaController.userController.userId}",
      );
      return;
    }
    await setAppIds();
    await setAllProducts();
    await setCustomerInfo();
    await setMobilePackages();
    if (allProducts != null && appIds != null) {
      availableSubscriptions = allProducts!
          .where((product) => product.appId == appIds!.currentAppId)
          .toList();
      availableSubscriptions.sort((a, b) => a.price.compareTo(b.price));

      if (currentSubscriptionId == null && !hasSubscribed) {
        //@Gabby - temporary solution to add trial to list
        final id = availableSubscriptions[0].id;
        final package = availableSubscriptions[0].package;
        final duration = availableSubscriptions[0].duration;
        availableSubscriptions.insert(
          0,
          SubscriptionDetails(
            price: 0,
            id: id,
            duration: duration,
            package: package,
            periodType: 'trial',
          ),
        );
      }
    } else {
      ErrorHandler.logError(e: Exception("allProducts null || appIds null"));
    }
  }

  Future<void> setMobilePackages() async {
    if (allProducts == null) {
      ErrorHandler.logError(
        m: "Null appProducts in setMobilePrices",
        s: StackTrace.current,
      );
      debugPrint(
        "Null appProducts in setMobilePrices",
      );
      return;
    }
    Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
    } catch (err) {
      ErrorHandler.logError(
        m: "Failed to fetch revenuecat offerings from revenuecat",
        s: StackTrace.current,
      );
      debugPrint(
        "Failed to fetch revenuecat offerings from revenuecat",
      );
      return;
    }
    final Offering? offering = offerings.all[Environment.rcOfferingName];
    if (offering != null) {
      final List<SubscriptionDetails> mobileSubscriptions =
          offering.availablePackages
              .map(
                (package) {
                  return SubscriptionDetails(
                    price: package.storeProduct.price,
                    id: package.storeProduct.identifier,
                    package: package,
                  );
                },
              )
              .toList()
              .cast<SubscriptionDetails>();
      for (final SubscriptionDetails mobileSub in mobileSubscriptions) {
        final int productIndex = allProducts!
            .indexWhere((product) => product.id.contains(mobileSub.id));
        if (productIndex >= 0) {
          final SubscriptionDetails updated = allProducts![productIndex];
          updated.package = mobileSub.package;
          allProducts![productIndex] = updated;
        }
      }
    }
  }

  @override
  Future<void> setCustomerInfo() async {
    if (allProducts == null) {
      ErrorHandler.logError(
        m: "Null allProducts in setCustomerInfo",
        s: StackTrace.current,
      );
      debugPrint(
        "Null allProducts in setCustomerInfo",
      );
      return;
    }

    CustomerInfo info;
    try {
      // await Purchases.syncPurchases();
      info = await Purchases.getCustomerInfo();
    } catch (err) {
      ErrorHandler.logError(
        m: "Failed to fetch revenuecat customer info for user ${pangeaController.userController.userId}",
        s: StackTrace.current,
      );
      debugPrint(
        "Failed to fetch revenuecat customer info for user ${pangeaController.userController.userId}",
      );
      return;
    }
    final List<EntitlementInfo> noExpirations =
        getEntitlementsWithoutExpiration(info);

    if (noExpirations.isNotEmpty) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message:
              "Found revenuecat entitlement(s) without expiration date for user ${pangeaController.userController.userId}: ${noExpirations.map(
            (entry) =>
                "Entitlement Id: ${entry.identifier}, Purchase Date: ${entry.originalPurchaseDate}",
          )}",
        ),
      );
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

    allEntitlements = info.entitlements.all.entries
        .map(
          (MapEntry<String, EntitlementInfo> entry) =>
              entry.value.productIdentifier,
        )
        .cast<String>()
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
    currentSubscription = allProducts!.firstWhereOrNull(
      (SubscriptionDetails sub) =>
          sub.id.contains(currentSubscriptionId!) ||
          currentSubscriptionId!.contains(sub.id),
    );
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

  List<EntitlementInfo> getEntitlementsWithoutExpiration(CustomerInfo info) {
    final List<EntitlementInfo> noExpirations = info.entitlements.all.entries
        .where(
          (MapEntry<String, EntitlementInfo> entry) =>
              entry.value.expirationDate == null,
        )
        .map((MapEntry<String, EntitlementInfo> entry) => entry.value)
        .toList();
    return noExpirations;
  }
}
