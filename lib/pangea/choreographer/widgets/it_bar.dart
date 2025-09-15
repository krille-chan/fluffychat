import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/choreographer/constants/choreo_constants.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/controllers/it_controller.dart';
import 'package:fluffychat/pangea/choreographer/controllers/it_feedback_controller.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/word_data_card.dart';
import 'package:fluffychat/pangea/choreographer/widgets/it_feedback_card.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../common/utils/overlay.dart';
import '../models/it_response_model.dart';
import 'choice_array.dart';

class ITBar extends StatefulWidget {
  final Choreographer choreographer;
  const ITBar({super.key, required this.choreographer});

  @override
  ITBarState createState() => ITBarState();
}

class ITBarState extends State<ITBar> with SingleTickerProviderStateMixin {
  ITController get itController => widget.choreographer.itController;
  StreamSubscription? _choreoSub;

  bool showedClickInstruction = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  bool wasOpen = false;

  @override
  void initState() {
    super.initState();

    // Rebuild the widget each time there's an update from choreo.
    _choreoSub = widget.choreographer.stateStream.stream.listen((_) {
      if (itController.willOpen != wasOpen) {
        itController.willOpen ? _controller.forward() : _controller.reverse();
      }
      wasOpen = itController.willOpen;
      setState(() {});
    });

    wasOpen = itController.willOpen;

    _controller = AnimationController(
      duration: itController.animationSpeed,
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Start in the correct state
    itController.willOpen ? _controller.forward() : _controller.reverse();
  }

  bool get showITInstructionsTooltip {
    final toggledOff = InstructionsEnum.clickBestOption.isToggledOff;
    if (!toggledOff) {
      setState(() => showedClickInstruction = true);
    }
    return !toggledOff;
  }

  bool get showTranslationsChoicesTooltip {
    return !showedClickInstruction &&
        !showITInstructionsTooltip &&
        !itController.choreographer.isFetching &&
        !itController.isLoading &&
        !itController.isEditingSourceText &&
        !itController.isTranslationDone &&
        itController.currentITStep != null &&
        itController.currentITStep!.continuances.isNotEmpty &&
        !itController.showChoiceFeedback;
  }

  @override
  void dispose() {
    _choreoSub?.cancel();
    super.dispose();
  }

  final double iconDimension = 36;
  final double iconSize = 20;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      axisAlignment: -1.0,
      child: CompositedTransformTarget(
        link: widget.choreographer.itBarLinkAndKey.link,
        child: Column(
          spacing: 8.0,
          children: [
            if (showITInstructionsTooltip)
              const InstructionsInlineTooltip(
                instructionsEnum: InstructionsEnum.clickBestOption,
                animate: false,
              ),
            if (showTranslationsChoicesTooltip)
              const InstructionsInlineTooltip(
                instructionsEnum: InstructionsEnum.translationChoices,
                animate: false,
              ),
            Container(
              key: widget.choreographer.itBarLinkAndKey.key,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
              padding: const EdgeInsets.all(3),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (itController.isEditingSourceText)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 10,
                                top: 10,
                              ),
                              child: TextField(
                                controller: TextEditingController(
                                  text: itController.sourceText,
                                ),
                                autofocus: true,
                                enableSuggestions: false,
                                maxLines: null,
                                textInputAction: TextInputAction.send,
                                onSubmitted:
                                    itController.onEditSourceTextSubmit,
                                obscureText: false,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        if (!itController.isEditingSourceText &&
                            itController.sourceText != null)
                          SizedBox(
                            width: iconDimension,
                            height: iconDimension,
                            child: IconButton(
                              iconSize: iconSize,
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                if (itController.nextITStep != null) {
                                  itController.setIsEditingSourceText(true);
                                }
                              },
                              icon: const Icon(Icons.edit_outlined),
                              // iconSize: 20,
                            ),
                          ),
                        if (!itController.isEditingSourceText)
                          SizedBox(
                            width: iconDimension,
                            height: iconDimension,
                            child: IconButton(
                              iconSize: iconSize,
                              color: Theme.of(context).colorScheme.primary,
                              icon: const Icon(Icons.settings_outlined),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (c) => const SettingsLearning(),
                                barrierDismissible: false,
                              ),
                            ),
                          ),
                        SizedBox(
                          width: iconDimension,
                          height: iconDimension,
                          child: IconButton(
                            iconSize: iconSize,
                            color: Theme.of(context).colorScheme.primary,
                            icon: const Icon(Icons.close_outlined),
                            onPressed: () {
                              itController.isEditingSourceText
                                  ? itController.setIsEditingSourceText(false)
                                  : itController.closeIT();
                            },
                          ),
                        ),
                      ],
                    ),
                    if (!itController.isEditingSourceText)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: !itController.willOpen
                            ? const SizedBox()
                            : itController.sourceText != null
                                ? Text(
                                    itController.sourceText!,
                                    textAlign: TextAlign.center,
                                  )
                                : const LinearProgressIndicator(),
                      ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      constraints: const BoxConstraints(minHeight: 80),
                      child: AnimatedSize(
                        duration: itController.animationSpeed,
                        child: Center(
                          child: itController.choreographer.errorService.isError
                              ? ITError(controller: itController)
                              : itController.showChoiceFeedback
                                  ? ChoiceFeedbackText(
                                      controller: itController,
                                    )
                                  : itController.isTranslationDone
                                      ? const SizedBox()
                                      : ITChoices(controller: itController),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
      ErrorHandler.logError(
        m: "null source text in ItChoices",
        data: {},
      );
    }
    return controller.sourceText;
  }

  void showCard(
    BuildContext context,
    int index, [
    Color? borderColor,
    String? choiceFeedback,
  ]) {
    if (controller.currentITStep == null) {
      ErrorHandler.logError(
        m: "currentITStep is null in showCard",
        s: StackTrace.current,
        data: {
          "index": index,
        },
      );
      return;
    }

    controller.choreographer.chatController.inputFocus.unfocus();
    MatrixState.pAnyState.closeOverlay("it_feedback_card");
    OverlayUtil.showPositionedCard(
      context: context,
      cardToShow: choiceFeedback == null
          ? WordDataCard(
              word: controller.currentITStep!.continuances[index].text,
              wordLang: controller.targetLangCode,
              fullText: sourceText ?? controller.choreographer.currentText,
              fullTextLang: sourceText != null
                  ? controller.sourceLangCode
                  : controller.targetLangCode,
              // IMPORTANT COMMENT TO KEEP: We're going to forace hasInfo to false for now
              // because we don't want to show the word data card for correct choices and the contextual definition
              // for incorrect choices. This gives away the answer (if you're Kel at least).
              // The reason hasInfo is false for incorrect choices is that we're not includng the tokens for distractors.
              // Correct choices will have the tokens, but we don't want to show something different for them.
              // hasInfo: controller.currentITStep!.continuances[index].hasInfo,
              hasInfo: false,
              choiceFeedback: choiceFeedback,
              room: controller.choreographer.chatController.room,
            )
          : ITFeedbackCard(
              req: ITFeedbackRequestModel(
                sourceText: sourceText!,
                currentText: controller.choreographer.currentText,
                chosenContinuance:
                    controller.currentITStep!.continuances[index].text,
                bestContinuance: controller.currentITStep!.best.text,
                // TODO: we want this to eventually switch between target and source lang,
                // based on the learner's proficiency - maybe with the words involved in the translation
                // maybe overall. For now, we'll just use the source lang.
                feedbackLang: controller.choreographer.l1Lang?.langCode ??
                    controller.sourceLangCode,
                sourceTextLang: controller.sourceLangCode,
                targetLang: controller.targetLangCode,
              ),
              choiceFeedback: choiceFeedback,
            ),
      maxHeight: 300,
      maxWidth: 300,
      borderColor: borderColor,
      transformTargetId: controller.choreographer.itBarTransformTargetKey,
      isScrollable: choiceFeedback == null,
      overlayKey: "it_feedback_card",
      ignorePointer: true,
    );
  }

  void selectContinuance(int index, BuildContext context) {
    MatrixState.pAnyState.closeOverlay("it_feedback_card");
    final Continuance continuance =
        controller.currentITStep!.continuances[index];
    if (continuance.level == 1) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => controller.selectTranslation(index),
      );
    } else {
      showCard(
        context,
        index,
        continuance.level == 2 ? ChoreoConstants.yellow : ChoreoConstants.red,
        continuance.feedbackText(context),
      );
    }
    controller.currentITStep!.continuances[index].wasClicked = true;
    controller.choreographer.setState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (controller.isEditingSourceText) {
        return const SizedBox();
      }
      if (controller.currentITStep == null) {
        return controller.willOpen
            ? CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Theme.of(context).colorScheme.primary,
              )
            : const SizedBox();
      }
      return ChoicesArray(
        id: controller.currentITStep.hashCode.toString(),
        isLoading: controller.isLoading ||
            controller.choreographer.isFetching ||
            controller.currentITStep == null,
        //TODO - pass current span being translated
        originalSpan: "dummy",
        choices: controller.currentITStep!.continuances.map((e) {
          try {
            return Choice(
              text: e.text.trim(),
              color: e.color,
              isGold: e.description == "best",
            );
          } catch (e) {
            debugger(when: kDebugMode);
            return Choice(text: "error", color: Colors.red);
          }
        }).toList(),
        onPressed: (value, index) => selectContinuance(index, context),
        onLongPress: (value, index) => showCard(context, index),
        selectedChoiceIndex: null,
        langCode: controller.choreographer.pangeaController.languageController
            .activeL2Code(),
      );
    } catch (e) {
      debugger(when: kDebugMode);
      return const SizedBox();
    }
  }
}

class ITError extends StatelessWidget {
  final ITController controller;
  const ITError({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        spacing: 8.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          ErrorIndicator(
            message: L10n.of(context).translationError,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          IconButton(
            onPressed: () {
              controller.closeIT();
              controller.choreographer.errorService.resetError();
            },
            icon: const Icon(
              Icons.close,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
