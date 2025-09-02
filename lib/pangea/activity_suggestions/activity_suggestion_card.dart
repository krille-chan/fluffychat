// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';

class ActivitySuggestionCard extends StatelessWidget {
  final ActivityPlannerBuilderState controller;
  final VoidCallback onPressed;
  final double width;
  final double height;

  final double? fontSize;
  final double? fontSizeSmall;
  final double? iconSize;

  const ActivitySuggestionCard({
    super.key,
    required this.controller,
    required this.onPressed,
    required this.width,
    required this.height,
    this.fontSize,
    this.fontSizeSmall,
    this.iconSize,
  });

  ActivityPlanModel get activity => controller.updatedActivity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          height: height,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageByUrl(
                    imageUrl: activity.imageURL,
                    width: width,
                    borderRadius: const BorderRadius.all(Radius.zero),
                    replacement: SizedBox(height: width),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: TextStyle(
                              fontSize: fontSize,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8.0,
                            children: [
                              if (activity.req.mode.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    activity.req.mode,
                                    style: fontSizeSmall != null
                                        ? TextStyle(fontSize: fontSizeSmall)
                                        : theme.textTheme.labelSmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 4.0,
                                  children: [
                                    Icon(
                                      Icons.group_outlined,
                                      size: iconSize ?? 12.0,
                                    ),
                                    Text(
                                      "${activity.req.numberOfParticipants}",
                                      style: fontSizeSmall != null
                                          ? TextStyle(fontSize: fontSizeSmall)
                                          : theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
