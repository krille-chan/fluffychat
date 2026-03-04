import 'package:fluffychat/pangea/analytics_misc/construct_practice_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_constants.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_session_model.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';

class VocabMeaningTargetGenerator {
  static ActivityTypeEnum activityType = ActivityTypeEnum.lemmaMeaning;

  static Future<List<AnalyticsActivityTarget>> get(
    List<ConstructUses> constructs,
  ) async {
    // Score and sort by priority (highest first). Uses shared scorer for
    // consistent prioritization with message practice.
    final sortedConstructs = constructs.practiceSort(activityType);

    final Set<String> seenLemmas = {};
    final cutoffTime = DateTime.now().subtract(const Duration(hours: 24));

    final targets = <AnalyticsActivityTarget>[];
    for (final construct in sortedConstructs) {
      if (seenLemmas.contains(construct.lemma)) continue;

      final lastPracticeUse = construct.lastUseByTypes(
        activityType.associatedUseTypes,
      );

      if (lastPracticeUse != null && lastPracticeUse.isAfter(cutoffTime)) {
        continue;
      }

      seenLemmas.add(construct.lemma);

      if (!construct.cappedUses.any(
        (u) => u.metadata.eventId != null && u.metadata.roomId != null,
      )) {
        // Skip if no uses have eventId + roomId, so example message can be fetched.
        continue;
      }

      targets.add(
        AnalyticsActivityTarget(
          target: PracticeTarget(
            tokens: [construct.id.asToken],
            activityType: activityType,
          ),
        ),
      );
      if (targets.length >= AnalyticsPracticeConstants.targetsToGenerate) {
        break;
      }
    }
    return targets;
  }
}
