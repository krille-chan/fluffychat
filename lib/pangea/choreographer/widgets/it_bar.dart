import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/controllers/it_controller.dart';
import 'package:fluffychat/pangea/choreographer/widgets/it_bar_buttons.dart';
import 'package:fluffychat/pangea/choreographer/widgets/translation_finished_flow.dart';
import 'package:fluffychat/pangea/constants/choreo_constants.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/igc/word_data_card.dart';
import '../../../config/app_config.dart';
import '../../models/it_response_model.dart';
import '../../utils/overlay.dart';
import 'choice_array.dart';

class ITBar extends StatelessWidget {
  final Choreographer choreographer;
  const ITBar({super.key, required this.choreographer});

  ITController get controller => choreographer.itController;

  @override
  Widget build(BuildContext context) {
    if (!controller.isOpen) return const SizedBox();

    return CompositedTransformTarget(
      link: choreographer.itBarLinkAndKey.link,
      child: Container(
        key: choreographer.itBarLinkAndKey.key,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppConfig.borderRadius),
            topRight: Radius.circular(AppConfig.borderRadius),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(0, 3, 3, 3),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     // Row(
                  //     //   mainAxisAlignment: MainAxisAlignment.start,
                  //     //   crossAxisAlignment: CrossAxisAlignment.start,
                  //     //   children: [
                  //     //     CounterDisplay(
                  //     //       correct: controller.correctChoices,
                  //     //       custom: controller.customChoices,
                  //     //       incorrect: controller.incorrectChoices,
                  //     //       yellow: controller.wildcardChoices,
                  //     //     ),
                  //     //     CompositedTransformTarget(
                  //     //       link: choreographer.itBotLayerLinkAndKey.link,
                  //     //       child: ITBotButton(
                  //     //         key: choreographer.itBotLayerLinkAndKey.key,
                  //     //         choreographer: choreographer,
                  //     //       ),
                  //     //     ),
                  //     //   ],
                  //     // ),
                  //     ITCloseButton(choreographer: choreographer),
                  //   ],
                  // ),
                  // const SizedBox(height: 40.0),
                  OriginalText(controller: controller),
                  const SizedBox(height: 7.0),
                  IntrinsicHeight(
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 80),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Center(
                        child: controller.choreographer.errorService.isError
                            ? ITError(
                                error: controller
                                    .choreographer.errorService.error!,
                                controller: controller,
                              )
                            : controller.showChoiceFeedback
                                ? ChoiceFeedbackText(controller: controller)
                                : controller.isTranslationDone
                                    ? TranslationFeedback(
                                        controller: controller,
                                      )
                                    : ITChoices(controller: controller),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: ITCloseButton(choreographer: choreographer),
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceFeedbackText extends StatelessWidget {
  const ChoiceFeedbackText({
    super.key,
    required this.controller,
  });

  final ITController controller;

  @override
  Widget build(BuildContext context) {
    //reimplement if we decide we want it
    return const SizedBox();
    // return AnimatedTextKit(
    //   isRepeatingAnimation: false,
    //   animatedTexts: [
    //     ScaleAnimatedText(
    //       controller.latestChoiceFeedback(context),
    //       duration: Duration(
    //         milliseconds:
    //             (ChoreoConstants.millisecondsToDisplayFeedback / 2).round(),
    //       ),
    //       scalingFactor: 1.4,
    //       textStyle: BotStyle.text(context),
    //     ),
    //   ],
    // );
  }
}

class OriginalText extends StatelessWidget {
  const OriginalText({
    super.key,
    required this.controller,
  });

  final ITController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      padding: const EdgeInsets.only(left: 60.0, right: 40.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConfig.borderRadius),
          topRight: Radius.circular(AppConfig.borderRadius),
        ),
      ),
      child: Row(
        //PTODO - does this already update after reset or we need to setState?
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!controller.isEditingSourceText)
            controller.sourceText != null
                ? Flexible(child: Text(controller.sourceText!))
                : const LinearProgressIndicator(),
          if (controller.isEditingSourceText)
            Expanded(
              child: TextField(
                controller: TextEditingController(text: controller.sourceText),
                autofocus: true,
                enableSuggestions: false,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: controller.onEditSourceTextSubmit,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          if (!controller.isEditingSourceText && controller.sourceText != null)
            IconButton(
              onPressed: () => controller.setIsEditingSourceText(true),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
    );
  }
}

class ITChoices extends StatelessWidget {
  const ITChoices({
    super.key,
    required this.controller,
  });

  // final choices = [
  //   "we need a really long translation to see what's going to happen with that. it should probably have multiple sentences so that we can see what happens there.we need a really long translation to see what's going to happen with that. it should probably have multiple sentences so that we can see what happens there.",
  //   "we need a really long translation to see what's going to happen with that. it should probably have multiple sentences so that we can see what happens there.",
  //   "we need a really long translation to see what's going to happen with that. it should probably have multiple sentences so that we can see what happens there.",
  //   "we need a really long translation to see what's going to happen with that. it should probably have multiple sentences so that we can see what happens there.",
  //   "we need a really long translation to see what's going to happen with that. it should probably have multiple sentences so that we can see what happens there.",
  //   "we need a really long translation to see what's going to happen with that. it should probably have multiple sentences so that we can see what happens there.",
  // ];

  final ITController controller;

  String? get sourceText {
    if ((controller.sourceText == null || controller.sourceText!.isEmpty)) {
      ErrorHandler.logError(m: "null source text in ItChoices");
    }
    return controller.sourceText;
  }

  void showCard(
    BuildContext context,
    int index, [
    Color? borderColor,
    String? choiceFeedback,
  ]) =>
      OverlayUtil.showPositionedCard(
        context: context,
        cardToShow: WordDataCard(
          word: controller.currentITStep!.continuances[index].text,
          wordLang: controller.targetLangCode,
          fullText: sourceText ?? controller.choreographer.currentText,
          fullTextLang: sourceText != null
              ? controller.sourceLangCode
              : controller.targetLangCode,
          hasInfo: controller.currentITStep!.continuances[index].hasInfo,
          choiceFeedback: choiceFeedback,
          room: controller.choreographer.chatController.room,
        ),
        cardSize: const Size(300, 300),
        borderColor: borderColor,
        transformTargetId: controller.choreographer.itBarTransformTargetKey,
        backDropToDismiss: false,
      );

  @override
  Widget build(BuildContext context) {
    try {
      if (controller.isEditingSourceText || controller.currentITStep == null) {
        return const SizedBox();
      }
      return ChoicesArray(
        isLoading: controller.isLoading ||
            controller.choreographer.isFetching ||
            controller.currentITStep == null,
        //TODO - pass current span being translated
        originalSpan: "dummy",
        choices: controller.currentITStep!.continuances.map((e) {
          try {
            return Choice(text: e.text.trim(), color: e.color);
          } catch (e) {
            debugger(when: kDebugMode);
            return Choice(text: "error", color: Colors.red);
          }
        }).toList(),
        onPressed: (int index) {
          final Continuance continuance =
              controller.currentITStep!.continuances[index];
          debugPrint("is gold? ${continuance.gold}");
          if (continuance.level == 1 || continuance.wasClicked) {
            Future.delayed(
              const Duration(milliseconds: 500),
              () => controller.selectTranslation(index),
            );
          } else {
            showCard(
              context,
              index,
              continuance.level == 2
                  ? ChoreoConstants.yellow
                  : ChoreoConstants.red,
              continuance.feedbackText(context),
            );
          }
          controller.currentITStep!.continuances[index].wasClicked = true;
          controller.choreographer.setState();
        },
        onLongPress: (int index) {
          showCard(context, index);
        },
        uniqueKeyForLayerLink: (int index) => "itChoices$index",
        selectedChoiceIndex: null,
      );
    } catch (e) {
      debugger(when: kDebugMode);
      return const SizedBox();
    }
  }
}

class ITError extends StatelessWidget {
  final ITController controller;
  final Object error;
  const ITError({super.key, required this.error, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ErrorCopy errorCopy = ErrorCopy(context, error);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              // Text(
              "${errorCopy.title}\n${errorCopy.body}",
              // Haga clic en su mensaje para ver los significados de las palabras.
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          ITRestartButton(controller: controller),
        ],
      ),
    );
  }
}
