import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_list_tile.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Displays vocab analytics, sorted into categories
/// (flowers, greens, and seeds) by points
class VocabAnalyticsListView extends StatelessWidget {
  final AnalyticsPopupWrapperState controller;

  const VocabAnalyticsListView({
    super.key,
    required this.controller,
  });

  List<ConstructUses> get _vocab => MatrixState
      .pangeaController.getAnalytics.constructListModel
      .constructList(type: ConstructTypeEnum.vocab)
      .sorted((a, b) => a.lemma.toLowerCase().compareTo(b.lemma.toLowerCase()));

  List<ConstructUses> get _filteredVocab => _vocab
      .where(
        (use) =>
            use.lemma.isNotEmpty &&
            (controller.selectedConstructLevel == null
                ? true
                : use.lemmaCategory == controller.selectedConstructLevel) &&
            (controller.isSearching
                ? use.lemma
                    .toLowerCase()
                    .contains(controller.searchController.text.toLowerCase())
                : true),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final List<Widget> filters = ConstructLevelEnum.values.reversed
        .map((constructLevelCategory) {
          final int count = _vocab
              .where((e) => e.lemmaCategory == constructLevelCategory)
              .length;
          return InkWell(
            onTap: () =>
                controller.setSelectedConstructLevel(constructLevelCategory),
            customBorder: const CircleBorder(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    controller.selectedConstructLevel == constructLevelCategory
                        ? constructLevelCategory.color(context).withAlpha(50)
                        : null,
              ),
              padding: const EdgeInsets.all(8.0),
              child: Badge(
                label: Text(count.toString()),
                child: constructLevelCategory.icon(40),
              ),
            ),
          );
        })
        .cast<Widget>()
        .toList();

    filters.add(
      IconButton(
        icon: const Icon(Icons.search_outlined),
        onPressed: controller.toggleSearching,
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const InstructionsInlineTooltip(
            instructionsEnum: InstructionsEnum.analyticsVocabList,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: controller.isSearching ? 8.0 : 24.0,
            ),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                      child: controller.isSearching
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              key: const ValueKey('search'),
                              children: [
                                Expanded(
                                  child: TextField(
                                    autofocus: true,
                                    controller: controller.searchController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 6.0,
                                        horizontal: 12.0,
                                      ),
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: controller.toggleSearching,
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              key: const ValueKey('filters'),
                              children: filters,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100.0,
                  mainAxisExtent: 100.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _filteredVocab.length,
                itemBuilder: (context, index) {
                  final vocabItem = _filteredVocab[index];
                  return VocabAnalyticsListTile(
                    onTap: () => controller.setConstructZoom(vocabItem.id),
                    constructUse: vocabItem,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
