import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_start/activity_session_start_page.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';

class ActivitySessionButtonWidget extends StatelessWidget {
  final ActivitySessionStartController controller;

  const ActivitySessionButtonWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedSize(
      duration: FluffyThemes.animationDuration,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: theme.dividerColor)),
          color: theme.colorScheme.surface,
        ),
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: FluffyThemes.maxTimelineWidth,
                ),
                child: Column(
                  spacing: 16.0,
                  children: [
                    if (controller.descriptionText != null)
                      Text(
                        controller.descriptionText!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    switch (controller.state) {
                      SessionState.notStarted => _ActivityStartButtons(
                        controller,
                      ),
                      SessionState.confirmedRole =>
                        _ActivityRoleConfirmedButtons(controller: controller),
                      SessionState.selectedSessionFull => _CTAButton(
                        controller.courseParent != null
                            ? L10n.of(context).returnToCourse
                            : L10n.of(context).returnHome,
                        controller.returnFromFullSession,
                      ),
                      _ => _CTAButton(
                        L10n.of(context).confirm,
                        controller.state == SessionState.selectedRole
                            ? controller.confirmRoleSelection
                            : null,
                      ),
                    },
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityStartButtons extends StatelessWidget {
  final ActivitySessionStartController controller;
  const _ActivityStartButtons(this.controller);

  @override
  Widget build(BuildContext context) {
    final hasActiveSession = controller.canJoinExistingSession;

    return FutureBuilder(
      future: controller.neededCourseParticipants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }

        final int neededParticipants = snapshot.data ?? 0;
        final bool hasEnoughParticipants = neededParticipants <= 0;
        return Column(
          spacing: 16.0,
          children: [
            if (!hasEnoughParticipants) ...[
              Text(
                neededParticipants > 1
                    ? L10n.of(context).activityNeedsMembers(neededParticipants)
                    : L10n.of(context).activityNeedsOneMember,
                textAlign: TextAlign.center,
              ),
              _CTAButton(
                L10n.of(context).inviteFriendsToCourse,
                controller.inviteToCourse,
              ),
              _CTAButton(
                L10n.of(context).pickDifferentActivity,
                controller.goToCourse,
              ),
            ] else if (controller.joinedActivityRoomId != null) ...[
              _CTAButton(
                L10n.of(context).continueText,
                controller.goToJoinedActivity,
              ),
            ] else ...[
              _CTAButton(
                hasActiveSession
                    ? L10n.of(context).startNewSession
                    : L10n.of(context).start,
                controller.startNewActivity,
              ),
              if (hasActiveSession)
                _CTAButton(
                  L10n.of(context).joinOpenSession,
                  controller.joinExistingSession,
                ),
            ],
          ],
        );
      },
    );
  }
}

class _ActivityRoleConfirmedButtons extends StatelessWidget {
  final ActivitySessionStartController controller;
  const _ActivityRoleConfirmedButtons({required this.controller});

  @override
  Widget build(BuildContext context) {
    final showPingCourse = controller.courseParent != null;
    final canPingCourse = controller.canPingParticipants;

    final showInviteOptions = controller.activityRoom?.isRoomAdmin == true;
    final showPlayWithBot = !controller.isBotRoomMember;

    return Column(
      spacing: 16.0,
      mainAxisSize: .min,
      children: [
        if (showPingCourse)
          _CTAButton(
            L10n.of(context).pingParticipants,
            canPingCourse ? controller.pingCourse : null,
          ),
        if (showInviteOptions && showPlayWithBot)
          _CTAButton(L10n.of(context).playWithBot, controller.playWithBot),
        if (showInviteOptions)
          _CTAButton(L10n.of(context).inviteFriends, controller.inviteFriends),
      ],
    );
  }
}

class _CTAButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const _CTAButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        padding: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Flexible(child: Text(text, textAlign: TextAlign.center))],
      ),
    );
  }
}
