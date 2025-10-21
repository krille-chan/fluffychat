import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_downloads/analytics_download_button.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/widgets/matrix.dart';

class MorphAnalyticsListView extends StatelessWidget {
  final ConstructAnalyticsViewState controller;

  const MorphAnalyticsListView({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(vertical: 10.0);

    return Column(
      children: [
        if (kIsWeb)
          const Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DownloadAnalyticsButton(),
              ],
            ),
          ),
        Expanded(
          child: CustomScrollView(
            key: const PageStorageKey<String>('morph-analytics'),
            slivers: [
              const SliverToBoxAdapter(
                child: InstructionsInlineTooltip(
                  instructionsEnum: InstructionsEnum.morphAnalyticsList,
                ),
              ),

              if (!InstructionsEnum.morphAnalyticsList.isToggledOff)
                const SliverToBoxAdapter(child: SizedBox(height: 16.0)),

              // Morph feature boxes
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final feature = controller.features[index];
                    return feature.displayTags.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: MorphFeatureBox(
                              morphFeature: feature.feature,
                              allTags: controller.morphs
                                  .getDisplayTags(feature.feature)
                                  .map((tag) => tag.toLowerCase())
                                  .toSet(),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                  childCount: controller.features.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MorphFeatureBox extends StatelessWidget {
  final String morphFeature;
  final Set<String> allTags;

  const MorphFeatureBox({
    super.key,
    required this.morphFeature,
    required this.allTags,
  });

  MorphFeaturesEnum get feature =>
      MorphFeaturesEnumExtension.fromString(morphFeature);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16.0,
            children: [
              SizedBox(
                height: 30.0,
                width: 30.0,
                child: MorphIcon(morphFeature: feature, morphTag: null),
              ),
              Text(
                feature.getDisplayCopy(context),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: allTags
                      .map(
                        (morphTag) {
                          final id = ConstructIdentifier(
                            lemma: morphTag,
                            type: ConstructTypeEnum.morph,
                            category: morphFeature,
                          );

                          final analytics = MatrixState.pangeaController
                                  .getAnalytics.constructListModel
                                  .getConstructUses(id) ??
                              ConstructUses(
                                lemma: morphTag,
                                constructType: ConstructTypeEnum.morph,
                                category: morphFeature,
                                uses: [],
                              );

                          return MorphTagChip(
                            morphFeature: morphFeature,
                            morphTag: morphTag,
                            constructAnalytics: analytics,
                            onTap: () => context.go(
                              "/rooms/analytics/${id.type.string}/${Uri.encodeComponent(id.string)}",
                            ),
                          );
                        },
                      )
                      .sortedBy<num>(
                        (chip) => chip.constructAnalytics.points,
                      )
                      .reversed
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MorphTagChip extends StatelessWidget {
  final String morphFeature;
  final String morphTag;
  final ConstructUses constructAnalytics;
  final VoidCallback? onTap;

  const MorphTagChip({
    super.key,
    required this.morphFeature,
    required this.morphTag,
    required this.constructAnalytics,
    this.onTap,
  });

  MorphFeaturesEnum get feature =>
      MorphFeaturesEnumExtension.fromString(morphFeature);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlocked = constructAnalytics.points > 0 ||
        Matrix.of(context).client.userID == Environment.supportUserId;

    return InkWell(
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      onTap: onTap,
      child: Opacity(
        opacity: unlocked ? 1.0 : 0.3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.0),
            gradient: unlocked
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      constructAnalytics.lemmaCategory.color(context),
                      Colors.transparent,
                    ],
                  )
                : null,
            color: unlocked ? null : theme.disabledColor,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            children: [
              SizedBox(
                width: 28.0,
                height: 28.0,
                child: unlocked
                    ? Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withAlpha(180),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: MorphIcon(
                          morphFeature: feature,
                          morphTag: morphTag,
                        ),
                      )
                    : const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
              ),
              Flexible(
                child: Text(
                  getGrammarCopy(
                        category: morphFeature,
                        lemma: morphTag,
                        context: context,
                      ) ??
                      morphTag,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
