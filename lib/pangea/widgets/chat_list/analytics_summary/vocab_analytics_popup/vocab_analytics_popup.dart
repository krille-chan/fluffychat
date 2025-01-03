import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/construct_use_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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

  List<ConstructUses> get _sortedEntries {
    final entries =
        _constructsModel.constructList(type: ConstructTypeEnum.vocab);
    entries.sort((a, b) => b.points.compareTo(a.points));
    return entries;
  }

  // a wrapped list of chips with the content of the lemmas and no border/background/etc
  // when construct(n).xpEmoji != construct(n+1).xpEmoji, add a ListTile with the n+1 emoji
  Widget get dialogContent {
    if (_constructsModel.constructList(type: ConstructTypeEnum.vocab).isEmpty) {
      return Center(child: Text(L10n.of(context).noDataFound));
    }

    final List<Widget> tiles = [];
    for (int i = 0; i < _sortedEntries.length; i++) {
      final construct = _sortedEntries[i];
      final nextConstruct =
          i + 1 < _sortedEntries.length ? _sortedEntries[i + 1] : null;

      tiles.add(
        VocabChip(
          construct: construct,
          onTap: () {
            print("TODO: Implement this ${construct.lemma}");
          },
        ),
      );

      if (nextConstruct != null && construct.points != nextConstruct.points) {
        tiles.add(
          ListTile(
            title: Text(nextConstruct.points.toString()),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      }
    }

    return ListView(
      children: tiles,
    );
  }

  @override
  Widget build(BuildContext context) {
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
              title: Text(ProgressIndicatorEnum.wordsUsed.tooltip(context)),
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

// a simple chip with the text of the lemma
// highlights on hover
// callback on click
// has some padding to separate from other chips
// otherwise, is very visually simple with transparent border/background/etc
class VocabChip extends StatelessWidget {
  final ConstructUses construct;
  final VoidCallback onTap;

  const VocabChip({
    super.key,
    required this.construct,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text(
            construct.lemma,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}

/// A container with rounded corners and background color