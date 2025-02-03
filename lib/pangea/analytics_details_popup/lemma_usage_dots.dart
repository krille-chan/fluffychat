import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_level_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';

class LemmaUsageDots extends StatelessWidget {
  final ConstructUses construct;
  final LearningSkillsEnum category;

  final String tooltip;
  final IconData icon;

  const LemmaUsageDots({
    required this.construct,
    required this.category,
    required this.tooltip,
    required this.icon,
    super.key,
  });

  /// Find lemma uses for the given exercise type, to create dot list
  List<bool> sortedUses(LearningSkillsEnum category) {
    final List<bool> useList = [];
    for (final OneConstructUse use in construct.uses) {
      if (use.useType.pointValue == 0) {
        continue;
      }
      // If the use type matches the given category, save to list
      // Usage with positive XP is saved as true, else false
      if (category == use.useType.skillsEnumType) {
        useList.add(use.useType.pointValue > 0);
      }
    }
    return useList;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> dots = [];
    for (final bool use in sortedUses(category)) {
      dots.add(
        Container(
          width: 15.0,
          height: 15.0,
          decoration: BoxDecoration(
            color: use ? AppConfig.success : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    final Color textColor = Theme.of(context).brightness != Brightness.light
        ? construct.lemmaCategory.color
        : construct.lemmaCategory.darkColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: tooltip,
            child: Icon(
              icon,
              size: 24,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Wrap(
              spacing: 3,
              runSpacing: 5,
              children: dots,
            ),
          ),
        ],
      ),
    );
  }
}
