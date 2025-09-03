import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/enums/span_choice_type.dart';
import 'package:fluffychat/pangea/choreographer/enums/span_data_type.dart';
import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/models/span_data.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import '../../../../widgets/matrix.dart';
import '../../../bot/widgets/bot_face_svg.dart';
import '../choice_array.dart';
import 'why_button.dart';

class SpanCard extends StatefulWidget {
  final int matchIndex;
  final Choreographer choreographer;

  const SpanCard({
    super.key,
    required this.matchIndex,
    required this.choreographer,
  });

  @override
  State<SpanCard> createState() => SpanCardState();
}

class SpanCardState extends State<SpanCard> {
  bool fetchingData = false;
  int? selectedChoiceIndex;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (pangeaMatch?.isITStart == true) {
      _onITStart();
      return;
    }

    getSpanDetails();
    _fetchSelected();
  }

  @override
  void dispose() {
    TtsController.stop();
    scrollController.dispose();
    super.dispose();
  }

  PangeaMatch? get pangeaMatch {
    if (widget.choreographer.igc.igcTextData == null) return null;
    if (widget.matchIndex >=
        widget.choreographer.igc.igcTextData!.matches.length) {
      ErrorHandler.logError(
        m: "matchIndex out of bounds in span card",
        data: {
          "matchIndex": widget.matchIndex,
          "matchesLength": widget.choreographer.igc.igcTextData?.matches.length,
        },
      );
      return null;
    }
    return widget.choreographer.igc.igcTextData?.matches[widget.matchIndex];
  }

  //get selected choice
  SpanChoice? get selectedChoice {
    if (selectedChoiceIndex == null) return null;
    return _choiceByIndex(selectedChoiceIndex!);
  }

  SpanChoice? _choiceByIndex(int index) {
    if (pangeaMatch?.match.choices == null ||
        pangeaMatch!.match.choices!.length <= index) {
      return null;
    }
    return pangeaMatch?.match.choices?[index];
  }

  void _fetchSelected() {
    if (pangeaMatch?.match.choices == null) {
      return;
    }

    // if user ever selected the correct choice, automatically select it
    final selectedCorrectIndex =
        pangeaMatch!.match.choices!.indexWhere((choice) {
      return choice.selected && choice.isBestCorrection;
    });

    if (selectedCorrectIndex != -1) {
      selectedChoiceIndex = selectedCorrectIndex;
      return;
    }

    if (selectedChoiceIndex == null) {
      DateTime? mostRecent;
      final numChoices = pangeaMatch!.match.choices!.length;
      for (int i = 0; i < numChoices; i++) {
        final choice = _choiceByIndex(i);
        if (choice!.timestamp != null &&
            (mostRecent == null || choice.timestamp!.isAfter(mostRecent))) {
          mostRecent = choice.timestamp;
          selectedChoiceIndex = i;
        }
      }
    }
  }

  Future<void> getSpanDetails({bool force = false}) async {
    if (pangeaMatch?.isITStart ?? false) return;

    if (!mounted) return;
    setState(() {
      fetchingData = true;
    });

    await widget.choreographer.igc.spanDataController.getSpanDetails(
      widget.matchIndex,
      force: force,
    );

    if (mounted) {
      setState(() => fetchingData = false);
    }
  }

  void _onITStart() {
    if (widget.choreographer.itEnabled && pangeaMatch != null) {
      widget.choreographer.onITStart(pangeaMatch!);
    }
  }

  Future<void> _onChoiceSelect(int index) async {
    selectedChoiceIndex = index;
    if (selectedChoice != null) {
      selectedChoice!.timestamp = DateTime.now();
      selectedChoice!.selected = true;
      setState(
        () => (selectedChoice!.isBestCorrection
            ? BotExpression.gold
            : BotExpression.surprised),
      );
    }
  }

  Future<void> _onReplaceSelected() async {
    await widget.choreographer.onReplacementSelect(
      matchIndex: widget.matchIndex,
      choiceIndex: selectedChoiceIndex!,
    );
    _showFirstMatch();
  }

  void _onIgnoreMatch() {
    Future.delayed(
      Duration.zero,
      () {
        widget.choreographer.onIgnoreMatch(
          matchIndex: widget.matchIndex,
        );
        _showFirstMatch();
      },
    );
  }

  void _showFirstMatch() {
    if (widget.choreographer.igc.igcTextData != null &&
        widget.choreographer.igc.igcTextData!.matches.isNotEmpty) {
      widget.choreographer.igc.showFirstMatch(context);
    } else {
      MatrixState.pAnyState.closeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WordMatchContent(
      controller: this,
      scrollController: scrollController,
    );
  }
}

