import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class CourseInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  final double fontSize;
  final double iconSize;
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

class CourseInfoChips extends StatelessWidget {
  final CoursePlanModel course;
  final double fontSize;
  final double iconSize;
  final EdgeInsets? padding;

  const CourseInfoChips(
    this.course, {
    super.key,
    required this.fontSize,
    required this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: [
        CourseInfoChip(
          icon: Icons.language,
          text:
              "${course.baseLanguageDisplay} → ${course.targetLanguageDisplay}",
          fontSize: fontSize,
          iconSize: iconSize,
          padding: padding,
        ),
        CourseInfoChip(
          icon: Icons.school,
          text: course.cefrLevel.string,
          fontSize: fontSize,
          iconSize: iconSize,
          padding: padding,
        ),
        CourseInfoChip(
          icon: Icons.location_on,
          text: L10n.of(context).numModules(course.topicIds.length),
          fontSize: fontSize,
          iconSize: iconSize,
          padding: padding,
        ),
        CourseInfoChip(
          icon: Icons.event_note_outlined,
          text: L10n.of(context).numActivityPlans(course.totalActivities),
          fontSize: fontSize,
          iconSize: iconSize,
          padding: padding,
        ),
      ],
    );
  }
}
