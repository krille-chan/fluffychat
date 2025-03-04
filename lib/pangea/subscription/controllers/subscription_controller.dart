import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/common/controllers/base_controller.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/subscription/models/base_subscription_info.dart';
import 'package:fluffychat/pangea/subscription/models/mobile_subscriptions.dart';
import 'package:fluffychat/pangea/subscription/models/web_subscriptions.dart';
import 'package:fluffychat/pangea/subscription/utils/subscription_app_id.dart';
import 'package:fluffychat/pangea/subscription/widgets/subscription_paywall.dart';
import 'package:fluffychat/pangea/user/controllers/user_controller.dart';
import 'package:fluffychat/utils/platform_infos.dart';

enum SubscriptionStatus {
  subscribed,
  dimissedPaywall,
  showPaywall,
}

class SubscriptionController extends BaseController {
  late PangeaController _pangeaController;

  CurrentSubscriptionInfo? currentSubscriptionInfo;
  AvailableSubscriptionsInfo? availableSubscriptionInfo;

  final StreamController subscriptionStream = StreamController.broadcast();
  final StreamController trialActivationStream = StreamController.broadcast();

  SubscriptionController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  UserController get _userController => _pangeaController.userController;
  String? get _userID => _pangeaController.matrixState.client.userID;

  bool get isSubscribed {
    final bool hasSubscription =
        currentSubscriptionInfo?.currentSubscriptionId != null;

    if (_activatedNewUserTrial && !hasSubscription) {
      _setNewUserTrial();
      return true;
    }

    return hasSubscription;
  }

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

  final GetStorage subscriptionBox = GetStorage("subscription_storage");
  Future<void> _initialize() async {
    try {
      if (_userID == null) {
        debugPrint(
          "Attempted to initalize subscription information with null userId",
        );
        return;
      }

      availableSubscriptionInfo = AvailableSubscriptionsInfo();
      await availableSubscriptionInfo!.setAvailableSubscriptions();

      currentSubscriptionInfo = kIsWeb
          ? WebSubscriptionInfo(
              userID: _userID!,
              availableSubscriptionInfo: availableSubscriptionInfo!,
            )
          : MobileSubscriptionInfo(
              userID: _userID!,
              availableSubscriptionInfo: availableSubscriptionInfo!,
            );

      await currentSubscriptionInfo!.configure();
      await currentSubscriptionInfo!.setCurrentSubscription();
      if (_activatedNewUserTrial) {
        _setNewUserTrial();
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
        final bool? beganWebPayment =
            subscriptionBox.read(PLocalKey.beganWebPayment);
        if (beganWebPayment ?? false) {
          await subscriptionBox.remove(
            PLocalKey.beganWebPayment,
          );
          if (isSubscribed) {
            subscriptionStream.add(true);
          }
        }
      }
      setState(null);
    } catch (e, s) {
      debugPrint("Failed to initialize subscription controller");
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "availableSubscriptionInfo": availableSubscriptionInfo?.toJson(),
        },
      );
    }
  }

  Future<void> submitSubscriptionChange(
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
            data: {
              "selectedSubscription": selectedSubscription.toJson(),
            },
          );
          return;
        }
        final String paymentLink = await getPaymentLink(
          selectedSubscription.duration!,
          isPromo: isPromo,
        );
        await subscriptionBox.write(
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
        final offerings = await Purchases.getOfferings();
        ErrorHandler.logError(
          m: "Tried to subscribe to SubscriptionDetails with Null revenuecat Package",
          s: StackTrace.current,
          data: {
            "selectedSubscription": selectedSubscription.toJson(),
            "offerings": offerings.toJson(),
          },
        );
        return;
      }

      GoogleAnalytics.beginPurchaseSubscription(
        selectedSubscription,
        context,
      );
      await Purchases.purchasePackage(selectedSubscription.package!);
      GoogleAnalytics.updateUserSubscriptionStatus(true);
    }
  }

  int get _currentTrialDays =>
      _userController.inTrialWindow(trialDays: 7) ? 7 : 0;

  bool get _activatedNewUserTrial =>
      _userController.inTrialWindow(trialDays: 1) ||
      (_userController.inTrialWindow() &&
          _userController.profile.userSettings.activatedFreeTrial);

  void activateNewUserTrial() {
    _userController.updateProfile(
      (profile) {
        profile.userSettings.activatedFreeTrial = true;
        return profile;
      },
    );
    _setNewUserTrial();
    trialActivationStream.add(true);
  }

  void _setNewUserTrial() {
    final DateTime? createdAt = _userController.profile.userSettings.createdAt;
    if (createdAt == null) {
      ErrorHandler.logError(
        m: "Null user profile createdAt in subscription settings",
        s: StackTrace.current,
        data: {},
      );
      return;
    }

    final DateTime expirationDate = createdAt.add(
      Duration(days: _currentTrialDays),
    );
    currentSubscriptionInfo?.setTrial(expirationDate);
  }

  Future<void> updateCustomerInfo() async {
    if (!initialized.isCompleted) {
      await initialize();
    }
    await currentSubscriptionInfo!.setCurrentSubscription();
    setState(null);
  }

  /// if the user is subscribed, returns subscribed
  /// if the user has dismissed the paywall, returns dismissed
  SubscriptionStatus get subscriptionStatus => isSubscribed
      ? SubscriptionStatus.subscribed
      : _shouldShowPaywall
          ? SubscriptionStatus.showPaywall
          : SubscriptionStatus.dimissedPaywall;

  DateTime? get _lastDismissedPaywall {
    final lastDismissed = subscriptionBox.read(
      PLocalKey.dismissedPaywall,
    );
    if (lastDismissed == null) return null;
    return DateTime.tryParse(lastDismissed);
  }

  int? get _paywallBackoff {
    final backoff = subscriptionBox.read(
      PLocalKey.paywallBackoff,
    );
    if (backoff == null) return null;
    return backoff;
  }

  /// whether or not the paywall should be shown
  bool get _shouldShowPaywall {
    return initialized.isCompleted &&
        !isSubscribed &&
        (_lastDismissedPaywall == null ||
            DateTime.now().difference(_lastDismissedPaywall!).inHours >
                (1 * (_paywallBackoff ?? 1)));
  }

  void dismissPaywall() async {
    await subscriptionBox.write(
      PLocalKey.dismissedPaywall,
      DateTime.now().toString(),
    );

    if (_paywallBackoff == null) {
      await subscriptionBox.write(
        PLocalKey.paywallBackoff,
        1,
      );
    } else {
      await subscriptionBox.write(
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
      if (availableSubscriptionInfo?.availableSubscriptions.isEmpty ?? true) {
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
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "availableSubscriptionInfo": availableSubscriptionInfo?.toJson(),
        },
      );
    }
  }

  Future<String> getPaymentLink(
    SubscriptionDuration duration, {
    bool isPromo = false,
  }) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: _pangeaController.userController.accessToken,
    );
    final String reqUrl = Uri.encodeFull(
      "${PApiUrls.paymentLink}?pangea_user_id=$_userID&duration=${duration.value}&redeem=$isPromo",
    );
    final Response res = await req.get(url: reqUrl);
    final json = jsonDecode(res.body);
    String paymentLink = json["link"]["url"];

    final String? email = await _userController.userEmail;
    if (email != null) {
      paymentLink += "?prefilled_email=${Uri.encodeComponent(email)}";
    }
    return paymentLink;
  }

  String? get defaultManagementURL =>
      currentSubscriptionInfo?.currentSubscription
          ?.defaultManagementURL(availableSubscriptionInfo?.appIds);
}

