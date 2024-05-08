import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:tawkie/config/subscription.dart';
import 'package:tawkie/utils/platform_infos.dart';
import 'opacity_gradient_image.dart';

class SubscriptionContent extends StatelessWidget {
  const SubscriptionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OpacityGradientImage(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitle(context),
                const SizedBox(height: 20.0),
                Expanded(child: _buildSubscriptionDetails(context)),
                const SizedBox(height: 20.0),
                NextButton(
                  onPressed: () {
                    if (PlatformInfos.shouldInitializePurchase()) {
                      SubscriptionManager()
                          .checkSubscriptionStatusAndRedirect();
                    } else {
                      // Todo: make purchases for Web, Windows and Linux
                    }
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                if (PlatformInfos.shouldInitializePurchase())
                  const RestoreSubscriptionButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildTitle(BuildContext context) {
  return Text(
    L10n.of(context)!.subNotSubTitle,
    style: const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    textAlign: TextAlign.center,
  );
}

Widget _buildSubscriptionDetails(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _buildSubscriptionDetailText(L10n.of(context)!.subNotSubArgOne),
      _buildSubscriptionDetailText(L10n.of(context)!.subNotSubArgTwo),
      _buildSubscriptionDetailText(L10n.of(context)!.subNotSubArgThree),
      _buildSubscriptionDetailText(L10n.of(context)!.subNotSubArgFour),
    ],
  );
}

Widget _buildSubscriptionDetailText(String text) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          Icons.fiber_manual_record,
          size: 12.0,
          color: Colors.white,
        ),
      ),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}

class RestoreSubscriptionButton extends StatelessWidget {
  const RestoreSubscriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              title: Text(L10n.of(context)!.subNotFound),
              content: Text(L10n.of(context)!.subNotFoundText),
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
        L10n.of(context)!.subRestore,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      child: Text(
        L10n.of(context)!.next,
        style: const TextStyle(
          fontSize: 20.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}
