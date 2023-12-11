import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/base_subscription_info.dart';
import 'package:fluffychat/pangea/models/mobile_subscriptions.dart';
import 'package:fluffychat/pangea/models/web_subscriptions.dart';
import 'package:fluffychat/pangea/network/requests.dart';
import 'package:fluffychat/pangea/network/urls.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/widgets/subscription/subscription_paywall.dart';
import 'package:fluffychat/utils/platform_infos.dart';
// Project imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SubscriptionController extends BaseController {
  late PangeaController _pangeaController;
  SubscriptionInfo? subscription;

  //convert this logic to use completer
  bool initialized = false;

  SubscriptionController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  bool get isSubscribed =>
      subscription != null &&
      (subscription!.currentSubscriptionId != null ||
          subscription!.currentSubscription != null);

  bool get currentSubscriptionAvailable =>
      isSubscribed && subscription?.currentSubscription != null;

  bool get currentSubscriptionIsTrial =>
      subscription?.currentSubscription?.isTrial ?? false;

  Future<void> initialize() async {
    try {
      if (_pangeaController.matrixState.client.userID == null) {
        debugPrint(
          "Attempted to initalize subscription information with null userId",
        );
        return;
      }

      subscription = kIsWeb
          ? WebSubscriptionInfo(pangeaController: _pangeaController)
          : MobileSubscriptionInfo(pangeaController: _pangeaController);

      await subscription!.configure();
      if (activatedNewUserTrial) {
        setNewUserTrial();
      }

      initialized = true;

      if (!kIsWeb) {
        Purchases.addCustomerInfoUpdateListener(
          (CustomerInfo info) => updateCustomerInfo(),
        );
      }
      setState();
    } catch (e, s) {
      debugPrint("Failed to initialize subscription controller");
      ErrorHandler.logError(e: e, s: s);
    }
  }

  final String activatedTrialKey = 'activatedTrial';

  bool get activatedNewUserTrial =>
      _pangeaController.userController.inTrialWindow &&
      (_pangeaController.pStoreService.read(activatedTrialKey) ?? false);

  void activateNewUserTrial() {
    _pangeaController.pStoreService.save(activatedTrialKey, true);
    setNewUserTrial();
  }

  void setNewUserTrial() {
    final String profileCreatedAt =
        _pangeaController.userController.userModel!.profile!.createdAt;
    final DateTime creationTimestamp = DateTime.parse(profileCreatedAt);
    final DateTime expirationDate = creationTimestamp.add(
      const Duration(days: 7),
    );
    subscription?.setTrial(expirationDate);
  }

  Future<void> updateCustomerInfo() async {
    if (subscription == null) {
      ErrorHandler.logError(
        m: "Null subscription info in subscription settings",
        s: StackTrace.current,
      );
      return;
    }
    await subscription!.setCustomerInfo();

    setState();
  }

  Future<void> showPaywall(
    BuildContext context, [
    bool forceShow = false,
  ]) async {
    try {
      if (!initialized) {
        await initialize();
      }
      if (subscription?.availableSubscriptions.isEmpty ?? true) {
        return;
      }
      if (!forceShow && isSubscribed) return;
      await showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: !PlatformInfos.isMobile,
        clipBehavior: Clip.hardEdge,
        context: context,
        constraints: BoxConstraints(
          maxHeight: PlatformInfos.isMobile ? 600 : 480,
        ),
        builder: (_) => SubscriptionPaywall(
          pangeaController: _pangeaController,
        ),
      );
    } catch (e, s) {
      ErrorHandler.logError(e: e, s: s);
    }
  }

  Future<bool> fetchSubscriptionStatus() async {
    final Requests req = Requests(baseUrl: PApiUrls.baseAPI);
    final String reqUrl = Uri.encodeFull(
      "${PApiUrls.subscriptionExpiration}?pangea_user_id=${_pangeaController.matrixState.client.userID}",
    );

    DateTime? expiration;
    try {
      final Response res = await req.get(url: reqUrl);
      final json = jsonDecode(res.body);
      if (json["premium_expires_date"] != null) {
        expiration = DateTime.parse(json["premium_expires_date"]);
      }
    } catch (err) {
      ErrorHandler.logError(
        e: "Failed to fetch subscripton status for user ${_pangeaController.matrixState.client.userID}",
        s: StackTrace.current,
      );
    }
    final bool subscribed =
        expiration == null ? false : DateTime.now().isBefore(expiration);
    GoogleAnalytics.updateUserSubscriptionStatus(subscribed);
    return subscribed;
  }

  Future<String> getPaymentLink(String duration, {bool isPromo = false}) async {
    final Requests req = Requests(baseUrl: PApiUrls.baseAPI);
    final String reqUrl = Uri.encodeFull(
      "${PApiUrls.paymentLink}?pangea_user_id=${_pangeaController.matrixState.client.userID}&duration=$duration&redeem=$isPromo",
    );
    final Response res = await req.get(url: reqUrl);
    final json = jsonDecode(res.body);
    String paymentLink = json["link"]["url"];

    final String? email = await _pangeaController.userController.userEmail;
    if (email != null) {
      paymentLink += "?prefilled_email=${Uri.encodeComponent(email)}";
    }
    return paymentLink;
  }

  void submitSubscriptionChange(
    SubscriptionDetails? selectedSubscription,
    BuildContext context, {
    bool isPromo = false,
  }) async {
    if (selectedSubscription != null) {
      if (kIsWeb) {
        if (selectedSubscription.duration == null) {
          ErrorHandler.logError(
            m: "Tried to subscribe to web SubscriptionDetails with Null duration",
            s: StackTrace.current,
          );
          return;
        }
        final String paymentLink = await getPaymentLink(
          selectedSubscription.duration!,
          isPromo: isPromo,
        );
        setState();
        launchUrlString(
          paymentLink,
          webOnlyWindowName: "_self",
        );
        return;
      }
      if (selectedSubscription.package == null) {
        ErrorHandler.logError(
          m: "Tried to subscribe to SubscriptionDetails with Null revenuecat Package",
          s: StackTrace.current,
        );
        return;
      }
      try {
        GoogleAnalytics.beginPurchaseSubscription(
          selectedSubscription,
          context,
        );
        await Purchases.purchasePackage(selectedSubscription.package!);
        GoogleAnalytics.updateUserSubscriptionStatus(true);
      } catch (err) {
        ErrorHandler.logError(
          m: "Failed to purchase revenuecat package for user ${_pangeaController.matrixState.client.userID}",
          s: StackTrace.current,
        );
        return;
      }
    }
  }

  Future<void> redeemPromoCode(BuildContext context) async {
    final List<String>? promoCode = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.enterPromoCode,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [const DialogTextField()],
    );
    if (promoCode == null || promoCode.single.isEmpty) return;
    launchUrlString(
      "${AppConfig.iosPromoCode}${promoCode.single}",
    );
  }
}

class SubscriptionDetails {
  double price;
  String? duration;
  Package? package;
  String? appId;
  final String id;
  String? periodType = "normal";

  SubscriptionDetails({
    required this.price,
    required this.id,
    this.duration,
    this.package,
    this.appId,
    this.periodType,
  });

  void makeTrial() => periodType = 'trial';
  bool get isTrial => periodType == 'trial';

  String displayPrice(BuildContext context) {
    if (isTrial || price <= 0) {
      return L10n.of(context)!.freeTrial;
    }
    return "\$${price.toStringAsFixed(2)}";
  }

  String displayName(BuildContext context) {
    if (isTrial) {
      return L10n.of(context)!.oneWeekTrial;
    }
    switch (duration) {
      case ('month'):
        return L10n.of(context)!.monthlySubscription;
      case ('year'):
        return L10n.of(context)!.yearlySubscription;
      default:
        return L10n.of(context)!.defaultSubscription;
    }
  }
}
