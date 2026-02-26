import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_feedback/activity_feedback_repo.dart';
import 'package:fluffychat/pangea/activity_feedback/activity_feedback_request.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_button_widget.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_start/activity_session_start_page.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_summary_widget.dart';
import 'package:fluffychat/pangea/chat_settings/utils/room_summary_extension.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/feedback_dialog.dart';
import 'package:fluffychat/pangea/common/widgets/feedback_response_dialog.dart';
import 'package:fluffychat/pangea/course_chats/open_roles_indicator.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/activity_summaries_provider.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/course_activity_repo.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/member_actions_popup_menu_button.dart';

class ActivitySessionStartView extends StatelessWidget {
  final ActivitySessionStartController controller;
  const ActivitySessionStartView(this.controller, {super.key});

  Future<void> _submitActivityFeedback(BuildContext context) async {
    final feedback = await showDialog<String?>(
      context: context,
      builder: (context) {
        return FeedbackDialog(
          title: L10n.of(context).feedbackTitle,
          onSubmit: (feedback) {
            Navigator.of(context).pop(feedback);
          },
          scrollable: false,
        );
      },
    );

    if (feedback == null || feedback.isEmpty) {
      return;
    }

    final resp = await showFutureLoadingDialog(
      context: context,
      future: () => ActivityFeedbackRepo.submitFeedback(
        ActivityFeedbackRequest(
          activityId: controller.widget.activityId,
          feedbackText: feedback,
          userId: Matrix.of(context).client.userID!,
          userL1: MatrixState.pangeaController.userController.userL1Code!,
          userL2: MatrixState.pangeaController.userController.userL2Code!,
        ),
      ),
    );

    if (resp.isError) {
      return;
    }

    CourseActivityRepo.setSentFeedback(
      controller.widget.activityId,
      MatrixState.pangeaController.userController.userL1Code!,
    );

    await showDialog(
      context: context,
      builder: (context) {
        return FeedbackResponseDialog(
          title: L10n.of(context).feedbackTitle,
          feedback: resp.result!.userFriendlyResponse,
          description: L10n.of(context).feedbackRespDesc,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Matrix.of(
        context,
      ).client.onRoomState.stream.rateLimit(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 52.0,
            title: controller.activity == null
                ? null
                : Center(
                    child: Text(
                      controller.activity!.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: !FluffyThemes.isColumnMode(context)
                          ? const TextStyle(fontSize: 16)
                          : null,
                    ),
                  ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.flag_outlined),
                onPressed: () => _submitActivityFeedback(context),
              ),
            ],
          ),
          body: SafeArea(
            child: controller.loading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : controller.error != null
                ? Center(
                    child: ErrorIndicator(
                      message: L10n.of(context).activityNotFound,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 600.0),
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                ActivitySummary(
                                  activity: controller.activity!,
                                  room: controller.activityRoom,
                                  course: controller.courseParent,
                                  showInstructions: controller.showInstructions,
                                  toggleInstructions:
                                      controller.toggleInstructions,
                                  onTapParticipant: controller.selectRole,
                                  isParticipantSelected:
                                      controller.isParticipantSelected,
                                  isParticipantShimmering:
                                      controller.isParticipantShimmering,
                                  canSelectParticipant:
                                      controller.canSelectParticipant,
                                  assignedRoles: controller.assignedRoles,
                                ),
                                if (controller.courseParent != null &&
                                    controller.state == SessionState.notStarted)
                                  _ActivityStatuses(
                                    statuses: controller.activityStatuses,
                                    space: controller.courseParent!,
                                    onTap: controller.joinActivityByRoomId,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ActivitySessionButtonWidget(controller: controller),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _ActivityStatuses extends StatelessWidget {
  final Map<ActivitySummaryStatus, Map<String, RoomSummaryResponse>> statuses;
  final Room space;
  final Function(String) onTap;

  const _ActivityStatuses({
    required this.statuses,
    required this.space,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: FluffyThemes.columnWidth * 1.5,
      ),
      child: Column(
        children: [
          ...ActivitySummaryStatus.values.map((status) {
            final entry = statuses[status];
            if (entry!.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsetsGeometry.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      status.label(L10n.of(context), entry.length),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...entry.entries.map((e) {
                    // if user is in the room, use the room info instead of the
                    // room summary response to get real-time activity roles info
                    final roomId = e.key;
                    final room = Matrix.of(context).client.getRoomById(roomId);

                    final activityPlan =
                        room?.activityPlan ?? e.value.activityPlan;

                    // If activity is completed, show all roles, even for users who have left the
                    // room (like the bot). Otherwise, show only joined users with roles
                    Map<String, ActivityRoleModel> activityRoles =
                        status == ActivitySummaryStatus.completed
                        ? (e.value.activityRoles?.roles ?? {})
                        : e.value.joinedUsersWithRoles;

                    // If the user is in the activity room and it's not completed, use the room's
                    // state events to determine roles to update them in real-time
                    if (room?.assignedRoles != null &&
                        status != ActivitySummaryStatus.completed) {
                      activityRoles = room!.assignedRoles!;
                    }

                    return ListTile(
                      title: OpenRolesIndicator(
                        roles: (activityPlan?.roles.values ?? [])
                            .sorted((a, b) => a.id.compareTo(b.id))
                            .toList(),
                        assignedRoles: activityRoles.values.toList(),
                        size: 40.0,
                        spacing: 8.0,
                        space: space,
                        onUserTap: (user, context) {
                          showMemberActionsPopupMenu(
                            context: context,
                            user: user,
                          );
                        },
                      ),
                      trailing: space.isRoomAdmin
                          ? const Icon(Icons.arrow_forward)
                          : null,
                      onTap: space.isRoomAdmin ? () => onTap(roomId) : null,
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
