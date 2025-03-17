import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_list_tile.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Displays vocab analytics, sorted into categories
/// (flowers, greens, and seeds) by points
class VocabAnalyticsListView extends StatefulWidget {
  final void Function(ConstructIdentifier) onConstructZoom;

  const VocabAnalyticsListView({
    super.key,
    required this.onConstructZoom,
  });

  @override
  VocabAnalyticsListViewState createState() => VocabAnalyticsListViewState();
}

class VocabAnalyticsListViewState extends State<VocabAnalyticsListView> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  ConstructLevelEnum? _selectedConstructLevel;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setSelectedConstructLevel(ConstructLevelEnum level) {
    setState(() {
      _selectedConstructLevel = _selectedConstructLevel == level ? null : level;
    });
  }

  void _toggleSearching() {
    setState(() {
      _isSearching = !_isSearching;
      _selectedConstructLevel = null;
      _searchController.clear();
    });
  }

  List<ConstructUses> get _vocab => MatrixState
      .pangeaController.getAnalytics.constructListModel
      .constructList(type: ConstructTypeEnum.vocab)
      .sorted((a, b) => a.lemma.toLowerCase().compareTo(b.lemma.toLowerCase()));

  List<ConstructUses> get _filteredVocab => _vocab
      .where(
        (use) =>
            use.lemma.isNotEmpty &&
            (_selectedConstructLevel == null
                ? true
                : use.lemmaCategory == _selectedConstructLevel) &&
            (_isSearching
                ? use.lemma
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase())
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
            onTap: () => _setSelectedConstructLevel(constructLevelCategory),
            customBorder: const CircleBorder(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedConstructLevel == constructLevelCategory
                    ? constructLevelCategory.color(context).withAlpha(50)
                    : null,
              ),
              padding: const EdgeInsets.all(8.0),
              child: Badge(
                label: Text(count.toString()),
                child: constructLevelCategory.icon(24),
              ),
            ),
          );
        })
        .cast<Widget>()
        .toList();

    filters.add(
      IconButton(
        icon: const Icon(Icons.search_outlined),
        onPressed: _toggleSearching,
      ),
    );

    return Column(
      children: [
        const InstructionsInlineTooltip(
          instructionsEnum: InstructionsEnum.analyticsVocabList,
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding:
                EdgeInsets.symmetric(horizontal: _isSearching ? 8.0 : 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 225.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: _isSearching
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            key: const ValueKey('search'),
                            children: [
                              Expanded(
                                child: TextField(
                                  autofocus: true,
                                  controller: _searchController,
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
                                onPressed: _toggleSearching,
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
        // Padding(
        //   padding: const EdgeInsets.all(32.0),
        //   child: Row(
        //     spacing: _isSearching ? 8.0 : 24.0,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: _isSearching
        //         ? [
        //             ConstrainedBox(
        //               constraints: const BoxConstraints(maxWidth: 200),
        //               child: TextField(
        //                 autofocus: true,
        //                 controller: _searchController,
        //                 decoration: const InputDecoration(
        //                   contentPadding: EdgeInsets.symmetric(
        //                     vertical: 6.0,
        //                     horizontal: 12.0,
        //                   ),
        //                   isDense: true,
        //                   border: OutlineInputBorder(),
        //                 ),
        //                 onChanged: (value) {
        //                   if (mounted) setState(() {});
        //                 },
        //               ),
        //             ),
        //             IconButton(
        //               icon: const Icon(Icons.close),
        //               onPressed: _toggleSearching,
        //             ),
        //           ]
        //         : filters,
        //   ),
        // ),
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
                  onTap: () => widget.onConstructZoom(vocabItem.id),
                  constructUse: vocabItem,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
