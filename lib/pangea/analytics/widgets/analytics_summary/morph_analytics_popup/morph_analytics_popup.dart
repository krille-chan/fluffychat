import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics/constants/morph_categories_and_labels.dart';
import 'package:fluffychat/pangea/analytics/enums/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics/enums/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/analytics/models/construct_list_model.dart';
import 'package:fluffychat/pangea/analytics/models/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics/utils/get_grammar_copy.dart';
import 'package:fluffychat/pangea/analytics/utils/get_svg_link.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';
import 'package:fluffychat/utils/color_value.dart';
import 'package:fluffychat/widgets/matrix.dart';

class MorphAnalyticsPopup extends StatelessWidget {
  const MorphAnalyticsPopup({
    super.key,
  });

  ConstructListModel get _constructsModel =>
      MatrixState.pangeaController.getAnalytics.constructListModel;

  Map<String, List<ConstructUses>> get _categoriesToUses =>
      _constructsModel.categoriesToUses(type: ConstructTypeEnum.morph);

  List<MapEntry<String, List<ConstructUses>>> get _sortedEntries {
    final entries = _categoriesToUses.entries.toList();
    // Sort the list with custom logic
    entries.sort((a, b) {
      // Check if one of the keys is 'Other'
      if (a.key.toLowerCase() == 'other') return 1;
      if (b.key.toLowerCase() == 'other') return -1;

      // Sort by the length of the list in descending order
      final aTotalPoints = a.value.fold<int>(
        0,
        (previousValue, element) => previousValue + element.points,
      );
      final bTotalPoints = b.value.fold<int>(
        0,
        (previousValue, element) => previousValue + element.points,
      );
      return bTotalPoints.compareTo(aTotalPoints);
    });
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final availableFeatures = getMorphCategories();
    final List<MapEntry<String, List<ConstructUses>>> morphUses =
        List.from(_sortedEntries);

    return FullWidthDialog(
      dialogContent: Scaffold(
        appBar: AppBar(
          title: Text(ConstructTypeEnum.morph.indicator.tooltip(context)),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: Navigator.of(context).pop,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: _constructsModel
                  .constructList(type: ConstructTypeEnum.morph)
                  .isEmpty
              ? Center(child: Text(L10n.of(context).noDataFound))
              : ListView.builder(
                  itemCount: availableFeatures.length,
                  itemBuilder: (context, index) {
                    final category =
                        index < morphUses.length ? morphUses[index] : null;
                    final ids = category?.value
                            .map(
                              (use) => MorphIdentifier(
                                morphFeature: category.key,
                                morphTag: use.lemma,
                              ),
                            )
                            .toList() ??
                        [];

                    debugPrint(
                        "category: ${category?.key}, points: ${category?.value.fold<int>(
                      0,
                      (previousValue, element) =>
                          previousValue + element.points,
                    )}");

                    return MorphFeatureBox(morphIdentifiers: ids);
                  },
                ),
        ),
      ),
      maxWidth: 600,
      maxHeight: 800,
    );
  }
}

class MorphFeatureBox extends StatelessWidget {
  final List<MorphIdentifier> morphIdentifiers;

  const MorphFeatureBox({
    super.key,
    required this.morphIdentifiers,
  });

  String get _morphFeature => morphIdentifiers.first.morphFeature;

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

  Set<String> get _lockedTags {
    final availableLabels = getLabelsForMorphCategory(_morphFeature)
        .map((tag) => tag.toLowerCase())
        .toSet();
    final usedLabels =
        morphIdentifiers.map((morph) => morph.morphTag.toLowerCase()).toSet();
    return availableLabels.difference(usedLabels);
  }

  @override
  Widget build(BuildContext context) {
    if (morphIdentifiers.isEmpty) {
      return Opacity(
        opacity: 0.5,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Theme.of(context).disabledColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 24.0),
              const SizedBox(width: 24.0),
              Text(
                L10n.of(context).lockedMorphFeature,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final allMorphIdentifiers = List.from(morphIdentifiers);
    allMorphIdentifiers.addAll(
      _lockedTags.map(
        (tag) => MorphIdentifier(
          morphFeature: _morphFeature,
          morphTag: tag,
          isLocked: true,
        ),
      ),
    );

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppConfig.gold, width: 2),
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
                child: CustomizedSvg(
                  svgUrl: getMorphSvgLink(
                    morphFeature: _morphFeature,
                    context: context,
                  ),
                  colorReplacements: theme.brightness == Brightness.dark
                      ? {
                          "white": theme.cardColor.hexValue.toString(),
                          "black": "white",
                        }
                      : {},
                  errorIcon: Icon(getIconForMorphFeature(_morphFeature)),
                ),
              ),
              Text(
                _categoryCopy(_morphFeature, context),
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
                  children: [
                    for (final morph in allMorphIdentifiers)
                      MorphTagChip(morphIdentifier: morph),
                  ],
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
  final MorphIdentifier morphIdentifier;

  const MorphTagChip({
    super.key,
    required this.morphIdentifier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (morphIdentifier.isLocked) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 24.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          color: theme.disabledColor,
        ),
        child: SizedBox(
          width: 28.0,
          height: 28.0,
          child: Icon(
            Icons.lock,
            color: theme.brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: <Color>[
            Color.alphaBlend(
              theme.brightness == Brightness.dark
                  ? Colors.black.withAlpha(220)
                  : Colors.white.withAlpha(220),
              AppConfig.gold,
            ),
            AppConfig.gold,
          ],
        ),
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
            child: CustomizedSvg(
              svgUrl: getMorphSvgLink(
                morphFeature: morphIdentifier.morphFeature,
                morphTag: morphIdentifier.morphTag,
                context: context,
              ),
              colorReplacements: theme.brightness == Brightness.dark
                  ? {
                      "white": theme.cardColor.hexValue.toString(),
                      "black": "white",
                    }
                  : {},
              errorIcon: Icon(
                getIconForMorphFeature(morphIdentifier.morphFeature),
              ),
            ),
          ),
          Text(
            getGrammarCopy(
                  category: morphIdentifier.morphFeature,
                  lemma: morphIdentifier.morphTag,
                  context: context,
                ) ??
                morphIdentifier.morphTag,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class MorphIdentifier {
  final String morphFeature;
  final String morphTag;
  final bool isLocked;

  const MorphIdentifier({
    required this.morphFeature,
    required this.morphTag,
    this.isLocked = false,
  });
}
