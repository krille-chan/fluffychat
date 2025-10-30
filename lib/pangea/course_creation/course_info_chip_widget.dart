import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_builder.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class CourseInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  final double? fontSize;
  final double? iconSize;
  final EdgeInsets? padding;

  const CourseInfoChip({
    super.key,
    required this.icon,
    required this.text,
    required this.fontSize,
    required this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        spacing: 4.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

class CourseInfoChips extends StatefulWidget {
  final String courseId;
  final double? fontSize;
  final double? iconSize;
  final EdgeInsets? padding;

  const CourseInfoChips(
    this.courseId, {
    super.key,
    this.fontSize,
    this.iconSize,
    this.padding,
  });

  @override
  State<CourseInfoChips> createState() => CourseInfoChipsState();
}

class CourseInfoChipsState extends State<CourseInfoChips>
    with CoursePlanProvider {
  @override
  void initState() {
    super.initState();
    loadCourse(widget.courseId);
  }

  @override
  void didUpdateWidget(covariant CourseInfoChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseId != widget.courseId) {
      loadCourse(widget.courseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (course == null) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: [
        CourseInfoChip(
          icon: Icons.language,
          text: course!.targetLanguageDisplay,
          fontSize: widget.fontSize,
          iconSize: widget.iconSize,
          padding: widget.padding,
        ),
        CourseInfoChip(
          icon: Icons.school,
          text: course!.cefrLevel.string,
          fontSize: widget.fontSize,
          iconSize: widget.iconSize,
          padding: widget.padding,
        ),
        CourseInfoChip(
          icon: Icons.location_on,
          text: L10n.of(context).numModules(course!.topicIds.length),
          fontSize: widget.fontSize,
          iconSize: widget.iconSize,
          padding: widget.padding,
        ),
      ],
    );
  }
}
