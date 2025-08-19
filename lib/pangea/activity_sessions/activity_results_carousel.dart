import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_analytics_chip.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_analytics_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_response_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';

class ActivityResultsCarousel extends StatelessWidget {
  final String userId;
  final ActivityRoleModel selectedRole;
  final ParticipantSummaryModel summary;
  final ActivitySummaryAnalyticsModel? analytics;

  final User? user;

  const ActivityResultsCarousel({
    super.key,
    required this.userId,
    required this.selectedRole,
    required this.summary,
    required this.analytics,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      padding: const EdgeInsets.all(12.0),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: isColumnMode ? 80.0 : 125.0,
            child: SingleChildScrollView(
              child: Text(
                summary.feedback,
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              if (analytics != null)
                ActivityAnalyticsChip(
                  ConstructTypeEnum.vocab.indicator.icon,
                  "${analytics!.uniqueConstructCountForUser(userId, ConstructTypeEnum.vocab)}",
                ),
              if (analytics != null)
                ActivityAnalyticsChip(
                  ConstructTypeEnum.morph.indicator.icon,
                  "${analytics!.uniqueConstructCountForUser(userId, ConstructTypeEnum.morph)}",
                ),
              ActivityAnalyticsChip(
                Icons.school,
                summary.cefrLevel,
              ),
              ...summary.superlatives.map(
                (sup) => Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    sup,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
