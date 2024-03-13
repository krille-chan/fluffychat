import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tawkie/pages/subscription/purchase_manager.dart';

import 'model/singletons_data.dart';
import 'model/style.dart';

class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({super.key, required this.offering});

  @override
  State<Paywall>  createState() => _PaywallState();
}


class _PaywallState extends State<Paywall> {
  Map<String, IntroEligibility> eligibilityMap = {};

  @override
  void initState() {
    super.initState();
    checkEligibility(); // Check eligibility for page load (iOS)
  }

  Future<void> checkEligibility() async {
    try {
      eligibilityMap = await PurchaseManager.checkTrialOrIntroductoryPriceEligibility(
          widget.offering.availablePackages.map((package) => package.identifier).toList());

      // Mise à jour l'interface utilisateur après avoir obtenu les résultats de l'éligibilité
      setState(() {});
    } catch (e) {
      print('Error checking eligibility: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            Container(
              height: 70.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: kColorNavIcon,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(25.0))),
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Image.asset('assets/logo.png',),
                    ),
                      Text('✨Tawkie', style: kTitleTextStyle)
                    ],
                  )
                  ),
            ),
            const Padding(
              padding:
              EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                child: Text(
                  'Tawkie Subscription',
                  style: kDescriptionTextStyle,
                ),
                width: double.infinity,
              ),
            ),
            ListView.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (BuildContext context, int index) {
                var myProductList = widget.offering.availablePackages;
                return Card(
                  color: Colors.black,
                  child: ListTile(
                      onTap: () async {
                        try {
                          CustomerInfo customerInfo =
                          await Purchases.purchasePackage(
                              myProductList[index]);
                          EntitlementInfo? entitlement =
                          customerInfo.entitlements.all['tawkie_sub'];
                          appData.entitlementIsActive =
                              entitlement?.isActive ?? false;
                        } catch (e) {
                          print(e);
                        }

                        setState(() {});
                        Navigator.pop(context);
                      },
                      title: Text(
                        myProductList[index].storeProduct.title,
                        style: kTitleTextStyle,
                      ),
                      subtitle: Text(
                        myProductList[index].storeProduct.description,
                        style: kDescriptionTextStyle.copyWith(
                            fontSize: kFontSizeSuperSmall),
                      ),
                      trailing: Text(
                          myProductList[index].storeProduct.priceString,
                          style: kTitleTextStyle)),
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            ),
            const Padding(
              padding:
              EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                child: Text(
                  """Don't forget to add subscription terms and conditions. 

Read more about this here: https://www.tawkie.com""",
                  style: kDescriptionTextStyle,
                ),
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}