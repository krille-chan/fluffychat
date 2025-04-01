import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/choreographer/widgets/it_feedback_stars.dart';
import '../../bot/utils/bot_style.dart';
import '../../common/utils/error_handler.dart';
import '../controllers/it_controller.dart';

class TranslationFeedback extends StatelessWidget {
  final int vocabCount;
  final int grammarCount;
  final String feedbackText;

  final ITController controller;
  const TranslationFeedback({
    super.key,
    required this.controller,
    required this.vocabCount,
    required this.grammarCount,
    required this.feedbackText,
  });

  @override
  Widget build(BuildContext context) {
    final altTranslator = controller.choreographer.altTranslator;
    try {
      return Column(
        spacing: 16.0,
        children: [
          FillingStars(rating: altTranslator.starRating),
          if (vocabCount > 0 || grammarCount > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16.0,
              children: [
                if (vocabCount > 0)
                  Row(
                    spacing: 8.0,
                    children: [
                      Icon(
                        Symbols.dictionary,
                        color: ProgressIndicatorEnum.wordsUsed.color(context),
                        size: 24,
                      ),
                      Text(
                        "+ $vocabCount",
                        style: TextStyle(
                          color: ProgressIndicatorEnum.wordsUsed.color(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                if (grammarCount > 0)
                  Row(
                    spacing: 8.0,
                    children: [
                      Icon(
                        Symbols.toys_and_games,
                        color: ProgressIndicatorEnum.morphsUsed.color(context),
                        size: 24,
                      ),
                      Text(
                        "+ $grammarCount",
                        style: TextStyle(
                          color:
                              ProgressIndicatorEnum.morphsUsed.color(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            )
          else
            Text(
              feedbackText,
              textAlign: TextAlign.center,
              style: BotStyle.text(context),
            ),
          const SizedBox(height: 16.0),
        ],
      );
    } catch (err, stack) {
      debugPrint("Error in TranslationFeedback: $err");
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {},
      );

      // Fallback to a simple message if anything goes wrong
      return Center(child: Text(L10n.of(context).niceJob));
    }
  }
}
