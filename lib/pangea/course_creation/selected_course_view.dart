import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_creation/selected_course_page.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_builder.dart';
import 'package:fluffychat/pangea/course_plans/map_clipper.dart';
import 'package:fluffychat/pangea/course_settings/pin_clipper.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class SelectedCourseView extends StatelessWidget {
  final SelectedCourseController controller;
  const SelectedCourseView(
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const double titleFontSize = 16.0;
    const double descFontSize = 12.0;

    const double largeIconSize = 24.0;
    const double mediumIconSize = 16.0;
    const double smallIconSize = 12.0;

    final spaceId = controller.widget.spaceId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          spaceId != null
              ? L10n.of(context).addCoursePlan
              : L10n.of(context).newCourse,
        ),
      ),
      body: SafeArea(
        child: CoursePlanBuilder(
          courseId: controller.widget.courseId,
          onNotFound: () => context.go("/rooms/course/own"),
          builder: (context, courseController) {
            final course = courseController.course;
            return Container(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500.0),
                child: course == null
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 12.0,
                                left: 12.0,
                                right: 12.0,
                              ),
                              child: ListView.builder(
                                itemCount: course.loadedTopics.length + 2,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return Column(
                                      spacing: 8.0,
                                      children: [
                                        ClipPath(
                                          clipper: MapClipper(),
                                          child: ImageByUrl(
                                            imageUrl: course.imageUrl,
                                            width: 100.0,
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            replacement: Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    theme.colorScheme.secondary,
                                              ),
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
                                          style: const TextStyle(
                                            fontSize: descFontSize,
                                          ),
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

                                  if (index >= course.loadedTopics.length) {
                                    return const SizedBox(height: 12.0);
                                  }

                                  final topic = course.loadedTopics[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      spacing: 8.0,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                color:
                                                    theme.colorScheme.secondary,
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
                                              Text(
                                                topic.description,
                                                style: const TextStyle(
                                                  fontSize: descFontSize,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsGeometry
                                                        .symmetric(
                                                  vertical: 2.0,
                                                ),
                                                child: Row(
                                                  spacing: 8.0,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    if (topic.location != null)
                                                      CourseInfoChip(
                                                        icon: Icons.location_on,
                                                        text: topic.location!,
                                                        fontSize: descFontSize,
                                                        iconSize: smallIconSize,
                                                      ),
                                                    CourseInfoChip(
                                                      icon: Icons
                                                          .event_note_outlined,
                                                      text: L10n.of(context)
                                                          .numActivityPlans(
                                                        topic.loadedActivities
                                                            .length,
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
                                        style: const TextStyle(
                                          fontSize: descFontSize,
                                        ),
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
                                        style: const TextStyle(
                                          fontSize: descFontSize,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                      foregroundColor:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                    onPressed: () => showFutureLoadingDialog(
                                      context: context,
                                      future: () => spaceId != null
                                          ? controller.addCourseToSpace(course)
                                          : controller.launchCourse(course),
                                    ),
                                    child: Row(
                                      spacing: 8.0,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.map_outlined),
                                        Text(
                                          spaceId != null
                                              ? L10n.of(context).addCoursePlan
                                              : L10n.of(context).createCourse,
                                          style: const TextStyle(
                                            fontSize: titleFontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
