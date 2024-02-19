import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/widgets/common/bot_face_svg.dart';
import 'package:fluffychat/pangea/widgets/igc/card_header.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:shimmer/shimmer.dart';

class PaywallCard extends StatelessWidget {
  const PaywallCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CardHeader(
          text: L10n.of(context)!.subscriptionPopupTitle,
          botExpression: BotExpression.addled,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const OptionsShimmer(),
              const SizedBox(height: 15.0),
              Text(
                L10n.of(context)!.subscriptionPopupDesc,
                style: BotStyle.text(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    MatrixState.pangeaController.subscriptionController
                        .showPaywall(context);
                    MatrixState.pAnyState.closeOverlay();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      (AppConfig.primaryColor).withOpacity(0.1),
                    ),
                  ),
                  child: Text(L10n.of(context)!.seeOptions),
                ),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      AppConfig.primaryColor.withOpacity(0.1),
                    ),
                  ),
                  onPressed: () {
                    MatrixState.pangeaController.subscriptionController
                        .dismissPaywall();
                    MatrixState.pAnyState.closeOverlay();
                  },
                  child: Center(
                    child: Text(L10n.of(context)!.continuedWithoutSubscription),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OptionsShimmer extends StatelessWidget {
  const OptionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      direction: ShimmerDirection.ltr,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(
          3,
          (_) => Container(
            margin: const EdgeInsets.all(2),
            padding: EdgeInsets.zero,
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 7),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {},
              child: Text(
                "",
                style: BotStyle.text(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
