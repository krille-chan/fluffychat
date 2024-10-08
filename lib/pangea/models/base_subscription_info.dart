import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/repo/subscription_repo.dart';
import 'package:fluffychat/pangea/utils/subscription_app_id.dart';

class SubscriptionInfo {
  PangeaController pangeaController;
  List<SubscriptionDetails> availableSubscriptions = [];
  String? currentSubscriptionId;
  SubscriptionDetails? currentSubscription;
  // Gabby - is it necessary to store appIds for each platform?
  SubscriptionAppIds? appIds;
  List<SubscriptionDetails>? allProducts;
  final SubscriptionPlatform platform = SubscriptionPlatform();
  List<String> allEntitlements = [];
  DateTime? expirationDate;

  bool get hasSubscribed => allEntitlements.isNotEmpty;

  SubscriptionInfo({
    required this.pangeaController,
  }) : super();

  Future<void> configure() async {}

  //TO-DO - hey Gabby this file feels like it could be reorganized. i'd like to
  // 1) move these api calls to a class in a file in repo and
  // 2) move the url to the urls file.
  // 3) any stateful info to the subscription controller
  // let's discuss before you make the changes though
  // maybe you had some reason for this organization

  /* 
  Fetch App Ids for each RC app (iOS, Android, and Stripe). Used to determine which app a user 
  with an active subscription purchased that subscription.
  */
  Future<void> setAppIds() async {
    if (appIds != null) return;
    appIds = await SubscriptionRepo.getAppIds();
  }

  Future<void> setAllProducts() async {
    if (allProducts != null) return;
    allProducts = await SubscriptionRepo.getAllProducts();
  }

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
    return appIds?.appDisplayName(currentSubscription!.appId!);
  }

  bool get purchasedOnWeb =>
      (currentSubscription != null && appIds != null) &&
      (currentSubscription?.appId == appIds?.stripeId);

  bool get currentPlatformMatchesPurchasePlatform =>
      (currentSubscription != null && appIds != null) &&
      (currentSubscription?.appId == appIds?.currentAppId);

  void resetSubscription() {
    currentSubscription = null;
    currentSubscriptionId = null;
  }

  void setTrial(DateTime expiration) {
    if (currentSubscription != null) return;
    expirationDate = expiration;
    currentSubscriptionId = AppConfig.trialSubscriptionId;
    currentSubscription = SubscriptionDetails(
      price: 0,
      id: AppConfig.trialSubscriptionId,
      periodType: 'trial',
    );
  }

  Future<void> setCustomerInfo() async {}

  String? get defaultManagementURL {
    final String? purchaseAppId = currentSubscription?.appId;
    return purchaseAppId == appIds?.androidId
        ? AppConfig.googlePlayMangementUrl
        : purchaseAppId == appIds?.appleId
            ? AppConfig.appleMangementUrl
            : Environment.stripeManagementUrl;
  }
}
