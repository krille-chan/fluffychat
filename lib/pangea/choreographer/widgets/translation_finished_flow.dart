import 'package:flutter/material.dart';

import '../../bot/utils/bot_style.dart';
import '../../common/utils/error_handler.dart';
import '../controllers/it_controller.dart';
import 'choice_array.dart';

class TranslationFeedback extends StatelessWidget {
  final ITController controller;
  const TranslationFeedback({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    String feedbackText;
    TextStyle? style;
    try {
      feedbackText =
          controller.choreographer.altTranslator.translationFeedback(context);
      style = BotStyle.text(context);
    } catch (err, stack) {
      feedbackText = "Nice job!";
      style = null;
      debugPrint("error getting copy and styles");
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "feedbackText": controller.choreographer.altTranslator
              .translationFeedback(context),
        },
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (controller.choreographer.altTranslator.showTranslationFeedback)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$feedbackText ",
                      style: style,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 6),
          if (controller
              .choreographer.altTranslator.showAlternativeTranslations)
            AlternativeTranslations(controller: controller),
          // if (!controller
          //         .choreographer.altTranslator.showAlternativeTranslations &&
          //     !controller.choreographer.isFetching)
          //   ITRestartButton(controller: controller),
        ],
      ),
    );
  }
}

class AlternativeTranslations extends StatelessWidget {
  const AlternativeTranslations({
    super.key,
    required this.controller,
  });

  final ITController controller;

  @override
  Widget build(BuildContext context) {
    return ChoicesArray(
      originalSpan: controller.sourceText ?? "dummy",
      isLoading:
          controller.choreographer.altTranslator.loadingAlternativeTranslations,
      // choices: controller.choreographer.altTranslator.similarityResponse.scores
      choices: [
        Choice(text: controller.choreographer.altTranslator.translations.first),
      ],
      // choices: controller.choreographer.altTranslator.translations,
      onPressed: (String value, int index) {
        controller.choreographer.onSelectAlternativeTranslation(
          controller.choreographer.altTranslator.translations[index],
        );
      },
      selectedChoiceIndex: null,
      tts: null,
    );
  }
}
