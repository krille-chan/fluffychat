import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/construct_use_model.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/analytics_popup/analytics_xp_tile.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AnalyticsPopup extends StatefulWidget {
  final ConstructTypeEnum type;
  final bool showGroups;

  const AnalyticsPopup({
    required this.type,
    this.showGroups = true,
    super.key,
  });

  @override
  AnalyticsPopupState createState() => AnalyticsPopupState();
}

class AnalyticsPopupState extends State<AnalyticsPopup> {
  String? selectedCategory;
  ConstructListModel get _constructsModel =>
      MatrixState.pangeaController.getAnalytics.constructListModel;

  Map<String, List<ConstructUses>> get _categoriesToUses =>
      _constructsModel.categoriesToUses(type: widget.type);

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

  void setSelectedCategory(String? category) => setState(() {
        selectedCategory = category;
      });

  String categoryCopy(category) {
    if (category.toLowerCase() == "other") {
      return L10n.of(context).other;
    }

    return widget.type.getDisplayCopy(
          category,
          context,
        ) ??
        category;
  }

  @override
  Widget build(BuildContext context) {
    Widget? dialogContent;
    final bool hasNoData =
        _constructsModel.constructList(type: widget.type).isEmpty;
    final bool hasNoCategories = _categoriesToUses.length == 1 &&
        _categoriesToUses.entries.first.key == "Other";

    if (selectedCategory != null) {
      dialogContent = Column(
        children: [
          Text(
            categoryCopy(selectedCategory),
            style: const TextStyle(fontSize: 16),
          ),
          Expanded(
            child: ConstructsTileList(
              _categoriesToUses[selectedCategory]!
                  .where((use) => use.points > 0)
                  .toList(),
            ),
          ),
        ],
      );
    } else if (hasNoData) {
      dialogContent = Center(child: Text(L10n.of(context).noDataFound));
    } else if (hasNoCategories || !widget.showGroups) {
      dialogContent = ConstructsTileList(
        _constructsModel
            .constructList(type: widget.type)
            .where((uses) => uses.points > 0)
            .toList(),
      );
    } else {
      dialogContent = ListView.builder(
        // Add a key to the ListView to persist the scroll position
        key: const PageStorageKey<String>('categoryList'),
        itemCount: _sortedEntries.length,
        itemBuilder: (context, index) {
          final category = _sortedEntries[index];
          return Column(
            children: [
              ListTile(
                title: Text(categoryCopy(category.key)),
                trailing: const Icon(Icons.chevron_right_outlined),
                onTap: () => setSelectedCategory(category.key),
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
              title: Text(widget.type.indicator.tooltip(context)),
              leading: IconButton(
                icon: selectedCategory == null
                    ? const Icon(Icons.close)
                    : const Icon(Icons.chevron_left_outlined),
                onPressed: selectedCategory == null
                    ? Navigator.of(context).pop
                    : () => setSelectedCategory(null),
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

class ConstructsTileList extends StatelessWidget {
  final List<ConstructUses> constructs;
  const ConstructsTileList(this.constructs, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: constructs.length,
      itemBuilder: (context, index) => ConstructUsesXPTile(constructs[index]),
    );
  }
}
