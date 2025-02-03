import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_identifier.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_level_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/pangea/morphs/morph_models.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../morphs/morph_repo.dart';

class MorphAnalyticsView extends StatelessWidget {
  const MorphAnalyticsView({
    super.key,
  });

  List<MorphFeature> get availableFeatures => MorphsRepo.get().displayFeatures;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
          itemCount: availableFeatures.length,
          itemBuilder: (context, index) =>
              availableFeatures[index].displayTags.isNotEmpty
                  ? MorphFeatureBox(
                      morphFeature: availableFeatures[index].feature,
                    )
                  : const SizedBox.shrink(),
        ),
      );
}

class MorphFeatureBox extends StatelessWidget {
  final String morphFeature;

  const MorphFeatureBox({
    super.key,
    required this.morphFeature,
  });

  // get constructData => MatrixState.pangeaController.

  String _categoryCopy(
    String category,
    BuildContext context,
  ) {
    if (category.toLowerCase() == "other") {
      return L10n.of(context).other;
    }

    return ConstructTypeEnum.morph.getDisplayCopy(
          category,
          context,
        ) ??
        category;
  }

  Set<String> get allTags => MorphsRepo.get()
      .getDisplayTags(morphFeature)
      .map((tag) => tag.toLowerCase())
      .toSet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppConfig.primaryColorLight
              : AppConfig.primaryColor,
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
                child: MorphIcon(morphFeature: morphFeature, morphTag: null),
              ),
              Text(
                _categoryCopy(morphFeature, context),
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
                        (morphTag) => MorphTagChip(
                          morphFeature: morphFeature,
                          morphTag: morphTag,
                          constructAnalytics: MatrixState.pangeaController
                                  .getAnalytics.constructListModel
                                  .getConstructUses(
                                ConstructIdentifier(
                                  lemma: morphTag,
                                  type: ConstructTypeEnum.morph,
                                  category: morphFeature,
                                ),
                              ) ??
                              ConstructUses(
                                lemma: morphTag,
                                constructType: ConstructTypeEnum.morph,
                                category: morphFeature,
                                uses: [],
                              ),
                        ),
                      )
                      .sortedBy<num>((chip) => chip.constructAnalytics.points)
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

  const MorphTagChip({
    super.key,
    required this.morphFeature,
    required this.morphTag,
    required this.constructAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: constructAnalytics.points > 0 ? 1.0 : 0.3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          gradient: constructAnalytics.points > 0
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Colors.transparent,
                    constructAnalytics.lemmaCategory.color,
                  ],
                )
              : null,
          color: constructAnalytics.points > 0 ? null : theme.disabledColor,
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
              child: constructAnalytics.points > 0
                  ? MorphIcon(
                      morphFeature: morphFeature,
                      morphTag: morphTag,
                    )
                  : const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
            ),
            Text(
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
            ),
          ],
        ),
      ),
    );
  }
}
