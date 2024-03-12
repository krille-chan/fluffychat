import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionView> {
  List<Package>? _packages;
  bool _loadingFailed = false;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
  }

  Future<void> _fetchOfferings() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        setState(() {
          _packages = offerings.current?.availablePackages;
        });
      } else {
        // Handle case where offerings are empty
        setState(() {
          _loadingFailed = true;
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        _loadingFailed = true;
      });
    }
  }

  Future<void> _purchasePackage(Package package) async {
    try {
      final CustomerInfo customerInfo =
          await Purchases.purchasePackage(package);
      if (customerInfo.entitlements.all["tawkie_sub"]!.isActive) {
        // Unlock premium content
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print("error: $e");
        //showError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.subscription),
      ),
      body: _buildSubscriptionList(),
    );
  }

  Widget _buildSubscriptionList() {
    if (_loadingFailed) {
      // Afficher un message d'erreur si le chargement des offres a échoué
      return const Center(
        child:
            Text('Erreur réseau. Veuillez vérifier votre connexion internet.'),
      );
    } else if (_packages == null) {
      // Afficher un indicateur de chargement si les packages ne sont pas encore chargés
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Afficher la liste des packages
      return ListView.builder(
        itemCount: _packages!.length,
        itemBuilder: (context, index) {
          final Package package = _packages![index];
          return ListTile(
            title: Text(package.identifier),
            subtitle: Text('Price: ${package.storeProduct.priceString}'),
            onTap: () {
              // Handle onTap to purchase package
              _purchasePackage(package);
            },
          );
        },
      );
    }
  }
}
