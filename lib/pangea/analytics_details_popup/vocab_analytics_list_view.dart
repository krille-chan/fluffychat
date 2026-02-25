import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:diacritic/diacritic.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_list_tile.dart';
import 'package:fluffychat/pangea/analytics_downloads/analytics_download_button.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_navigation_util.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/text_to_speech/tts_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Displays vocab analytics, sorted into categories
/// (flowers, greens, and seeds) by points
class VocabAnalyticsListView extends StatelessWidget {
  final ConstructAnalyticsViewState controller;

  const VocabAnalyticsListView({super.key, required this.controller});

  List<ConstructUses>? get _filteredVocab =>
      controller.vocab?.where(_vocabFilter).sorted(_sortBySearch).toList();

  bool _vocabFilter(ConstructUses use) =>
      _levelFilter(use) && _searchFilter(use);

  bool _levelFilter(ConstructUses use) {
    if (controller.selectedConstructLevel == null) {
      return true;
    }
    return use.lemmaCategory == controller.selectedConstructLevel;
  }

  bool _searchFilter(ConstructUses use) {
    if (!controller.isSearching ||
        controller.searchController.text.trim().isEmpty) {
      return true;
    }

    final normalizedLemma = removeDiacritics(use.lemma).toLowerCase();
    final normalizedSearch = removeDiacritics(
      controller.searchController.text,
    ).toLowerCase();

    return normalizedLemma.contains(normalizedSearch);
  }

  int _sortBySearch(ConstructUses a, ConstructUses b) {
    if (!controller.isSearching ||
        controller.searchController.text.trim().isEmpty) {
      return 0; // No sorting if not searching
    }

    final normalizedSearch = removeDiacritics(
      controller.searchController.text,
    ).toLowerCase();

    final normalizedLemmaA = removeDiacritics(a.lemma).toLowerCase();
    final normalizedLemmaB = removeDiacritics(b.lemma).toLowerCase();

    // Sort matches that start with the search term first, then by closest match
    final startsWithA = normalizedLemmaA.startsWith(normalizedSearch);
    final startsWithB = normalizedLemmaB.startsWith(normalizedSearch);

    if (startsWithA && !startsWithB) {
      return -1; // A comes first
    } else if (!startsWithA && startsWithB) {
      return 1; // B comes first
    } else {
      // If both start with the search term or neither does, sort by closest match
      final indexA = normalizedLemmaA.indexOf(normalizedSearch);
      final indexB = normalizedLemmaB.indexOf(normalizedSearch);
      if (indexA == -1 && indexB == -1) {
        return 0; // Neither contains the search term
      } else if (indexA == -1) {
        return 1; // B comes first
      } else if (indexB == -1) {
        return -1; // A comes first
      } else {
        return indexA.compareTo(indexB); // Closer match comes first
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vocab = controller.vocab;
    final List<Widget> filters = ConstructLevelEnum.values.reversed
        .map((constructLevelCategory) {
          final int count =
              vocab
                  ?.where((e) => e.lemmaCategory == constructLevelCategory)
                  .length ??
              0;

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

    final constructParam = GoRouterState.of(
      context,
    ).pathParameters['construct'];

    ConstructIdentifier? selectedConstruct;
    if (constructParam != null) {
      try {
        selectedConstruct = ConstructIdentifier.fromJson(
          jsonDecode(constructParam),
        );
      } catch (e) {
        debugPrint("Invalid construct ID format in route: $constructParam");
      }
    }

    final filteredVocab = _filteredVocab;
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
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: controller.isSearching
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      key: const ValueKey('search'),
                      children: [
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            focusNode: controller.searchFocusNode,
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
                  : controller.selectMode
                  ? Row(
                      mainAxisAlignment: .spaceBetween,
                      key: const ValueKey('selection'),
                      children: [
                        Row(
                          mainAxisSize: .min,
                          children: [
                            IconButton(
                              onPressed: controller.clearSelectedConstructs,
                              icon: const Icon(Icons.close),
                            ),
                            Text(
                              "${controller.selectedConstructs.length}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: controller.blockSelectedConstructs,
                          icon: Icon(Icons.delete_outline),
                          color: Theme.of(context).colorScheme.error,
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
              if (!controller.isSearching &&
                  controller.selectedConstructLevel == null)
                const SliverToBoxAdapter(
                  child: InstructionsInlineTooltip(
                    instructionsEnum: InstructionsEnum.analyticsVocabList,
                  ),
                ),

              // Grid of vocab tiles
              if (filteredVocab == null)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                )
              else
                filteredVocab.isEmpty
                    ? SliverToBoxAdapter(
                        child: controller.selectedConstructLevel != null
                            ? Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  L10n.of(context).vocabLevelsDesc,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : const SizedBox.shrink(),
                      )
                    : SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 100.0,
                              mainAxisExtent: 100.0,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final vocabItem = filteredVocab[index];
                          return VocabAnalyticsListTile(
                            onTap: controller.selectMode
                                ? () => controller.toggleSelectedConstruct(
                                    vocabItem.id,
                                  )
                                : () {
                                    TtsController.tryToSpeak(
                                      vocabItem.id.lemma,
                                      langCode: MatrixState
                                          .pangeaController
                                          .userController
                                          .userL2Code!,
                                      pos: vocabItem.id.category,
                                    );
                                    AnalyticsNavigationUtil.navigateToAnalytics(
                                      context: context,
                                      view: ProgressIndicatorEnum.wordsUsed,
                                      construct: vocabItem.id,
                                    );
                                  },
                            onLongPress: () {
                              controller.toggleSelectedConstruct(vocabItem.id);
                            },
                            constructId: vocabItem.id,
                            textColor:
                                Theme.of(context).brightness == Brightness.light
                                ? vocabItem.lemmaCategory.darkColor(context)
                                : vocabItem.lemmaCategory.color(context),
                            level: vocabItem.lemmaCategory,
                            selected:
                                vocabItem.id == selectedConstruct ||
                                controller.selectedConstructs.contains(
                                  vocabItem.id,
                                ),
                          );
                        }, childCount: filteredVocab.length),
                      ),
              const SliverToBoxAdapter(child: SizedBox(height: 75.0)),
            ],
          ),
        ),
      ],
    );
  }
}
