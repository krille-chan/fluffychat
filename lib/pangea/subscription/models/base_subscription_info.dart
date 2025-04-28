import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/subscription/repo/subscription_repo.dart';
import 'package:fluffychat/pangea/subscription/utils/subscription_app_id.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Contains information about the users's current subscription
class CurrentSubscriptionInfo {
  final String userID;
  final AvailableSubscriptionsInfo availableSubscriptionInfo;
  final Map<String, RCSubscription>? history;

  DateTime? expirationDate;
  String? currentSubscriptionId;

  CurrentSubscriptionInfo({
    required this.userID,
    required this.availableSubscriptionInfo,
    required this.history,
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

  final subscriptionBox =
      MatrixState.pangeaController.subscriptionController.subscriptionBox;

  AvailableSubscriptionsInfo({
    this.appIds,
    this.allProducts,
    this.lastUpdated,
  });

  Future<void> setAvailableSubscriptions() async {
    final cachedInfo = _getCachedSubscriptionInfo();
    appIds ??= cachedInfo?.appIds ?? await SubscriptionRepo.getAppIds();
    allProducts ??=
        cachedInfo?.allProducts ?? await SubscriptionRepo.getAllProducts();

    if (cachedInfo == null) await _cacheSubscriptionInfo();

    availableSubscriptions = (allProducts ?? [])
        .where(
          (product) =>
              product.appId == appIds!.currentAppId || product.appId == "trial",
        )
        .sorted((a, b) => a.price.compareTo(b.price))
        .toList();
  }

  Future<void> _cacheSubscriptionInfo() async {
    try {
      final json = toJson();
      await subscriptionBox.write(
        PLocalKey.availableSubscriptionInfo,
        json,
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "appIds": appIds,
          "allProducts": allProducts,
        },
      );
    }
  }

  AvailableSubscriptionsInfo? _getCachedSubscriptionInfo() {
    final json = subscriptionBox.read(
      PLocalKey.availableSubscriptionInfo,
    );
    if (json is! Map<String, dynamic>) {
      return null;
    }

    try {
      final resp = AvailableSubscriptionsInfo.fromJson(json);
      return resp.lastUpdated == null ? null : resp;
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "json": json,
        },
      );
      return null;
    }
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
