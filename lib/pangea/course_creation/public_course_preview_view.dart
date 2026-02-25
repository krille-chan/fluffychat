import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/chat_settings/utils/room_summary_extension.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_creation/public_course_preview.dart';
import 'package:fluffychat/pangea/course_plans/map_clipper.dart';
import 'package:fluffychat/pangea/course_settings/pin_clipper.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/user_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PublicCoursePreviewView extends StatelessWidget {
  final PublicCoursePreviewController controller;
  const PublicCoursePreviewView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const double titleFontSize = 16.0;
    const double descFontSize = 12.0;

    const double largeIconSize = 24.0;
    const double smallIconSize = 12.0;

    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).joinWithClassCode)),
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500.0),
            child: Builder(
              builder: (context) {
                if (controller.loading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (controller.hasError) {
                  return Center(
                    child: ErrorIndicator(
                      message: L10n.of(context).oopsSomethingWentWrong,
                    ),
                  );
                }

                final course = controller.course!;
                final summary = controller.roomSummary!;

                Uri? avatarUrl = course.imageUrl;
                if (summary.avatarUrl != null) {
                  avatarUrl = Uri.tryParse(summary.avatarUrl!);
                }

                final displayname = summary.displayName ?? course.title;

                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          left: 12.0,
                          right: 12.0,
                        ),
                        child: ListView.builder(
                          itemCount: course.topicIds.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                spacing: 8.0,
                                children: [
                                  ClipPath(
                                    clipper: MapClipper(),
                                    child: ImageByUrl(
                                      imageUrl: avatarUrl,
                                      width: 100.0,
                                      borderRadius: BorderRadius.circular(0.0),
                                      replacement: Avatar(
                                        name: displayname,
                                        size: 100.0,
                                        borderRadius: BorderRadius.circular(
                                          0.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    displayname,
                                    style: const TextStyle(
                                      fontSize: titleFontSize,
                                    ),
                                  ),
                                  if (summary.adminUserIDs.isNotEmpty)
                                    _CourseAdminDisplay(summary),
                                  Text(
                                    course.description,
                                    style: const TextStyle(
                                      fontSize: descFontSize,
                                    ),
                                  ),
                                  Row(
                                    spacing: 8.0,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CourseInfoChips(
                                        course.uuid,
                                        fontSize: descFontSize,
                                        iconSize: smallIconSize,
                                      ),
                                      CourseInfoChip(
                                        icon: Icons.person,
                                        text: L10n.of(context)
                                            .countParticipants(
                                              summary.joinedMemberCount,
                                            ),
                                        fontSize: descFontSize,
                                        iconSize: smallIconSize,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4.0,
                                      bottom: 8.0,
                                    ),
                                    child: Row(
                                      spacing: 4.0,
                                      children: [
                                        const Icon(
                                          Icons.map,
                                          size: largeIconSize,
                                        ),
                                        Text(
                                          L10n.of(context).coursePlan,
                                          style: const TextStyle(
                                            fontSize: titleFontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }

                            index--;

                            if (index >= course.topicIds.length) {
                              return const SizedBox(height: 12.0);
                            }

                            final topicId = course.topicIds[index];
                            final topic = course.loadedTopics[topicId];

                            if (topic == null) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                spacing: 8.0,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipPath(
                                    clipper: PinClipper(),
                                    child: ImageByUrl(
                                      imageUrl: topic.imageUrl,
                                      width: 45.0,
                                      replacement: Container(
                                        width: 45.0,
                                        height: 45.0,
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      spacing: 4.0,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          topic.title,
                                          style: const TextStyle(
                                            fontSize: titleFontSize,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsGeometry.symmetric(
                                                vertical: 2.0,
                                              ),
                                          child: Row(
                                            spacing: 8.0,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (topic.location != null)
                                                CourseInfoChip(
                                                  icon: Icons.location_on,
                                                  text: topic.location!,
                                                  fontSize: descFontSize,
                                                  iconSize: smallIconSize,
                                                ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          topic.description,
                                          style: const TextStyle(
                                            fontSize: descFontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border(
                          top: BorderSide(
                            color: theme.dividerColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          spacing: 8.0,
                          children: [
                            if (summary.joinRule == JoinRules.knock) ...[
                              TextField(
                                decoration: InputDecoration(
                                  hintText: L10n.of(context).enterCodeToJoin,
                                ),
                                onSubmitted: controller.joinWithCode,
                              ),
                              Row(
                                spacing: 8.0,
                                children: [
                                  const Expanded(child: Divider()),
                                  Text(L10n.of(context).or),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                            ],
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                foregroundColor:
                                    theme.colorScheme.onPrimaryContainer,
                              ),
                              onPressed: controller.joinCourse,
                              child: Row(
                                spacing: 8.0,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.map_outlined),
                                  Text(
                                    summary.joinRule == JoinRules.knock
                                        ? L10n.of(context).knock
                                        : L10n.of(context).join,
                                    style: const TextStyle(
                                      fontSize: titleFontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseAdminDisplay extends StatelessWidget {
  final RoomSummaryResponse summary;
  const _CourseAdminDisplay(this.summary);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12.0,
      runSpacing: 12.0,
      children: [
        ...summary.adminUserIDs.map((adminId) {
          return FutureBuilder(
            future: Matrix.of(context).client.getProfileFromUserId(adminId),
            builder: (context, snapshot) {
              final profile = snapshot.data;
              final displayName =
                  profile?.displayName ?? adminId.localpart ?? adminId;
              return InkWell(
                onTap: profile != null
                    ? () => UserDialog.show(context: context, profile: profile)
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: Opacity(
                    opacity: 0.5,
                    child: Row(
                      spacing: 4.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Avatar(
                          size: 18.0,
                          mxContent: profile?.avatarUrl,
                          name: displayName,
                          userId: adminId,
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 80.0),
                          child: Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
