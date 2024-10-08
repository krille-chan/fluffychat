import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/models/base_subscription_info.dart';
import 'package:fluffychat/pangea/repo/subscription_repo.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class WebSubscriptionInfo extends SubscriptionInfo {
  WebSubscriptionInfo({required super.pangeaController}) : super();

  @override
  Future<void> configure() async {
    await setAppIds();
    await setAllProducts();
    await setCustomerInfo();

    if (allProducts == null || appIds == null) {
      Sentry.addBreadcrumb(
        Breadcrumb(message: "No products found for current app"),
      );
      return;
    }

    availableSubscriptions = allProducts!
        .where((product) => product.appId == appIds!.currentAppId)
        .toList();
    availableSubscriptions.sort((a, b) => a.price.compareTo(b.price));
    //@Gabby - temporary solution to add trial to list
    if (currentSubscriptionId == null && !hasSubscribed) {
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
  }

  @override
  Future<void> setCustomerInfo() async {
    if (currentSubscriptionId != null && currentSubscription != null) {
      return;
    }
    final RCSubscriptionResponseModel currentSubscriptionInfo =
        await SubscriptionRepo.getCurrentSubscriptionInfo(
      pangeaController.matrixState.client.userID,
      allProducts,
    );

    currentSubscriptionId = currentSubscriptionInfo.currentSubscriptionId;
    currentSubscription = currentSubscriptionInfo.currentSubscription;
    allEntitlements = currentSubscriptionInfo.allEntitlements ?? [];
    expirationDate = currentSubscriptionInfo.expirationDate;

    if (currentSubscriptionId != null && currentSubscription == null) {
      Sentry.addBreadcrumb(
        Breadcrumb(message: "mismatch of productIds and currentSubscriptionID"),
      );
    }
  }
}
