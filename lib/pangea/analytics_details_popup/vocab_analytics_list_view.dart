import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_list_tile.dart';
import 'package:fluffychat/pangea/analytics_downloads/analytics_download_button.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Displays vocab analytics, sorted into categories
/// (flowers, greens, and seeds) by points
class VocabAnalyticsListView extends StatelessWidget {
  final ConstructAnalyticsViewState controller;

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

    if (kIsWeb) {
      filters.add(const DownloadAnalyticsButton());
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            height: 60,
            alignment: Alignment.center,
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
                      spacing: FluffyThemes.isColumnMode(context) ? 16.0 : 4.0,
                      mainAxisAlignment: MainAxisAlignment.end,
                      key: const ValueKey('filters'),
                      children: filters,
                    ),
            ),
          ),
        ),
        Expanded(
          child: CustomScrollView(
            key: const PageStorageKey("vocab-analytics-list-view-page-key"),
            slivers: [
              // Full-width tooltip
              const SliverToBoxAdapter(
                child: InstructionsInlineTooltip(
                  instructionsEnum: InstructionsEnum.analyticsVocabList,
                ),
              ),

              // Grid of vocab tiles
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100.0,
                  mainAxisExtent: 100.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final vocabItem = _filteredVocab[index];
                    return VocabAnalyticsListTile(
                      onTap: () => context.go(
                        "/rooms/analytics/${vocabItem.id.type.string}/${vocabItem.id.string}",
                      ),
                      constructUse: vocabItem,
                      emoji: vocabItem.id.userSetEmoji.firstOrNull ??
                          vocabItem.id.getLemmaInfoCached()?.emoji.firstOrNull,
                    );
                  },
                  childCount: _filteredVocab.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
