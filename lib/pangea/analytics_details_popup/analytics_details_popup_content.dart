import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_details_popup/lemma_usage_dots.dart';
import 'package:fluffychat/pangea/analytics_details_popup/lemma_use_example_messages.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';

class AnalyticsDetailsViewContent extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget headerContent;
  final Widget xpIcon;
  final ConstructIdentifier constructId;

  const AnalyticsDetailsViewContent({
    required this.title,
    required this.subtitle,
    required this.xpIcon,
    required this.headerContent,
    required this.constructId,
    super.key,
  });

  ConstructUses get construct => constructId.constructUses;

  @override
  Widget build(BuildContext context) {
    final Color textColor = (Theme.of(context).brightness != Brightness.light
        ? construct.lemmaCategory.color(context)
        : construct.lemmaCategory.darkColor(context));

    return SingleChildScrollView(
      child: Column(
        children: [
          title,
          const SizedBox(height: 16.0),
          subtitle,
          const SizedBox(height: 16.0),
          headerContent,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: CachedNetworkImage(
              imageUrl:
                  "${AppConfig.assetsBaseURL}/${AnalyticsConstants.popupDividerFileName}",
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              xpIcon,
              const SizedBox(width: 16.0),
              Text(
                "${construct.points} XP",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                LemmaUseExampleMessages(construct: construct),
                // Writing exercise section
                LemmaUsageDots(
                  construct: construct,
                  category: LearningSkillsEnum.writing,
                  tooltip: L10n.of(context).writingExercisesTooltip,
                  icon: Symbols.edit_square,
                ),
                // Listening exercise section
                LemmaUsageDots(
                  construct: construct,
                  category: LearningSkillsEnum.hearing,
                  tooltip: L10n.of(context).listeningExercisesTooltip,
                  icon: Symbols.hearing,
                ),
                // Reading exercise section
                LemmaUsageDots(
                  construct: construct,
                  category: LearningSkillsEnum.reading,
                  tooltip: L10n.of(context).readingExercisesTooltip,
                  icon: Symbols.two_pager,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
