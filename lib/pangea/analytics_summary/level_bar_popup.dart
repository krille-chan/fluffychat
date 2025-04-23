import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/get_analytics_controller.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_bar.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LevelBarPopup extends StatelessWidget {
  const LevelBarPopup({
    super.key,
  });

  GetAnalyticsController get getAnalyticsController =>
      MatrixState.pangeaController.getAnalytics;
  int get level => getAnalyticsController.constructListModel.level;
  int get totalXP => getAnalyticsController.constructListModel.totalXP;
  int get maxLevelXP => getAnalyticsController.minXPForNextLevel;
  List<OneConstructUse> get uses =>
      getAnalyticsController.constructListModel.truncatedUses;

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
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppConfig.gold,
                          child: Icon(
                            size: 30,
                            Icons.star,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          L10n.of(context).levelShort(level),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppConfig.gold,
                          ),
                        ),
                      ],
                    ),
                    Opacity(
                      opacity: 0.25,
                      child: Text(
                        L10n.of(context).levelShort(level + 1),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LearningProgressBar(
                        height: 24,
                        level: level,
                        totalXP: totalXP,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          L10n.of(context).xpIntoLevel(totalXP, maxLevelXP),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppConfig.gold,
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: uses.length,
                    itemBuilder: (context, index) {
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
                                    // const SizedBox(width: 5),
                                    // const CircleAvatar(
                                    //   radius: 8,
                                    //   child: Icon(
                                    //     size: 10,
                                    //     Icons.star,
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
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
          ),
        ),
      ),
    );
  }
}
