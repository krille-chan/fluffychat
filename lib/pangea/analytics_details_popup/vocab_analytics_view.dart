import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_identifier.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_level_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Displays vocab analytics, sorted into categories
/// (flowers, greens, and seeds) by points
class VocabAnalyticsView extends StatelessWidget {
  final void Function(ConstructIdentifier) onConstructZoom;

  const VocabAnalyticsView({
    super.key,
    required this.onConstructZoom,
  });

  @override
  Widget build(BuildContext context) {
    final lemmas = MatrixState.pangeaController.getAnalytics.constructListModel
        .constructList(type: ConstructTypeEnum.vocab)
      ..sort((a, b) => a.lemma.toLowerCase().compareTo(b.lemma.toLowerCase()));

    final flowerLemmas = <VocabChip>[];
    final greenLemmas = <VocabChip>[];
    final seedLemmas = <VocabChip>[];
    for (int i = 0; i < lemmas.length; i++) {
      final construct = lemmas[i];
      if (construct.lemma.isEmpty) continue;
      final int points = construct.points;
      String? displayText;
      // Check if previous or next entry has same lemma as this entry
      if ((i > 0 && lemmas[i - 1].lemma.equals(construct.lemma)) ||
          (i < lemmas.length - 1 &&
              lemmas[i + 1].lemma.equals(construct.lemma))) {
        final pos = getGrammarCopy(
              category: "pos",
              lemma: construct.category,
              context: context,
            ) ??
            construct.category;
        displayText = "${construct.lemma} (${pos.toLowerCase()})";
      }
      final lemma = VocabChip(
        construct: construct,
        displayText: displayText,
      );
      // Sort lemmas into categories
      if (points < AnalyticsConstants.xpForGreens) {
        seedLemmas.add(lemma);
      } else if (points >= AnalyticsConstants.xpForFlower) {
        flowerLemmas.add(lemma);
      } else {
        greenLemmas.add(lemma);
      }
    }

    final flowers = LemmaListSection(
      type: ConstructLevelEnum.flowers,
      lemmas: flowerLemmas,
      onTap: onConstructZoom,
    );
    final greens = LemmaListSection(
      type: ConstructLevelEnum.greens,
      lemmas: greenLemmas,
      onTap: onConstructZoom,
    );
    final seeds = LemmaListSection(
      type: ConstructLevelEnum.seeds,
      lemmas: seedLemmas,
      onTap: onConstructZoom,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        key: const PageStorageKey<String>('vocab-analytics'),
        children: [flowers, greens, seeds],
      ),
    );
  }
}

class VocabChip {
  final ConstructUses construct;
  final String? displayText;

  VocabChip({
    required this.construct,
    this.displayText,
  });
}

class LemmaListSection extends StatelessWidget {
  final ConstructLevelEnum type;
  final List<VocabChip> lemmas;
  final Function(ConstructIdentifier) onTap;

  const LemmaListSection({
    super.key,
    required this.type,
    required this.lemmas,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontColor =
        theme.brightness == Brightness.dark ? type.color : type.darkColor;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: type.color, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomizedSvg(
                svgUrl: type.svgURL,
                colorReplacements: const {},
                errorIcon: Text(type.emoji),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: lemmas.isEmpty
                ? Text(
                    L10n.of(context).noLemmasFound(type.xpNeeded),
                    style: TextStyle(
                      color: fontColor,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Wrap(
                    spacing: 0,
                    runSpacing: 0,
                    children: lemmas.mapIndexed((index, lemma) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => onTap(lemma.construct.id),
                          child: Text(
                            "${lemma.displayText ?? lemma.construct.lemma}${index < lemmas.length - 1 ? ', ' : ''}",
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                  color: fontColor,
                                  offset: const Offset(0, -2.5),
                                ),
                              ],
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dotted,
                              decorationColor: fontColor,
                              decorationThickness: 1,
                              fontSize: theme.textTheme.bodyLarge?.fontSize,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
