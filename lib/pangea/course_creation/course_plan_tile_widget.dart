import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/courses/course_plan_model.dart';
import 'package:fluffychat/widgets/hover_builder.dart';

class CoursePlanTile extends StatelessWidget {
  final CoursePlanModel course;
  final VoidCallback onTap;

  final double titleFontSize;
  final double chipFontSize;
  final double chipIconSize;

  const CoursePlanTile({
    super.key,
    required this.course,
    required this.onTap,
    required this.titleFontSize,
    required this.chipFontSize,
    required this.chipIconSize,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: course.imageUrl != null
                        ? CachedNetworkImage(
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                            imageUrl: course.imageUrl!,
                            placeholder: (context, url) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
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
                          course,
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
