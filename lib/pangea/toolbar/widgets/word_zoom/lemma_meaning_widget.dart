import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/text_loading_shimmer.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_builder.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaMeaningWidget extends StatelessWidget {
  final LemmaMeaningBuilderState controller;

  final ConstructUses constructUse;
  final TextStyle? style;
  final InlineSpan? leading;

  const LemmaMeaningWidget({
    super.key,
    required this.controller,
    required this.constructUse,
    this.style,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const TextLoadingShimmer();
    }

    if (controller.error != null) {
      if (controller.error is UnsubscribedException) {
        return ErrorIndicator(
          message: L10n.of(context).subscribeToUnlockDefinitions,
          style: style,
          onTap: () {
            MatrixState.pangeaController.subscriptionController
                .showPaywall(context);
          },
        );
      }
      return ErrorIndicator(
        message: L10n.of(context).errorFetchingDefinition,
        style: style,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: RichText(
            textAlign: leading == null ? TextAlign.center : TextAlign.start,
            text: TextSpan(
              style: style,
              children: [
                if (leading != null) leading!,
                if (leading != null)
                  const WidgetSpan(child: SizedBox(width: 6.0)),
                TextSpan(
                  text: controller.lemmaInfo?.meaning,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
