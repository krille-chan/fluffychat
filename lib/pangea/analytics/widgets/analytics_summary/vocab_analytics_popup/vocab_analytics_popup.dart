import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics/constants/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics/enums/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics/enums/lemma_category_enum.dart';
import 'package:fluffychat/pangea/analytics/enums/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/analytics/models/construct_list_model.dart';
import 'package:fluffychat/pangea/analytics/models/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics/utils/get_grammar_copy.dart';
import 'package:fluffychat/pangea/analytics/widgets/analytics_summary/vocab_analytics_popup/vocab_definition_popup.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Displays vocab analytics, sorted into categories
/// (flowers, greens, and seeds) by points
class VocabAnalyticsPopup extends StatefulWidget {
  const VocabAnalyticsPopup({
    super.key,
  });

  @override
  VocabAnalyticsPopupState createState() => VocabAnalyticsPopupState();
}

class VocabAnalyticsPopupState extends State<VocabAnalyticsPopup> {
  ConstructListModel get _constructsModel =>
      MatrixState.pangeaController.getAnalytics.constructListModel;

  /// Sort entries alphabetically, to better detect duplicates
  List<ConstructUses> get _sortedEntries {
    final entries =
        _constructsModel.constructList(type: ConstructTypeEnum.vocab);
    entries
        .sort((a, b) => a.lemma.toLowerCase().compareTo(b.lemma.toLowerCase()));
    return entries;
  }

  /// Produces list of chips with lemma content,
  /// and assigns them to flowers, greens, and seeds tiles
  Widget get dialogContent {
    if (_constructsModel.constructList(type: ConstructTypeEnum.vocab).isEmpty) {
      return Center(child: Text(L10n.of(context).noDataFound));
    }
    final sortedEntries = _sortedEntries;

    // Get lists of lemmas by category
    final List<Widget> flowerLemmas = [];
    final List<Widget> greenLemmas = [];
    final List<Widget> seedLemmas = [];
    for (int i = 0; i < sortedEntries.length; i++) {
      final construct = sortedEntries[i];
      if (construct.lemma.isEmpty) {
        continue;
      }
      final int points = construct.points;
      String? displayText;

      // Check if previous or next entry has same lemma as this entry
      if ((i > 0 && sortedEntries[i - 1].lemma.equals(construct.lemma)) ||
          ((i < sortedEntries.length - 1 &&
              sortedEntries[i + 1].lemma.equals(construct.lemma)))) {
        final String pos = getGrammarCopy(
              category: "pos",
              lemma: construct.category,
              context: context,
            ) ??
            construct.category;
        displayText = "${sortedEntries[i].lemma} (${pos.toLowerCase()})";
      }

      // Add VocabChip for lemma to relevant widget list, followed by comma
      if (points < AnalyticsConstants.xpForGreens) {
        seedLemmas.add(
          VocabChip(
            construct: construct,
            displayText: displayText,
            onTap: () {
              showDialog<VocabDefinitionPopup>(
                context: context,
                builder: (c) => VocabDefinitionPopup(
                  construct: construct,
                  type: LemmaCategoryEnum.seeds,
                  points: points,
                ),
              );
            },
          ),
        );
        seedLemmas.add(
          const Text(
            ", ",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        );
      } else if (points >= AnalyticsConstants.xpForFlower) {
        flowerLemmas.add(
          VocabChip(
            construct: construct,
            displayText: displayText,
            onTap: () {
              showDialog<VocabDefinitionPopup>(
                context: context,
                builder: (c) => VocabDefinitionPopup(
                  construct: construct,
                  type: LemmaCategoryEnum.flowers,
                  points: points,
                ),
              );
            },
          ),
        );
        flowerLemmas.add(
          const Text(
            ", ",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        );
      } else {
        greenLemmas.add(
          VocabChip(
            construct: construct,
            displayText: displayText,
            onTap: () {
              showDialog<VocabDefinitionPopup>(
                context: context,
                builder: (c) => VocabDefinitionPopup(
                  construct: construct,
                  type: LemmaCategoryEnum.greens,
                  points: points,
                ),
              );
            },
          ),
        );
        greenLemmas.add(
          const Text(
            ", ",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        );
      }
    }

    // Pass sorted lemmas to background tile widgets
    final Widget flowers =
        dialogWidget(LemmaCategoryEnum.flowers, flowerLemmas);
    final Widget greens = dialogWidget(LemmaCategoryEnum.greens, greenLemmas);
    final Widget seeds = dialogWidget(LemmaCategoryEnum.seeds, seedLemmas);

    return Scaffold(
      appBar: AppBar(
        title: Text(ProgressIndicatorEnum.wordsUsed.tooltip(context)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(context).pop,
        ),
        // TODO: add search and training buttons?
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView(
          children: [flowers, greens, seeds],
        ),
      ),
    );
  }

  /// Tile that contains flowers, greens, or seeds chips
  Widget dialogWidget(LemmaCategoryEnum type, List<Widget> lemmaList) {
    // Remove extraneous commas from lemmaList
    if (lemmaList.isNotEmpty) {
      lemmaList.removeLast();
    } else {
      lemmaList.add(
        const Text(
          "No lemmas",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Material(
        borderRadius:
            const BorderRadius.all(Radius.circular(AppConfig.borderRadius)),
        color: type.color,
        child: Padding(
          padding: const EdgeInsets.all(
            10,
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
                  Text(
                    " ${type.xpString} XP",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Wrap(
                spacing: 0,
                runSpacing: 0,
                children: lemmaList,
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FullWidthDialog(
      dialogContent: dialogContent,
      maxWidth: 600,
      maxHeight: 800,
    );
  }
}

/// A simple chip with the text of the lemma
// TODO: highlights on hover
// callback on click
// has some padding to separate from other chips
// otherwise, is very visually simple with transparent border/background/etc
class VocabChip extends StatelessWidget {
  final ConstructUses construct;
  final String? displayText;
  final VoidCallback onTap;

  const VocabChip({
    super.key,
    required this.construct,
    required this.onTap,
    this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        displayText ?? construct.lemma,
        style: const TextStyle(
          // Workaround to add space between text and underline
          color: Colors.transparent,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(0, -3),
            ),
          ],
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.dashed,
          decorationColor: Colors.black,
          decorationThickness: 1,
          fontSize: 15,
        ),
      ),
    );
  }
}