enum SubscriptionPeriodType {
  normal,
  trial,
}

enum SubscriptionDuration {
  month,
  year,
}

extension SubscriptionDurationExtension on SubscriptionDuration {
  String get value => this == SubscriptionDuration.month ? "month" : "year";
}

class SubscriptionDetails {
  final double price;
  final SubscriptionDuration? duration;
  final String? appId;
  final String id;
  SubscriptionPeriodType periodType;
  Package? package;
  String? localizedPrice;

  SubscriptionDetails({
    required this.price,
    required this.id,
    this.duration,
    this.package,
    this.appId,
    this.periodType = SubscriptionPeriodType.normal,
  });

  void makeTrial() => periodType = SubscriptionPeriodType.trial;
  bool get isTrial => periodType == SubscriptionPeriodType.trial;

  String displayPrice(BuildContext context) => isTrial || price <= 0
      ? L10n.of(context).freeTrial
      : localizedPrice ?? "\$${price.toStringAsFixed(2)}";

  String displayName(BuildContext context) {
    if (isTrial) {
      return L10n.of(context).oneWeekTrial;
    }
    switch (duration) {
      case (SubscriptionDuration.month):
        return L10n.of(context).monthlySubscription;
      case (SubscriptionDuration.year):
        return L10n.of(context).yearlySubscription;
      default:
        return L10n.of(context).defaultSubscription;
    }
  }

  String? defaultManagementURL(SubscriptionAppIds? appIds) {
    return appId == appIds?.androidId
        ? AppConfig.googlePlayMangementUrl
        : appId == appIds?.appleId
            ? AppConfig.appleMangementUrl
            : Environment.stripeManagementUrl;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['price'] = price;
    data['id'] = id;
    data['duration'] = duration?.value;
    data['appId'] = appId;
    return data;
  }

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      price: json['price'],
      duration: SubscriptionDuration.values.firstWhereOrNull(
        (duration) => duration.value == json['duration'],
      ),
      id: json['id'],
      appId: json['appId'],
    );
  }
}
