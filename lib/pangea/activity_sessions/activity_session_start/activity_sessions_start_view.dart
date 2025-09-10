import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_start/activity_session_start_page.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_summary_widget.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/share_room_button.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivitySessionStartView extends StatelessWidget {
  final ActivitySessionStartController controller;
  const ActivitySessionStartView(
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primaryContainer,
      foregroundColor: theme.colorScheme.onPrimaryContainer,
      padding: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );

    return StreamBuilder(
      stream: Matrix.of(context)
          .client
          .onRoomState
          .stream
          .rateLimit(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 52.0,
            title: controller.activity == null
                ? null
                : Text(controller.activity!.title),
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
              if (controller.room != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Center(
                      child: ShareRoomButton(room: controller.room!),
                    ),
                  ),
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
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 600.0,
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  spacing: 12.0,
                                  children: [
                                    ActivitySummary(
                                      activity: controller.activity!,
                                      room: controller.room,
                                      showInstructions:
                                          controller.showInstructions,
                                      toggleInstructions:
                                          controller.toggleInstructions,
                                      onTapParticipant: controller.selectRole,
                                      isParticipantSelected:
                                          controller.isParticipantSelected,
                                      canSelectParticipant:
                                          controller.canSelectParticipant,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimatedSize(
                            duration: FluffyThemes.animationDuration,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: theme.dividerColor),
                                ),
                                color: theme.colorScheme.surface,
                              ),
                              padding: const EdgeInsets.all(24.0),
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
                                  if (controller.state ==
                                      SessionState.notStarted) ...[
                                    ElevatedButton(
                                      style: buttonStyle,
                                      onPressed: () => context.go(
                                        "/rooms/spaces/${controller.widget.parentId}/activity/${controller.widget.activityId}?new=true",
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            L10n.of(context).startNewSession,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: buttonStyle,
                                      onPressed:
                                          controller.canJoinExistingSession
                                              ? () async {
                                                  final resp =
                                                      await showFutureLoadingDialog(
                                                    context: context,
                                                    future: controller
                                                        .joinExistingSession,
                                                  );

                                                  if (!resp.isError) {
                                                    context.go(
                                                      "/rooms/spaces/${controller.widget.parentId}/${resp.result}",
                                                    );
                                                  }
                                                }
                                              : null,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            L10n.of(context).joinOpenSession,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else if (controller.state ==
                                      SessionState.confirmedRole) ...[
                                    if (controller.room!.courseParent != null)
                                      ElevatedButton(
                                        style: buttonStyle,
                                        onPressed: () =>
                                            showFutureLoadingDialog(
                                          context: context,
                                          future: controller.pingCourse,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              L10n.of(context).pingParticipants,
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (controller.room!.isRoomAdmin) ...[
                                      if (!controller.isBotRoomMember)
                                        ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: () =>
                                              showFutureLoadingDialog(
                                            context: context,
                                            future: () => controller.room!
                                                .invite(BotName.byEnvironment),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                L10n.of(context).playWithBot,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ElevatedButton(
                                        style: buttonStyle,
                                        onPressed: () => context.go(
                                          "/rooms/${controller.room!.id}/invite",
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              L10n.of(context).inviteFriends,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ] else
                                    ElevatedButton(
                                      style: buttonStyle,
                                      onPressed: controller.enableButtons
                                          ? controller.confirmRoleSelection
                                          : null,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            controller.room?.isRoomAdmin ?? true
                                                ? L10n.of(context).start
                                                : L10n.of(context).confirm,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }
}
