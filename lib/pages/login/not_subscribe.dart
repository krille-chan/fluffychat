import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/config/subscription.dart';
import 'package:tawkie/utils/platform_infos.dart';

class NotSubscribePage extends StatefulWidget {
  const NotSubscribePage({Key? key}) : super(key: key);

  @override
  State<NotSubscribePage> createState() => _NotSubscribePageState();
}

class _NotSubscribePageState extends State<NotSubscribePage> {
  @override
  void initState() {
    super.initState();

    // Listener for subscription updates
    Purchases.addCustomerInfoUpdateListener((info) {
      if (info.entitlements.active.isNotEmpty) {
        //user has access to some entitlement
        _redirectToRooms();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // White Container with Opacity Gradient
          Container(
            height: 260,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.9), // Opacity at the top
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0), // Opacity at the bottom
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/no_sub.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                height: 260,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    L10n.of(context)!.sub_not_sub_title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    L10n.of(context)!.sub_not_sub_arg_one,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    L10n.of(context)!.sub_not_sub_arg_two,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    L10n.of(context)!.sub_not_sub_arg_three,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    L10n.of(context)!.sub_not_sub_arg_four,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (PlatformInfos.shouldInitializePurchase()) {
                        SubscriptionManager()
                            .checkSubscriptionStatusAndRedirect();
                      } else {
                        // Todo: make purchases for Web, Windows and Linux
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(
                      L10n.of(context)!.next,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  if (PlatformInfos.shouldInitializePurchase())
                    InkWell(
                      onTap: () async {
                        final success = await showFutureLoadingDialog<bool>(
                          context: context,
                          future: SubscriptionManager().restoreSub,
                        );

                        if (success.result == false) {
                          // Show a dialog indicating no subscription found
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(L10n.of(context)!.sub_notFound),
                              content: Text(L10n.of(context)!.sub_notFoundText),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(L10n.of(context)!.ok),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text(
                        L10n.of(context)!.sub_restore,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to redirect to the '/rooms' page
  void _redirectToRooms() {
    context.go('/rooms');
  }
}
