import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_participant_indicator.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_results_carousel.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityFinishedStatusMessage extends StatelessWidget {
  final ChatController controller;

  const ActivityFinishedStatusMessage({
    super.key,
    required this.controller,
  });

  Map<String, ActivityRole> get _roles =>
      controller.room.activityPlan?.roles ?? {};

  Future<void> _archiveToAnalytics() async {
    await controller.room.archiveActivity();
    await MatrixState.pangeaController.putAnalytics
        .sendActivityAnalytics(controller.room.id);
  }

  List<ActivityRoleModel> get _rolesWithSummaries {
    if (controller.room.activitySummary?.summary == null) {
      return <ActivityRoleModel>[];
    }

    final roles = controller.room.activityRoles;
    return roles?.roles.values.where((role) {
          return controller.room.activitySummary!.summary!.participants.any(
            (p) => p.participantId == role.userId,
          );
        }).toList() ??
        [];
  }

  ActivityRoleModel? get _highlightedRole {
    if (controller.highlightedRole != null) {
      return controller.highlightedRole;
    }

    return _rolesWithSummaries.firstWhereOrNull(
      (r) => r.userId == controller.room.client.userID,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.room.showActivityChatUI ||
        !controller.room.activityIsFinished) {
      return const SizedBox.shrink();
    }

    final summary = controller.room.activitySummary;

    final theme = Theme.of(context);

    final user = controller.room.getParticipants().firstWhereOrNull(
          (u) => u.id == _highlightedRole?.userId,
        );

    final userSummary =
        controller.room.activitySummary?.summary?.participants.firstWhereOrNull(
      (p) => p.participantId == _highlightedRole?.userId,
    );

    return AnimatedSize(
      duration: FluffyThemes.animationDuration,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: const BoxConstraints(
            maxWidth: FluffyThemes.columnWidth * 1.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (summary?.summary != null) ...[
                Text(
                  L10n.of(context).activityFinishedMessage,
                  style: const TextStyle(fontSize: 18.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    summary!.summary!.summary,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                if (_highlightedRole != null && userSummary != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                      ),
                      child: Column(
                        children: [
                          ActivityResultsCarousel(
                            selectedRole: _highlightedRole!,
                            user: user,
                            summary: userSummary,
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: _rolesWithSummaries.map(
                              (role) {
                                final user = controller.room
                                    .getParticipants()
                                    .firstWhereOrNull(
                                      (u) => u.id == role.userId,
                                    );

                                return IntrinsicWidth(
                                  child: ActivityParticipantIndicator(
                                    availableRole: _roles[role.id]!,
                                    avatarUrl: _roles[role.id]?.avatarUrl ??
                                        user?.avatarUrl?.toString(),
                                    onTap: _highlightedRole == role
                                        ? null
                                        : () => controller.highlightRole(role),
                                    assignedRole: role,
                                    selected: _highlightedRole == role,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 24.0,
                                    ),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20.0),
              ] else if (summary?.isLoading ?? false)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 8.0,
                    children: [
                      const CircularProgressIndicator.adaptive(),
                      Text(L10n.of(context).loadingActivitySummary),
                    ],
                  ),
                )
              else if (summary?.hasError ?? false)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 8.0,
                    children: [
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
                  ),
                ),
              if (!controller.room.isHiddenActivityRoom)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                    backgroundColor: theme.colorScheme.primaryContainer,
                  ),
                  onPressed: () async {
                    final resp = await showFutureLoadingDialog(
                      context: context,
                      future: _archiveToAnalytics,
                    );

                    if (!resp.isError) {
                      context.go(
                        "/rooms/analytics?mode=activities",
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(L10n.of(context).archiveToAnalytics),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
