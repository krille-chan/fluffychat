import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/pages/settings_subscription/settings_subscription_view.dart';
import 'package:fluffychat/pangea/utils/subscription_app_id.dart';
import 'package:fluffychat/pangea/widgets/subscription/subscription_snackbar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SubscriptionManagement extends StatefulWidget {
  const SubscriptionManagement({super.key});

  @override
  SubscriptionManagementController createState() =>
      SubscriptionManagementController();
}

class SubscriptionManagementController extends State<SubscriptionManagement> {
  final SubscriptionController subscriptionController =
      MatrixState.pangeaController.subscriptionController;
  SubscriptionDetails? selectedSubscription;
  late StreamSubscription _settingsSubscription;
  StreamSubscription? _subscriptionStatusStream;

  @override
  void initState() {
    if (!subscriptionController.initialized) {
      subscriptionController.initialize().then((_) => setState(() {}));
    }

    _settingsSubscription = subscriptionController.stateStream.listen((event) {
      debugPrint("stateStream event in subscription settings");
      setState(() {});
    });

    _subscriptionStatusStream ??=
        subscriptionController.subscriptionStream.stream.listen((_) {
      showSubscribedSnackbar(context);
      context.go('/rooms');
    });

    subscriptionController.updateCustomerInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _settingsSubscription.cancel();
    _subscriptionStatusStream?.cancel();
  }

  bool get subscriptionsAvailable =>
      subscriptionController.subscription?.availableSubscriptions.isNotEmpty ??
      false;

  bool get currentSubscriptionAvailable =>
      subscriptionController.isSubscribed &&
      subscriptionController.subscription?.currentSubscription != null;

  String? get purchasePlatformDisplayName =>
      subscriptionController.subscription?.purchasePlatformDisplayName;

  bool get currentSubscriptionIsPromotional =>
      subscriptionController.subscription?.currentSubscriptionIsPromotional ??
      false;

  bool get isNewUserTrial =>
      subscriptionController.subscription?.isNewUserTrial ?? false;

  String get currentSubscriptionTitle =>
      subscriptionController.subscription?.currentSubscription
          ?.displayName(context) ??
      "";

  String get currentSubscriptionPrice =>
      subscriptionController.subscription?.currentSubscription
          ?.displayPrice(context) ??
      "";

  bool get showManagementOptions {
    if (!currentSubscriptionAvailable) {
      return false;
    }
    if (subscriptionController.subscription!.purchasedOnWeb) {
      return true;
    }
    return subscriptionController
        .subscription!.currentPlatformMatchesPurchasePlatform;
  }

  void submitChange({bool isPromo = false}) {
    try {
      subscriptionController.submitSubscriptionChange(
        selectedSubscription,
        context,
        isPromo: isPromo,
      );
      setState(() {});
    } catch (err) {
      showOkAlertDialog(
        context: context,
        title: L10n.of(context)!.oopsSomethingWentWrong,
        message: L10n.of(context)!.errorPleaseRefresh,
        okLabel: L10n.of(context)!.close,
      );
    }
  }

  Future<void> launchMangementUrl(ManagementOption option) async {
    String managementUrl = Environment.stripeManagementUrl;
    final String? email =
        await MatrixState.pangeaController.userController.userEmail;
    if (email != null) {
      managementUrl += "?prefilled_email=${Uri.encodeComponent(email)}";
    }
    final String? purchaseAppId =
        subscriptionController.subscription?.currentSubscription?.appId!;
    if (purchaseAppId == null) return;

    final SubscriptionAppIds? appIds =
        subscriptionController.subscription!.appIds;

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
  Widget build(BuildContext context) => SettingsSubscriptionView(this);
}

enum ManagementOption {
  cancel,
  paymentMethod,
  history,
}
