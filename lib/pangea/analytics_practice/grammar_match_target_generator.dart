import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_practice_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/example_message_util.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_constants.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_session_model.dart';
import 'package:fluffychat/pangea/constructs/construct_form.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/lemmas/lemma.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_repo.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';
import 'package:fluffychat/widgets/matrix.dart';

class GrammarMatchTargetGenerator {
  static ActivityTypeEnum activityType = ActivityTypeEnum.grammarCategory;

  static Future<List<AnalyticsActivityTarget>> get(
    List<ConstructUses> constructs,
  ) async {
    // Score and sort by priority (highest first). Uses shared scorer for
    // consistent prioritization with message practice.
    final sortedConstructs = constructs.practiceSort(activityType);

    final Set<String> seenForms = {};
    final cutoffTime = DateTime.now().subtract(const Duration(hours: 24));

    final morphInfoResult = await MorphsRepo.get(
      MatrixState.pangeaController.userController.userL2,
    );

    // Build list of features with multiple tags (valid for practice)
    final List<String> validFeatures = morphInfoResult.features
        .where((f) => f.tags.length > 1)
        .map((f) => f.feature)
        .toList();

    final targets = <AnalyticsActivityTarget>[];

    for (final construct in sortedConstructs) {
      if (targets.length >= AnalyticsPracticeConstants.targetsToGenerate) {
        break;
      }

      final feature = MorphFeaturesEnumExtension.fromString(construct.category);

      // Only include features that are in the valid list (have multiple tags)
      if (feature == MorphFeaturesEnum.Unknown ||
          (validFeatures.isNotEmpty && !validFeatures.contains(feature.name))) {
        continue;
      }

      final lastPracticeUse = construct.lastUseByTypes(
        activityType.associatedUseTypes,
      );

      if (lastPracticeUse != null && lastPracticeUse.isAfter(cutoffTime)) {
        continue;
      }

      List<InlineSpan>? exampleMessage;
      final constructForms = construct.cappedUses
          .where((u) => u.form != null)
          .map((u) => ConstructForm(form: u.form!, cId: construct.id))
          .toSet();

      for (final form in constructForms) {
        if (targets.length >= AnalyticsPracticeConstants.targetsToGenerate) {
          break;
        }

        if (seenForms.contains(form.form)) continue;
        seenForms.add(form.form);

        exampleMessage = await ExampleMessageUtil.getExampleMessage(
          construct,
          form: form.form,
        );
        if (exampleMessage == null) continue;

        final token = PangeaToken(
          lemma: Lemma(text: form.form, saveVocab: true, form: form.form),
          text: PangeaTokenText.fromString(form.form),
          pos: 'other',
          morph: {feature: form.cId.lemma},
        );

        targets.add(
          AnalyticsActivityTarget(
            target: PracticeTarget(
              tokens: [token],
              activityType: activityType,
              morphFeature: feature,
            ),
            exampleMessage: ExampleMessageInfo(exampleMessage: exampleMessage),
          ),
        );
        break;
      }
    }

    return targets;
  }
}
