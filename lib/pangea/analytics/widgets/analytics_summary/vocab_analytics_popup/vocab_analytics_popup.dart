import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
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

  ConstructUses? _selectedConstruct;

  void _setSelectedConstruct(ConstructUses? construct) {
    if (mounted) {
      setState(() {
        _selectedConstruct = construct;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullWidthDialog(
      dialogContent: _selectedConstruct == null
          ? LemmaListDialogContent(
              lemmas: _sortedEntries,
              onTap: _setSelectedConstruct,
            )
          : VocabDefinitionPopup(
              construct: _selectedConstruct!,
              onClose: () => _setSelectedConstruct(null),
            ),
      maxWidth: 600,
      maxHeight: 800,
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
  final LemmaCategoryEnum type;
  final List<VocabChip> lemmas;
  final Function(ConstructUses) onTap;

  const LemmaListSection({
    super.key,
    required this.type,
    required this.lemmas,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(AppConfig.borderRadius),
        ),
        color: type.color,
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
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: lemmas.isEmpty
                ? Text(
                    L10n.of(context).noLemmasFound,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                    ),
                  )
                : Wrap(
                    spacing: 0,
                    runSpacing: 0,
                    children: lemmas.mapIndexed((index, lemma) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => onTap(lemma.construct),
                          child: Text(
                            "${lemma.displayText ?? lemma.construct.lemma}${index < lemmas.length - 1 ? ', ' : ''}",
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onPrimaryFixed,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dashed,
                              decorationColor:
                                  Theme.of(context).colorScheme.onPrimaryFixed,
                              decorationThickness: 1,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.fontSize,
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

class LemmaListDialogContent extends StatelessWidget {
  final List<ConstructUses> lemmas;
  final Function(ConstructUses) onTap;

  const LemmaListDialogContent({
    super.key,
    required this.lemmas,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (lemmas.isEmpty) {
      return Center(child: Text(L10n.of(context).noDataFound));
    }

    // Get lists of lemmas by category
    final List<VocabChip> flowerLemmas = [];
    final List<VocabChip> greenLemmas = [];
    final List<VocabChip> seedLemmas = [];

    for (int i = 0; i < lemmas.length; i++) {
      final construct = lemmas[i];
      if (construct.lemma.isEmpty) {
        continue;
      }

      final int points = construct.points;
      String? displayText;

      // Check if previous or next entry has same lemma as this entry
      if ((i > 0 && lemmas[i - 1].lemma.equals(construct.lemma)) ||
          ((i < lemmas.length - 1 &&
              lemmas[i + 1].lemma.equals(construct.lemma)))) {
        final String pos = getGrammarCopy(
              category: "pos",
              lemma: construct.category,
              context: context,
            ) ??
            construct.category;
        displayText = "${lemmas[i].lemma} (${pos.toLowerCase()})";
      }

      final lemma = VocabChip(
        construct: construct,
        displayText: displayText,
      );

      if (points < AnalyticsConstants.xpForGreens) {
        seedLemmas.add(lemma);
      } else if (points >= AnalyticsConstants.xpForFlower) {
        flowerLemmas.add(lemma);
      } else {
        greenLemmas.add(lemma);
      }
    }

    // Pass sorted lemmas to background tile widgets
    final Widget flowers = LemmaListSection(
      type: LemmaCategoryEnum.flowers,
      lemmas: flowerLemmas,
      onTap: onTap,
    );

    final Widget greens = LemmaListSection(
      type: LemmaCategoryEnum.greens,
      lemmas: greenLemmas,
      onTap: onTap,
    );

    final Widget seeds = LemmaListSection(
      type: LemmaCategoryEnum.seeds,
      lemmas: seedLemmas,
      onTap: onTap,
    );

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
}
