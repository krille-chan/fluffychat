import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/course_creation/course_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_builder.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class SelectedCourseView extends StatelessWidget {
  final String courseId;
  final Future<void> Function(CoursePlanModel course) launchCourse;
  const SelectedCourseView({
    super.key,
    required this.courseId,
    required this.launchCourse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const double titleFontSize = 16.0;
    const double descFontSize = 12.0;

    const double largeIconSize = 24.0;
    const double mediumIconSize = 16.0;
    const double smallIconSize = 12.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).newCourse),
      ),
      body: CoursePlanBuilder(
        courseId: courseId,
        onNotFound: () => context.go("/rooms/communities/newcourse"),
        builder: (context, controller) {
          final course = controller.course;
          return MaxWidthBody(
            showBorder: false,
            withScrolling: false,
            maxWidth: 500.0,
            child: course == null
                ? const Center(child: CircularProgressIndicator.adaptive())
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListView.builder(
                          itemCount: course.topics.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                spacing: 8.0,
                                children: [
                                  CourseImage(
                                    imageUrl: course.imageUrl,
                                    width: 100.0,
                                    replacement: Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    course.title,
                                    style: const TextStyle(
                                      fontSize: titleFontSize,
                                    ),
                                  ),
                                  Text(
                                    course.description,
                                    style:
                                        const TextStyle(fontSize: descFontSize),
                                  ),
                                  CourseInfoChips(
                                    course,
                                    fontSize: descFontSize,
                                    iconSize: smallIconSize,
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

                            if (index == course.topics.length) {
                              return const SizedBox(height: 150.0);
                            }

                            final topic = course.topics[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                spacing: 8.0,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: topic.imageUrl != null
                                        ? CachedNetworkImage(
                                            width: 40.0,
                                            height: 40.0,
                                            fit: BoxFit.cover,
                                            imageUrl: topic.imageUrl!,
                                            placeholder: (context, url) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                            errorWidget: (context, url, error) {
                                              return Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: theme
                                                      .colorScheme.secondary,
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  theme.colorScheme.secondary,
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
                                        Text(
                                          topic.description,
                                          style: const TextStyle(
                                            fontSize: descFontSize,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsGeometry
                                              .symmetric(
                                            vertical: 2.0,
                                          ),
                                          child: Row(
                                            spacing: 8.0,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CourseInfoChip(
                                                icon: Icons.location_on,
                                                text: topic.location,
                                                fontSize: descFontSize,
                                                iconSize: smallIconSize,
                                              ),
                                              CourseInfoChip(
                                                icon: Icons.event_note_outlined,
                                                text: L10n.of(context)
                                                    .numActivityPlans(
                                                  topic.activities.length,
                                                ),
                                                fontSize: descFontSize,
                                                iconSize: smallIconSize,
                                              ),
                                            ],
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
                        child: Column(
                          spacing: 8.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              spacing: 12.0,
                              children: [
                                const Icon(
                                  Icons.edit,
                                  size: mediumIconSize,
                                ),
                                Flexible(
                                  child: Text(
                                    L10n.of(context).editCourseLater,
                                    style:
                                        const TextStyle(fontSize: descFontSize),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 12.0,
                              children: [
                                const Icon(
                                  Icons.shield,
                                  size: mediumIconSize,
                                ),
                                Flexible(
                                  child: Text(
                                    L10n.of(context).newCourseAccess,
                                    style:
                                        const TextStyle(fontSize: descFontSize),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 16.0,
                                ),
                              ),
                              onPressed: () => showFutureLoadingDialog(
                                context: context,
                                future: () => launchCourse(course),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    L10n.of(context).createCourse,
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
                    ],
                  ),
          );
        },
      ),
    );
  }
}
