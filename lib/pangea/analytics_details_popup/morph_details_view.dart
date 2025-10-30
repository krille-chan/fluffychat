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
  MorphFeaturesEnum get _morphFeature =>
      MorphFeaturesEnumExtension.fromString(constructId.category);
  String get _morphTag => constructId.lemma;

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).brightness != Brightness.light
        ? _construct.lemmaCategory.color(context)
        : _construct.lemmaCategory.darkColor(context);

    return AnalyticsDetailsViewContent(
      subtitle: MorphFeatureDisplay(morphFeature: _morphFeature),
      title: MorphTagDisplay(
        morphFeature: _morphFeature,
        morphTag: _morphTag,
        textColor: textColor,
      ),
      headerContent: MorphMeaningWidget(
        feature: _morphFeature,
        tag: _morphTag,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      xpIcon: ConstructXpWidget(id: constructId),
      constructId: constructId,
    );
  }
}
