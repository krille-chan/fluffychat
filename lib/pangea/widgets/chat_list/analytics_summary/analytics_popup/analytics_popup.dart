import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/analytics_popup/analytics_xp_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class AnalyticsPopup extends StatefulWidget {
  final ProgressIndicatorEnum indicator;
  final ConstructListModel constructsModel;
  final bool showGroups;

  const AnalyticsPopup({
    required this.indicator,
    required this.constructsModel,
    this.showGroups = true,
    super.key,
  });

  @override
  AnalyticsPopupState createState() => AnalyticsPopupState();
}

class AnalyticsPopupState extends State<AnalyticsPopup> {
  String? selectedCategory;

  List<MapEntry<String, List<ConstructUses>>> get categoriesToUses {
    final entries = widget.constructsModel.categoriesToUses.entries.toList();
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

  void setSelectedCategory(String? category) => setState(() {
        selectedCategory = category;
      });

  @override
  Widget build(BuildContext context) {
    Widget? dialogContent;
    final bool hasNoData =
        widget.constructsModel.constructListWithPoints.isEmpty;
    final bool hasNoCategories =
        widget.constructsModel.categoriesToUses.length == 1 &&
            widget.constructsModel.categoriesToUses.keys.first == "Other";

    if (selectedCategory != null) {
      dialogContent = ListView.builder(
        itemCount:
            widget.constructsModel.categoriesToUses[selectedCategory]!.length,
        itemBuilder: (context, index) {
          final constructUses =
              widget.constructsModel.categoriesToUses[selectedCategory]![index];
          return ConstructUsesXPTile(constructUses);
        },
      );
    } else if (hasNoData) {
      dialogContent = Center(child: Text(L10n.of(context)!.noDataFound));
    } else if (hasNoCategories || !widget.showGroups) {
      dialogContent = ListView.builder(
        itemCount: widget.constructsModel.constructListWithPoints.length,
        itemBuilder: (context, index) {
          final constructUses =
              widget.constructsModel.constructListWithPoints[index];
          return ConstructUsesXPTile(constructUses);
        },
      );
    } else {
      dialogContent = ListView.builder(
        itemCount: categoriesToUses.length,
        itemBuilder: (context, index) {
          final category = categoriesToUses[index];
          final copy = widget.constructsModel.type?.getDisplayCopy(
                category.key,
                context,
              ) ??
              category.key;
          return Column(
            children: [
              ListTile(
                title: Text(copy),
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
              title: Text(widget.indicator.tooltip(context)),
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
