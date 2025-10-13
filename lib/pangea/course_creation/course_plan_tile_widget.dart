// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/map_clipper.dart';
import 'package:fluffychat/widgets/hover_builder.dart';

class CoursePlanTile extends StatelessWidget {
  final String courseId;
  final CoursePlanModel course;
  final VoidCallback onTap;

  final double? titleFontSize;
  final double? chipFontSize;
  final double? chipIconSize;

  const CoursePlanTile({
    super.key,
    required this.courseId,
    required this.course,
    required this.onTap,
    this.titleFontSize,
    this.chipFontSize,
    this.chipIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HoverBuilder(
      builder: (context, hovered) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color:
                    hovered ? theme.colorScheme.onSurface.withAlpha(10) : null,
              ),
              child: Row(
                spacing: 4.0,
                children: [
                  ClipPath(
                    clipper: MapClipper(),
                    child: ImageByUrl(
                      imageUrl: course.imageUrl,
                      borderRadius: BorderRadius.circular(0.0),
                      width: 40.0,
                      replacement: Container(
                        width: 40.0,
                        height: 40.0,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: titleFontSize,
                          ),
                        ),
                        CourseInfoChips(
                          courseId,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0,
                          ),
                          fontSize: chipFontSize,
                          iconSize: chipIconSize,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
