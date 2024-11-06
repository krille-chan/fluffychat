import 'dart:math';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/utils/get_grammar_copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class AnalyticsPopup extends StatelessWidget {
  final ProgressIndicatorEnum indicator;
  final ConstructListModel constructsModel;
  final bool showGroups;

  const AnalyticsPopup({
    required this.indicator,
    required this.constructsModel,
    this.showGroups = true,
    super.key,
  });

  List<MapEntry<String, List<ConstructUses>>> get categoriesToUses {
    final entries = constructsModel.categoriesToUses.entries.toList();
    // Sort the list with custom logic
    entries.sort((a, b) {
      // Check if one of the keys is 'Other'
      if (a.key == 'Other') return 1;
      if (b.key == 'Other') return -1;

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
    Widget? dialogContent;
    final bool hasNoData = constructsModel.constructListWithPoints.isEmpty;
    final bool hasNoCategories = constructsModel.categoriesToUses.length == 1 &&
        constructsModel.categoriesToUses.keys.first == "Other";

    if (hasNoData) {
      dialogContent = Center(child: Text(L10n.of(context)!.noDataFound));
    } else if (hasNoCategories || !showGroups) {
      dialogContent = ListView.builder(
        itemCount: constructsModel.constructListWithPoints.length,
        itemBuilder: (context, index) {
          return ConstructUsesXPTile(
            indicator: indicator,
            constructsModel: constructsModel,
            constructUses: constructsModel.constructListWithPoints[index],
          );
        },
      );
    } else {
      dialogContent = ListView.builder(
        itemCount: categoriesToUses.length,
        itemBuilder: (context, index) {
          final category = categoriesToUses[index];
          return Column(
            children: [
              ConstructUsesExpansionTile(
                indicator: indicator,
                constructsModel: constructsModel,
                category: category.key,
                constructUses: category.value,
              ),
              const Divider(height: 1),
            ],
          );
        },
      );
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 600,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Scaffold(
            appBar: AppBar(
              title: Text(indicator.tooltip(context)),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(context).pop,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: dialogContent,
            ),
          ),
        ),
      ),
    );
  }
}

class ConstructUsesXPTile extends StatelessWidget {
  final ProgressIndicatorEnum indicator;
  final ConstructListModel constructsModel;
  final ConstructUses constructUses;

  const ConstructUsesXPTile({
    required this.indicator,
    required this.constructsModel,
    required this.constructUses,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "${constructUses.points} / ${constructsModel.maxXPPerLemma}",
      child: ListTile(
        onTap: () {},
        title: Text(
          constructsModel.type == ConstructTypeEnum.morph
              ? getGrammarCopy(
                    category: constructUses.category,
                    lemma: constructUses.lemma,
                    context: context,
                  ) ??
                  constructUses.lemma
              : constructUses.lemma,
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: constructUses.points / constructsModel.maxXPPerLemma,
                minHeight: 20,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppConfig.borderRadius),
                ),
                color: indicator.color(context),
              ),
            ),
            const SizedBox(width: 12),
            Text("${constructUses.points}xp"),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
      ),
    );
  }
}

class ConstructUsesExpansionTile extends StatefulWidget {
  final ProgressIndicatorEnum indicator;
  final ConstructListModel constructsModel;
  final String category;
  final List<ConstructUses> constructUses;

  const ConstructUsesExpansionTile({
    required this.indicator,
    required this.constructsModel,
    required this.category,
    required this.constructUses,
    super.key,
  });

  @override
  ConstructUsesExpansionTileState createState() =>
      ConstructUsesExpansionTileState();
}

class ConstructUsesExpansionTileState
    extends State<ConstructUsesExpansionTile> {
  int _lastLoadedIndex = 50;
  int get endIndex => min(_lastLoadedIndex, widget.constructUses.length);

  @override
  Widget build(BuildContext context) {
    final List<Widget> xpTiles = widget.constructUses
        .sublist(0, endIndex)
        .map((constructUses) {
          return ConstructUsesXPTile(
            indicator: widget.indicator,
            constructsModel: widget.constructsModel,
            constructUses: constructUses,
          );
        })
        .cast<Widget>()
        .toList();

    if (widget.constructUses.length > _lastLoadedIndex) {
      xpTiles.add(
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            child: Text(L10n.of(context)!.loadMore),
            onPressed: () => setState(() => _lastLoadedIndex += 50),
          ),
        ),
      );
    }

    return ExpansionTile(
      title: Text(
        widget.constructsModel.type == ConstructTypeEnum.morph
            ? getGrammarCopy(
                  category: widget.category,
                  lemma: widget.constructUses.first.lemma,
                  context: context,
                ) ??
                widget.category
            : widget.category,
      ),
      children: xpTiles,
      onExpansionChanged: (expanded) {
        if (expanded) {
          setState(() => _lastLoadedIndex = 50);
        }
      },
    );
  }
}
