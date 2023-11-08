import 'dart:async';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/pages/settings_subscription/settings_subscription_view.dart';
import 'package:fluffychat/pangea/utils/subscription_app_id.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SubscriptionManagement extends StatefulWidget {
  const SubscriptionManagement({Key? key}) : super(key: key);

  @override
  SubscriptionManagementController createState() =>
      SubscriptionManagementController();
}

class SubscriptionManagementController extends State<SubscriptionManagement> {
  final PangeaController pangeaController = MatrixState.pangeaController;
  SubscriptionDetails? selectedSubscription;
  late StreamSubscription _settingsSubscription;

  @override
  void initState() {
    _settingsSubscription =
        pangeaController.subscriptionController.stateStream.listen((event) {
      debugPrint("stateStream event in subscription settings");
      setState(() {});
    });
    pangeaController.subscriptionController.updateCustomerInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _settingsSubscription.cancel();
  }

  bool get currentSubscriptionAvailable =>
      pangeaController.subscriptionController.currentSubscriptionAvailable;

  String? get purchasePlatformDisplayName => pangeaController
      .subscriptionController.subscription?.purchasePlatformDisplayName;

  bool get currentSubscriptionIsPromotional =>
      pangeaController.subscriptionController.subscription
          ?.currentSubscriptionIsPromotional ??
      false;

  bool get showManagementOptions {
    if (!currentSubscriptionAvailable) {
      return false;
    }
    if (pangeaController.subscriptionController.subscription!.purchasedOnWeb) {
      return true;
    }
    return pangeaController.subscriptionController.subscription!
        .currentPlatformMatchesPurchasePlatform;
  }

  Future<void> launchMangementUrl(ManagementOption option) async {
    String managementUrl = Environment.stripeManagementUrl;
    final String? email = await pangeaController.userController.userEmail;
    if (email != null) {
      managementUrl += "?prefilled_email=${Uri.encodeComponent(email)}";
    }
    final String? purchaseAppId = pangeaController
        .subscriptionController.subscription?.currentSubscription?.appId!;
    if (purchaseAppId == null) return;

    final SubscriptionAppIds? appIds =
        pangeaController.subscriptionController.subscription!.appIds;

    if (purchaseAppId == appIds?.stripeId) {
      launchUrlString(managementUrl);
      return;
    }
    if (purchaseAppId == appIds?.appleId) {
      launchUrlString(
        AppConfig.appleMangementUrl,
        mode: LaunchMode.externalApplication,
      );
      return;
    }
    switch (option) {
      case ManagementOption.history:
        launchUrlString(
          AppConfig.googlePlayHistoryUrl,
          mode: LaunchMode.externalApplication,
        );
        break;
      case ManagementOption.paymentMethod:
        launchUrlString(
          AppConfig.googlePlayPaymentMethodUrl,
          mode: LaunchMode.externalApplication,
        );
        break;
      default:
        launchUrlString(
          AppConfig.googlePlayMangementUrl,
          mode: LaunchMode.externalApplication,
        );
        break;
    }
  }

  void selectSubscription(SubscriptionDetails? subscription) {
    setState(() => selectedSubscription = subscription);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSubscriptionView(this);
  }
}

enum ManagementOption {
  cancel,
  paymentMethod,
  history,
}
