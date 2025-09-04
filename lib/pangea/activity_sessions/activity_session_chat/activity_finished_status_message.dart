import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/saved_activity_analytics_dialog.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_model.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/course_plans/course_plans_repo.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityFinishedStatusMessage extends StatelessWidget {
  final ChatController controller;

  const ActivityFinishedStatusMessage({
    super.key,
    required this.controller,
  });

  Future<void> _onArchive(BuildContext context) async {
    {
      final resp = await showFutureLoadingDialog(
        context: context,
        future: () => _archiveToAnalytics(context),
      );

      if (!resp.isError) {
        final navigate = await showDialog(
          context: context,
          builder: (context) {
            return const SavedActivityAnalyticsDialog();
          },
        );

        if (navigate == true) {
          context.go(
            "/rooms/analytics?mode=activities",
          );
        }
      }
    }
  }

  Future<void> _archiveToAnalytics(BuildContext context) async {
    await controller.room.archiveActivity();
    await MatrixState.pangeaController.putAnalytics
        .sendActivityAnalytics(controller.room.id);

    final courseParent = controller.room.courseParent;
    if (courseParent?.coursePlan == null) return;
    final coursePlan = await CoursePlansRepo.get(
      courseParent!.coursePlan!.uuid,
    );

    if (coursePlan == null) {
      throw L10n.of(context).noCourseFound;
    }

    final activityId = controller.room.activityPlan!.activityId;
    final topicId = coursePlan.topicID(activityId);
    if (topicId == null) {
      throw L10n.of(context).activityNotFoundForCourse;
    }

    await courseParent.finishCourseActivity(activityId, topicId);
  }

  ActivitySummaryModel? get summary => controller.room.activitySummary;

  bool get _enableArchive =>
      summary?.summary != null || summary?.hasError == true;

  @override
  Widget build(BuildContext context) {
    if (!controller.room.showActivityChatUI ||
        controller.room.ownRole == null ||
        !controller.room.hasCompletedActivity) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return AnimatedSize(
      duration: FluffyThemes.animationDuration,
      child: Container(
        margin: const EdgeInsets.only(top: 20.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.dividerColor),
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              spacing: 12.0,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: controller.room.activityIsFinished
                  ? [
                      if (summary?.isLoading ?? false) ...[
                        Text(
                          L10n.of(context).generatingSummary,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(
                          height: 36.0,
                          width: 36.0,
                          child: CircularProgressIndicator(),
                        ),
                      ] else if (summary?.hasError ?? false) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.school_outlined,
                              size: 24.0,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                L10n.of(context).activitySummaryError,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => controller.room.fetchSummaries(),
                          child: Text(L10n.of(context).requestSummaries),
                        ),
                      ],
                      if (!controller.room.isHiddenActivityRoom)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                            foregroundColor:
                                theme.colorScheme.onPrimaryContainer,
                            backgroundColor: theme.colorScheme.primaryContainer,
                          ),
                          onPressed:
                              _enableArchive ? () => _onArchive(context) : null,
                          child: Row(
                            spacing: 12.0,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.radar, size: 20.0),
                              Text(
                                L10n.of(context).saveToCompletedActivities,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                    ]
                  : [
                      Text(
                        L10n.of(context).waitingForOthersToFinish,
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          foregroundColor: theme.colorScheme.onSurface,
                          backgroundColor: theme.colorScheme.surface,
                          side: BorderSide(
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                        onPressed: controller.room.continueActivity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              L10n.of(context).waitNotDone,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
