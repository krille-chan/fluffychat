import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup_content.dart';
import 'package:fluffychat/pangea/analytics_details_popup/morph_meaning_widget.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/lemmas/construct_xp_widget.dart';
import 'package:fluffychat/pangea/morphs/morph_feature_display.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_tag_display.dart';

class MorphDetailsView extends StatelessWidget {
  final ConstructIdentifier constructId;

  const MorphDetailsView({
    required this.constructId,
    super.key,
  });

  ConstructUses get _construct => constructId.constructUses;
  String get _morphFeature => constructId.category;
  String get _morphTag => constructId.lemma;

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).brightness != Brightness.light
        ? _construct.lemmaCategory.color(context)
        : _construct.lemmaCategory.darkColor(context);

    return AnalyticsDetailsViewContent(
      subtitle: MorphFeatureDisplay(morphFeature: _morphFeature),
      title: MorphTagDisplay(
        morphFeature: MorphFeaturesEnumExtension.fromString(_morphFeature),
        morphTag: _morphTag,
        textColor: textColor,
      ),
      headerContent: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: MorphMeaningWidget(
                feature: _morphFeature,
                tag: _morphTag,
                style: Theme.of(context).textTheme.bodyLarge,
                // leading: TextSpan(
                //   text: L10n.of(context).meaningSectionHeader,
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
      // headerContent: Padding(
      //   padding: const EdgeInsets.all(25.0),
      //   child: Align(
      //     alignment: Alignment.topLeft,
      //     child: FutureBuilder(
      //       future: _getDefinition(context),
      //       builder: (
      //         BuildContext context,
      //         AsyncSnapshot<String?> snapshot,
      //       ) {
      //         if (snapshot.hasData) {
      //           return MorphMeaningWidget(
      //             feature: _morphFeature,
      //             tag: _morphTag,
      //             style: Theme.of(context).textTheme.bodyLarge,
      //             leading: TextSpan(
      //               text: L10n.of(context).meaningSectionHeader,
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           );
      //         } else if (snapshot.hasError) {
      //           return Wrap(
      //             children: [
      //               Text(
      //                 L10n.of(context).meaningSectionHeader,
      //                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //               ),
      //               const SizedBox(
      //                 width: 10,
      //               ),
      //               Text(
      //                 L10n.of(context).meaningNotFound,
      //                 style: Theme.of(context).textTheme.bodyLarge,
      //               ),
      //             ],
      //           );
      //         } else {
      //           return Wrap(
      //             children: [
      //               Text(
      //                 L10n.of(context).meaningSectionHeader,
      //                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //               ),
      //               const SizedBox(
      //                 width: 10,
      //               ),
      //               const TextLoadingShimmer(width: 100),
      //             ],
      //           );
      //         }
      //       },
      //     ),
      //   ),
      // ),
      xpIcon: ConstructXpWidget(id: constructId),
      constructId: constructId,
    );
  }
}
