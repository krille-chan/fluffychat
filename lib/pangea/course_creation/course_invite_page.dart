import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_builder.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseInvitePage extends StatefulWidget {
  final String courseId;
  final Completer<String>? courseCreationCompleter;

  const CourseInvitePage(
    this.courseId, {
    super.key,
    this.courseCreationCompleter,
  });

  @override
  CourseInvitePageController createState() => CourseInvitePageController();
}

class CourseInvitePageController extends State<CourseInvitePage> {
  Future<String> getSpaceId() async {
    if (widget.courseCreationCompleter == null) {
      throw Exception("No course creation completer provided");
    }
    return widget.courseCreationCompleter!.future;
  }

  @override
  Widget build(BuildContext context) {
    const avatarSize = 44.0;

    final theme = Theme.of(context);
    final client = Matrix.of(context).client;

    return CoursePlanBuilder(
      courseId: widget.courseId,
      builder: (context, courseController) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(30.0),
                constraints: const BoxConstraints(
                  maxWidth: 750,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    courseController.course != null
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppConfig.gold),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              spacing: 16.0,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  spacing: 10.0,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.map_outlined,
                                      size: 40.0,
                                    ),
                                    Flexible(
                                      child: Text(
                                        courseController.course!.title,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                CourseInfoChips(
                                  courseController.course!,
                                  fontSize: 12.0,
                                  iconSize: 12.0,
                                ),
                              ],
                            ),
                          )
                        : const CircularProgressIndicator.adaptive(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        spacing: 16.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              const avatarSpace = avatarSize + 8.0;
                              final availableSpace =
                                  constraints.maxWidth - 24.0;

                              final visibleAvatars = min(
                                3,
                                (availableSpace / avatarSpace).floor() - 2,
                              );

                              return Row(
                                spacing: 8.0,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FutureBuilder(
                                    future: client
                                        .getProfileFromUserId(client.userID!),
                                    builder: (context, snapshot) {
                                      return Avatar(
                                        size: avatarSize,
                                        mxContent: snapshot.data?.avatarUrl,
                                        name: snapshot.data?.displayName ??
                                            client.userID!.localpart,
                                        userId: client.userID!,
                                      );
                                    },
                                  ),
                                  Avatar(
                                    userId: BotName.byEnvironment,
                                    size: avatarSize,
                                  ),
                                  ...List.generate(visibleAvatars, (index) {
                                    return CircleAvatar(
                                      radius: avatarSize / 2,
                                      backgroundColor:
                                          AppConfig.gold.withAlpha(80),
                                      child: const Icon(
                                        Icons.question_mark,
                                        size: 20.0,
                                      ),
                                    );
                                  }),
                                  const Icon(
                                    Icons.more_horiz,
                                    size: 24.0,
                                  ),
                                ],
                              );
                            },
                          ),
                          Text(
                            L10n.of(context).courseStartDesc,
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      spacing: 24.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final resp = await showFutureLoadingDialog(
                              context: context,
                              future: getSpaceId,
                            );
                            if (mounted && !resp.isError) {
                              context.go("/rooms/spaces/${resp.result}/invite");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.onSurface,
                            side: BorderSide(
                              width: 1,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          child: Row(
                            spacing: 8.0,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.upload_file),
                              Text(L10n.of(context).inviteYourFriends),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final resp = await showFutureLoadingDialog(
                              context: context,
                              future: getSpaceId,
                            );
                            if (mounted && !resp.isError) {
                              context.go("/rooms/spaces/${resp.result}");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.onSurface,
                            side: BorderSide(
                              width: 1,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          child: Row(
                            spacing: 8.0,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(L10n.of(context).playWithAI),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
