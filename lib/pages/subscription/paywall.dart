import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'model/singletons_data.dart';
import 'model/style.dart';

class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({super.key, required this.offering});

  @override
  State<Paywall> createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  Map<String, IntroEligibilityStatus> eligibilityStatusMap = {};

  @override
  void initState() {
    super.initState();
    checkEligibility(); // Check eligibility for page load (iOS)
  }

  Future<void> checkEligibility() async {
    try {
      // Check eligibility with available product identifiers
      final Map<String, IntroEligibility> eligibilityMap =
          await Purchases.checkTrialOrIntroductoryPriceEligibility(
        widget.offering.availablePackages
            .map((package) => package.identifier)
            .toList(),
      );

      print(eligibilityMap);

      // Check if the user is eligible for the trial period for all available offers
      bool allEligible = true;
      for (var package in widget.offering.availablePackages) {
        print(eligibilityMap[package.identifier]?.status);
        var eligibility = eligibilityMap[package.identifier]?.status ??
            IntroEligibilityStatus.introEligibilityStatusUnknown;
        if (eligibility !=
            IntroEligibilityStatus.introEligibilityStatusEligible) {
          allEligible = false;
          break;
        }
      }

      // MAJ interface
      setState(() {
        if (allEligible) {
          eligibilityStatusMap = Map.fromIterable(
            eligibilityMap.entries,
            key: (entry) => entry.key,
            value: (entry) => entry.value.status,
          );
        } else {
          eligibilityStatusMap.clear();
        }
      });
    } catch (e) {
      print('Error checking eligibility: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEligibleForAll = eligibilityStatusMap.isNotEmpty;

    print("Eligibilité: $isEligibleForAll");
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
                    child: Image.asset(
                      'assets/logo.png',
                    ),
                  ),
                  Text('Tawkie', style: kTitleTextStyle)
                ],
              )),
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
                          final CustomerInfo customerInfo =
                              await Purchases.purchasePackage(
                                  myProductList[index]);
                          final EntitlementInfo? entitlement =
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
            isEligibleForAll
                ? Text("Vous êtes éligible à un mois d'essai")
                : Container(),
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
