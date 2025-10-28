import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/subscription/repo/subscription_management_repo.dart';
import 'package:fluffychat/pangea/subscription/repo/subscription_repo.dart';
import 'package:fluffychat/pangea/subscription/utils/subscription_app_id.dart';

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

  bool get currentSubscriptionIsPromotional =>
      currentSubscriptionId?.startsWith("rc_promo") ?? false;

  bool get isPaidSubscription =>
      (currentSubscription != null || currentSubscriptionId != null) &&
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
  Future<void> setCurrentSubscription() async {}
}

/// Contains information about the suscriptions available on revenuecat
class AvailableSubscriptionsInfo {
  List<SubscriptionDetails> availableSubscriptions = [];
  SubscriptionAppIds? appIds;
  List<SubscriptionDetails>? allProducts;
  DateTime? lastUpdated;

  AvailableSubscriptionsInfo({
    this.appIds,
    this.allProducts,
    this.lastUpdated,
  });

  Future<void> setAvailableSubscriptions() async {
    final cachedInfo =
        SubscriptionManagementRepo.getAvailableSubscriptionsInfo();

    appIds ??= cachedInfo?.appIds ?? await SubscriptionRepo.getAppIds();
    allProducts ??=
        cachedInfo?.allProducts ?? await SubscriptionRepo.getAllProducts();

    if (cachedInfo == null) {
      await SubscriptionManagementRepo.setAvailableSubscriptionsInfo(this);
    }

    availableSubscriptions = (allProducts ?? [])
        .where(
          (product) =>
              product.appId == appIds!.currentAppId || product.appId == "trial",
        )
        .sorted((a, b) => a.price.compareTo(b.price))
        .toList();
  }

  factory AvailableSubscriptionsInfo.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('app_ids') || !json.containsKey('all_products')) {
      throw "Cached subscription info is missing required fields";
    }

    if (json['all_products'] is! List<dynamic> || json['app_ids'] is! Map) {
      throw "Cached subscription info contains incorrect data type(s)";
    }

    final appIds = SubscriptionAppIds.fromJson(json['app_ids']);
    final allProducts = (json['all_products'] as List<dynamic>)
        .map((product) => SubscriptionDetails.fromJson(product))
        .toList()
        .cast<SubscriptionDetails>();
    final lastUpdated = json['last_updated'] != null
        ? DateTime.tryParse(json['last_updated']!)
        : null;
    return AvailableSubscriptionsInfo(
      appIds: appIds,
      allProducts: allProducts,
      lastUpdated: lastUpdated,
    );
  }

  Map<String, dynamic> toJson({validate = true}) {
    if (validate && (appIds == null || allProducts == null)) {
      throw "appIds or allProducts is null in AvailableSubscriptionsInfo";
    }

    final data = <String, dynamic>{};
    data['app_ids'] = appIds?.toJson();
    data['all_products'] =
        allProducts?.map((product) => product.toJson()).toList();
    data['last_updated'] = (lastUpdated ?? DateTime.now()).toIso8601String();
    return data;
  }
}
