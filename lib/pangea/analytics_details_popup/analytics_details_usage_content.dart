import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_details_popup/lemma_usage_dots.dart';
import 'package:fluffychat/pangea/analytics_details_popup/lemma_use_example_messages.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AnalyticsDetailsUsageContent extends StatelessWidget {
  final ConstructUses construct;

  const AnalyticsDetailsUsageContent({required this.construct, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: LemmaUseExampleMessages(
            construct: construct,
            client: Matrix.of(context).client,
          ),
        ),
        ...LearningSkillsEnum.values.where((v) => v.isVisible).map((skill) {
          return LemmaUsageDots(
            construct: construct,
            category: skill,
            tooltip: skill.tooltip(context),
            icon: skill.icon,
          );
        }),
      ],
    );
  }
}
