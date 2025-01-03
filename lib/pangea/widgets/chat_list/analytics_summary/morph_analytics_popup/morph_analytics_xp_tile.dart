import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_use_model.dart';
import 'package:fluffychat/pangea/utils/grammar/get_grammar_copy.dart';
import 'package:flutter/material.dart';

class ConstructUsesXPTile extends StatelessWidget {
  final ConstructUses constructUses;

  const ConstructUsesXPTile(
    this.constructUses, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProgressIndicatorEnum indicator =
        constructUses.constructType == ConstructTypeEnum.morph
            ? ProgressIndicatorEnum.morphsUsed
            : ProgressIndicatorEnum.wordsUsed;

    return Tooltip(
      message:
          "${constructUses.points} / ${constructUses.constructType.maxXPPerLemma}",
      child: ListTile(
        onTap: () {},
        title: Text(
          constructUses.constructType == ConstructTypeEnum.morph
              ? getGrammarCopy(
                    category: constructUses.category,
                    lemma: constructUses.lemma,
                    context: context,
                  ) ??
                  constructUses.lemma
              : constructUses.lemma,
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: constructUses.points /
                    constructUses.constructType.maxXPPerLemma,
                minHeight: 20,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppConfig.borderRadius),
                ),
                color: indicator.color(context),
              ),
            ),
            const SizedBox(width: 12),
            Text("${constructUses.points}xp"),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
      ),
    );
  }
}
