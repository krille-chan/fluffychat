import 'package:flutter/material.dart';

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
class VocabAnalyticsListView extends StatelessWidget {
  final void Function(ConstructIdentifier) onConstructZoom;

  List<ConstructUses> get vocab => MatrixState
      .pangeaController.getAnalytics.constructListModel
      .constructList(type: ConstructTypeEnum.vocab)
    ..sort((a, b) => a.lemma.toLowerCase().compareTo(b.lemma.toLowerCase()));

  const VocabAnalyticsListView({
    super.key,
    required this.onConstructZoom,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const InstructionsInlineTooltip(
            instructionsEnum: InstructionsEnum.analyticsVocabList,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 50,
              children: ConstructLevelEnum.values.reversed
                  .map((constructLevelCategory) {
                final int count = vocab
                    .where((e) => e.lemmaCategory == constructLevelCategory)
                    .length;

                return Badge(
                  label: Text(count.toString()),
                  child: constructLevelCategory.icon(24),
                );
              }).toList(),
            ),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.start,
            children: vocab
                .map(
                  (vocab) => VocabAnalyticsListTile(
                    onTap: () => onConstructZoom(vocab.id),
                    constructUse: vocab,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
