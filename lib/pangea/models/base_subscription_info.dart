import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/repo/subscription_repo.dart';
import 'package:fluffychat/pangea/utils/subscription_app_id.dart';

/// Contains information about the users's current subscription
class CurrentSubscriptionInfo {
  final String userID;
  final AvailableSubscriptionsInfo availableSubscriptionInfo;

  DateTime? expirationDate;
  String? currentSubscriptionId;

  CurrentSubscriptionInfo({
    required this.userID,
    required this.availableSubscriptionInfo,
  });

  SubscriptionDetails? get currentSubscription {
    if (currentSubscriptionId == null) return null;
    return availableSubscriptionInfo.allProducts?.firstWhereOrNull(
      (SubscriptionDetails sub) =>
          sub.id.contains(currentSubscriptionId!) ||
          currentSubscriptionId!.contains(sub.id),
    );
  }

  Future<void> configure() async {}

  bool get isNewUserTrial =>
      currentSubscriptionId == AppConfig.trialSubscriptionId;

  bool get currentSubscriptionIsPromotional =>
      currentSubscriptionId?.startsWith("rc_promo") ?? false;

  bool get isPaidSubscription =>
      (currentSubscription != null || currentSubscriptionId != null) &&
      !isNewUserTrial &&
      !currentSubscriptionIsPromotional;

  bool get isLifetimeSubscription =>
      currentSubscriptionIsPromotional &&
      expirationDate != null &&
      expirationDate!.isAfter(DateTime(2100));

  String? get purchasePlatformDisplayName {
    if (currentSubscription?.appId == null) return null;
    return availableSubscriptionInfo.appIds
        ?.appDisplayName(currentSubscription!.appId!);
  }

  bool get purchasedOnWeb =>
      (currentSubscription != null &&
          availableSubscriptionInfo.appIds != null) &&
      (currentSubscription?.appId ==
          availableSubscriptionInfo.appIds?.stripeId);

  bool get currentPlatformMatchesPurchasePlatform =>
      (currentSubscription != null &&
          availableSubscriptionInfo.appIds != null) &&
      (currentSubscription?.appId ==
          availableSubscriptionInfo.appIds?.currentAppId);

  void resetSubscription() => currentSubscriptionId = null;

  void setTrial(DateTime expiration) {
    expirationDate = expiration;
    currentSubscriptionId = AppConfig.trialSubscriptionId;
    if (currentSubscription == null) {
      availableSubscriptionInfo.availableSubscriptions.add(
        SubscriptionDetails(
          price: 0,
          id: AppConfig.trialSubscriptionId,
          periodType: SubscriptionPeriodType.trial,
        ),
      );
    }
  }

  Future<void> setCurrentSubscription() async {}
}

/// Contains information about the suscriptions available on revenuecat
class AvailableSubscriptionsInfo {
  List<SubscriptionDetails> availableSubscriptions = [];
  SubscriptionAppIds? appIds;
  List<SubscriptionDetails>? allProducts;

  Future<void> setAvailableSubscriptions() async {
    appIds ??= await SubscriptionRepo.getAppIds();
    allProducts ??= await SubscriptionRepo.getAllProducts();
    availableSubscriptions = (allProducts ?? [])
        .where((product) => product.appId == appIds!.currentAppId)
        .sorted((a, b) => a.price.compareTo(b.price))
        .toList();
    // //@Gabby - temporary solution to add trial to list
    // if (currentSubscriptionId == null && !hasSubscribed) {
    //   final id = availableSubscriptions[0].id;
    //   final package = availableSubscriptions[0].package;
    //   final duration = availableSubscriptions[0].duration;
    //   availableSubscriptions.insert(
    //     0,
    //     SubscriptionDetails(
    //       price: 0,
    //       id: id,
    //       duration: duration,
    //       package: package,
    //       periodType: SubscriptionPeriodType.trial,
    //     ),
    //   );
    // }
  }
}
