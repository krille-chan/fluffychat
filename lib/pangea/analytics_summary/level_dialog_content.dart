import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/get_analytics_controller.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LevelDialogContent extends StatelessWidget {
  const LevelDialogContent({
    super.key,
  });

  GetAnalyticsController get analytics =>
      MatrixState.pangeaController.getAnalytics;

  int get level => analytics.constructListModel.level;
  int get totalXP => analytics.constructListModel.totalXP;
  int get maxLevelXP => analytics.minXPForNextLevel;
  List<OneConstructUse> get uses => analytics.constructListModel.truncatedUses;

  bool get _loading =>
      !MatrixState.pangeaController.getAnalytics.initCompleter.isCompleted;

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return StreamBuilder(
      stream: analytics.analyticsStream.stream,
      builder: (context, _) {
        if (_loading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "⭐ ${L10n.of(context).levelShort(level)}",
                    style: TextStyle(
                      fontSize: isColumnMode ? 24 : 16,
                      fontWeight: FontWeight.w900,
                      color: AppConfig.gold,
                    ),
                  ),
                  Text(
                    L10n.of(context).xpIntoLevel(totalXP, maxLevelXP),
                    style: TextStyle(
                      fontSize: isColumnMode ? 24 : 16,
                      fontWeight: FontWeight.w900,
                      color: AppConfig.gold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: uses.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const InstructionsInlineTooltip(
                        instructionsEnum: InstructionsEnum.levelAnalytics,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      );
                    }
                    index--;

                    final use = uses[index];
                    String lemmaCopy = use.lemma;
                    if (use.constructType == ConstructTypeEnum.morph) {
                      lemmaCopy = getGrammarCopy(
                            category: use.category,
                            lemma: use.lemma,
                            context: context,
                          ) ??
                          use.lemma;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 40,
                                alignment: Alignment.centerLeft,
                                child: Icon(use.useType.icon),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "\"$lemmaCopy\" - ${use.useType.description(context)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              width: 60,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${use.xp > 0 ? '+' : ''}${use.xp}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                      height: 1,
                                      color: use.pointValueColor(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
