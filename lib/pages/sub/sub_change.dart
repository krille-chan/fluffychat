import 'dart:developer';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tawkie/pages/add_bridge/error_message_dialog.dart';

class SubscriptionChangePage extends StatelessWidget {
  final Offerings? offerings;
  final String activeSubscriptionId;
  final String? expirationDate;

  const SubscriptionChangePage({
    super.key,
    required this.offerings,
    required this.activeSubscriptionId,
    this.expirationDate,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> activeSubscriptionCards = [];
    List<Widget> inactiveSubscriptionCards = [];

    if (offerings != null) {
      for (final package in offerings!.current!.availablePackages) {
        final isActive =
            package.storeProduct.identifier == activeSubscriptionId;
        final card = SubscriptionCard(
          name: package.storeProduct.title,
          price: package.storeProduct.priceString,
          description: package.storeProduct.description,
          isActive: isActive,
          onChangeSubscription: !isActive
              ? () => _showConfirmationDialog(context, package)
              : null,
          expirationDate: expirationDate,
        );
        if (isActive) {
          activeSubscriptionCards.add(card);
        } else {
          inactiveSubscriptionCards.add(card);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        if (activeSubscriptionCards.isNotEmpty) ...activeSubscriptionCards,
        if (Platform.isIOS)
          Text(
            L10n.of(context)!.sub_changeAfterExp,
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 20),
        Text(
          L10n.of(context)!.sub_availableSubs,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        if (inactiveSubscriptionCards.isNotEmpty) ...inactiveSubscriptionCards,
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, Package package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '${L10n.of(context)!.sub_changeSub} ${package.storeProduct.title}'),
          content: Text(L10n.of(context)!.sub_changeSubText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(L10n.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                showFutureLoadingDialog(
                    context: context,
                    future: () => _onChangeSubscription(context, package));
              },
              child: Text(L10n.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onChangeSubscription(
      BuildContext context, Package package) async {
    try {
      GoogleProductChangeInfo? googleProductChangeInfo;
      // Creation of a GoogleProductChangeInfo object with the old Google product ID and proration information if necessary
      // Only for google android
      if (activeSubscriptionId.isNotEmpty) {
        googleProductChangeInfo = GoogleProductChangeInfo(
          activeSubscriptionId, // Old Google product ID
        );
      }

      //  Purchase by passing googleProductChangeInfo to purchasePackage
      final CustomerInfo customerInfo = await Purchases.purchasePackage(package,
          googleProductChangeInfo: googleProductChangeInfo);

      log("The subscription has been purchased");
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        log("Error: $e");
      }
      showCatchErrorDialog(context, e);
    }
  }
}

class SubscriptionCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final String? expirationDate;
  final bool isActive;
  final VoidCallback? onChangeSubscription;

  const SubscriptionCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    this.expirationDate,
    required this.isActive,
    this.onChangeSubscription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          if (isActive)
            Text(
              L10n.of(context)!.sub_subStatus,
              style: const TextStyle(fontSize: 16, color: Colors.green),
            )
          else
            ElevatedButton(
              onPressed: onChangeSubscription,
              child: Text(L10n.of(context)!.sub_changeButton),
            ),
          if (isActive && expirationDate != null)
            Text("${L10n.of(context)!.sub_renewedOn} $expirationDate"),
        ],
      ),
    );
  }
}
