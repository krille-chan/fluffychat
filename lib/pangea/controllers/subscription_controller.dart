import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/constants/local.key.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum CanSendStatus {
  subscribed,
  dimissedPaywall,
  showPaywall,
}

class SubscriptionController extends BaseController {
  late PangeaController _pangeaController;
  SubscriptionInfo? subscription;
  final StreamController subscriptionStream = StreamController.broadcast();
  final StreamController trialActivationStream = StreamController.broadcast();

  SubscriptionController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  bool get isSubscribed =>
      subscription != null &&
      (subscription!.currentSubscriptionId != null ||
          subscription!.currentSubscription != null);

  bool _isInitializing = false;
  Completer<void> initialized = Completer<void>();

  Future<void> initialize() async {
    if (initialized.isCompleted) return;
    if (_isInitializing) {
      await initialized.future;
      return;
    }
    _isInitializing = true;
    await _initialize();
    _isInitializing = false;
    initialized.complete();
  }

  Future<void> reinitialize() async {
    initialized = Completer<void>();
    _isInitializing = false;
    await initialize();
  }

  Future<void> _initialize() async {
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
      if (_activatedNewUserTrial) {
        setNewUserTrial();
      }

      if (!kIsWeb) {
        Purchases.addCustomerInfoUpdateListener(
          (CustomerInfo info) async {
            final bool wasSubscribed = isSubscribed;
            await updateCustomerInfo();
            if (!wasSubscribed && isSubscribed) {
              subscriptionStream.add(true);
            }
          },
        );
      } else {
        final bool? beganWebPayment = _pangeaController.pStoreService.read(
          PLocalKey.beganWebPayment,
        );
        if (beganWebPayment ?? false) {
          await _pangeaController.pStoreService.delete(
            PLocalKey.beganWebPayment,
          );
          if (_pangeaController.subscriptionController.isSubscribed) {
            subscriptionStream.add(true);
          }
        }
      }
      setState(null);
    } catch (e, s) {
      debugPrint("Failed to initialize subscription controller");
      ErrorHandler.logError(e: e, s: s);
    }
  }

  void submitSubscriptionChange(
    SubscriptionDetails? selectedSubscription,
    BuildContext context, {
    bool isPromo = false,
  }) async {
    if (selectedSubscription != null) {
      if (selectedSubscription.isTrial) {
        activateNewUserTrial();
        return;
      }

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
        await _pangeaController.pStoreService.save(
          PLocalKey.beganWebPayment,
          true,
        );
        setState(null);
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
        final errCode = PurchasesErrorHelper.getErrorCode(
          err as PlatformException,
        );
        if (errCode == PurchasesErrorCode.purchaseCancelledError) {
          debugPrint("User cancelled purchase");
          return;
        }
        ErrorHandler.logError(
          m: "Failed to purchase revenuecat package for user ${_pangeaController.matrixState.client.userID} with error code $errCode",
          s: StackTrace.current,
        );
        return;
      }
    }
  }

  bool get _activatedNewUserTrial {
    final bool activated = _pangeaController
        .userController.profile.userSettings.activatedFreeTrial;
    return _pangeaController.userController.inTrialWindow && activated;
  }

  void activateNewUserTrial() {
    _pangeaController.userController.updateProfile(
      (profile) {
        profile.userSettings.activatedFreeTrial = true;
        return profile;
      },
    );
    setNewUserTrial();
    trialActivationStream.add(true);
  }

  void setNewUserTrial() {
    final DateTime? createdAt =
        _pangeaController.userController.profile.userSettings.createdAt;
    if (createdAt == null) {
      ErrorHandler.logError(
        m: "Null user profile createAt in subscription settings",
        s: StackTrace.current,
      );
      return;
    }

    final DateTime expirationDate = createdAt.add(
      const Duration(days: 7),
    );
    subscription?.setTrial(expirationDate);
  }

  Future<void> updateCustomerInfo() async {
    if (!initialized.isCompleted) {
      await initialize();
    }
    if (subscription == null) {
      ErrorHandler.logError(
        m: "Null subscription info in subscription settings",
        s: StackTrace.current,
      );
      return;
    }
    await subscription!.setCustomerInfo();
    setState(null);
  }

  CanSendStatus get canSendStatus => isSubscribed
      ? CanSendStatus.subscribed
      : _shouldShowPaywall
          ? CanSendStatus.showPaywall
          : CanSendStatus.dimissedPaywall;

  DateTime? get _lastDismissedPaywall {
    final lastDismissed = _pangeaController.pStoreService.read(
      PLocalKey.dismissedPaywall,
    );
    if (lastDismissed == null) return null;
    return DateTime.tryParse(lastDismissed);
  }

  int? get _paywallBackoff {
    final backoff = _pangeaController.pStoreService.read(
      PLocalKey.paywallBackoff,
    );
    if (backoff == null) return null;
    return backoff;
  }

  bool get _shouldShowPaywall {
    return initialized.isCompleted &&
        !isSubscribed &&
        (_lastDismissedPaywall == null ||
            DateTime.now().difference(_lastDismissedPaywall!).inHours >
                (1 * (_paywallBackoff ?? 1)));
  }

  void dismissPaywall() async {
    await _pangeaController.pStoreService.save(
      PLocalKey.dismissedPaywall,
      DateTime.now().toString(),
    );

    if (_paywallBackoff == null) {
      await _pangeaController.pStoreService.save(
        PLocalKey.paywallBackoff,
        1,
      );
    } else {
      await _pangeaController.pStoreService.save(
        PLocalKey.paywallBackoff,
        _paywallBackoff! + 1,
      );
    }
  }

  Future<void> showPaywall(BuildContext context) async {
    try {
      if (!initialized.isCompleted) {
        await initialize();
      }
      if (subscription?.availableSubscriptions.isEmpty ?? true) {
        return;
      }
      if (isSubscribed) return;
      await showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: !PlatformInfos.isMobile,
        clipBehavior: Clip.hardEdge,
        context: context,
        constraints: BoxConstraints(
          maxHeight: PlatformInfos.isMobile
              ? MediaQuery.of(context).size.height - 50
              : 600,
        ),
        builder: (_) {
          return SubscriptionPaywall(
            pangeaController: _pangeaController,
          );
        },
      );
      dismissPaywall();
    } catch (e, s) {
      ErrorHandler.logError(e: e, s: s);
    }
  }

  Future<String> getPaymentLink(String duration, {bool isPromo = false}) async {
    final Requests req = Requests();
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