class WordMatchContent extends StatelessWidget {
  final SpanCardState controller;
  final ScrollController scrollController;

  const WordMatchContent({
    required this.controller,
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.pangeaMatch == null || controller.pangeaMatch!.isITStart) {
      return const SizedBox();
    }

    return SizedBox(
      height: 300.0,
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    ChoicesArray(
                      originalSpan: controller.pangeaMatch!.matchContent,
                      isLoading: controller.fetchingData,
                      choices: controller.pangeaMatch!.match.choices
                          ?.map(
                            (e) => Choice(
                              text: e.value,
                              color: e.selected ? e.type.color : null,
                              isGold: e.type.name == 'bestCorrection',
                            ),
                          )
                          .toList(),
                      onPressed: (value, index) =>
                          controller._onChoiceSelect(index),
                      selectedChoiceIndex: controller.selectedChoiceIndex,
                      id: controller.pangeaMatch!.hashCode.toString(),
                      langCode: MatrixState.pangeaController.languageController
                          .activeL2Code(),
                    ),
                    const SizedBox(height: 12),
                    PromptAndFeedback(controller: controller),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              spacing: 10.0,
              children: [
                Expanded(
                  child: Opacity(
                    opacity: 0.8,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary.withAlpha(25),
                        ),
                      ),
                      onPressed: controller._onIgnoreMatch,
                      child: Center(
                        child: Text(L10n.of(context).ignoreInThisText),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Opacity(
                    opacity: controller.selectedChoiceIndex != null ? 1.0 : 0.5,
                    child: TextButton(
                      onPressed: controller.selectedChoiceIndex != null
                          ? controller._onReplaceSelected
                          : null,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          (controller.selectedChoice != null
                                  ? controller.selectedChoice!.color
                                  : Theme.of(context).colorScheme.primary)
                              .withAlpha(50),
                        ),
                        // Outline if Replace button enabled
                        side: controller.selectedChoice != null
                            ? WidgetStateProperty.all(
                                BorderSide(
                                  color: controller.selectedChoice!.color,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                              )
                            : null,
                      ),
                      child: Text(L10n.of(context).replace),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PromptAndFeedback extends StatelessWidget {
  const PromptAndFeedback({
    super.key,
    required this.controller,
  });

  final SpanCardState controller;

  @override
  Widget build(BuildContext context) {
    if (controller.pangeaMatch == null) {
      return const SizedBox();
    }

    return Container(
      constraints: controller.pangeaMatch!.isITStart
          ? null
          : const BoxConstraints(minHeight: 75.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (controller.selectedChoice == null && controller.fetchingData)
            const Center(
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(),
              ),
            ),
          if (controller.selectedChoice != null) ...[
            if (controller.selectedChoice?.feedback != null)
              Text(
                controller.selectedChoice!.feedbackToDisplay(context),
                style: BotStyle.text(context),
              ),
            const SizedBox(height: 8),
            if (controller.selectedChoice?.feedback == null)
              WhyButton(
                onPress: () {
                  if (!controller.fetchingData) {
                    controller.getSpanDetails(force: true);
                  }
                },
                loading: controller.fetchingData,
              ),
          ],
          if (!controller.fetchingData &&
              controller.selectedChoiceIndex == null)
            Text(
              controller.pangeaMatch!.match.type.typeName
                  .defaultPrompt(context),
              style: BotStyle.text(context).copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
