import 'dart:developer';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/enum/span_data_type.dart';
import 'package:fluffychat/pangea/models/span_data.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/match_copy.dart';
import 'package:fluffychat/pangea/widgets/igc/card_error_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../widgets/matrix.dart';
import '../../choreographer/widgets/choice_array.dart';
import '../../controllers/pangea_controller.dart';
import '../../enum/span_choice_type.dart';
import '../../models/span_card_model.dart';
import '../common/bot_face_svg.dart';
import 'card_header.dart';
import 'why_button.dart';

const wordMatchResultsCount = 5;

//switch for definition vs correction vs practice

//always show a title
//if description then show description
//choices then show choices
//

class SpanCard extends StatefulWidget {
  final PangeaController pangeaController = MatrixState.pangeaController;
  final SpanCardModel scm;
  final String? roomId;

  SpanCard({
    super.key,
    required this.scm,
    this.roomId,
  });

  @override
  State<SpanCard> createState() => SpanCardState();
}

class SpanCardState extends State<SpanCard> {
  Object? error;
  bool fetchingData = false;
  int? selectedChoiceIndex;

  //on initState, get SpanDetails
  @override
  void initState() {
    // debugger(when: kDebugMode);
    super.initState();
    getSpanDetails();
  }

  //get selected choice
  SpanChoice? get selectedChoice => selectedChoiceIndex != null &&
          widget.scm.pangeaMatch?.match.choices != null
      ? widget.scm.pangeaMatch!.match.choices![selectedChoiceIndex!]
      : null;

  Future<void> getSpanDetails() async {
    try {
      if (widget.scm.pangeaMatch?.isITStart ?? false) return;
      setState(() {
        fetchingData = true;
      });

      await widget.scm.choreographer.igc.getSpanDetails(widget.scm.matchIndex);

      setState(() => fetchingData = false);
    } catch (e) {
      // debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: StackTrace.current);
      setState(() {
        error = e;
        fetchingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WordMatchContent(controller: this);
  }
}

class WordMatchContent extends StatelessWidget {
  final PangeaController pangeaController = MatrixState.pangeaController;
  final SpanCardState controller;

  WordMatchContent({
    required this.controller,
    super.key,
  });

  Future<void> onChoiceSelect(int index) async {
    controller.selectedChoiceIndex = index;
    controller
        .widget
        .scm
        .choreographer
        .igc
        .igcTextData!
        .matches[controller.widget.scm.matchIndex]
        .match
        .choices![index]
        .selected = true;

    controller.setState(() => ());
    // if (controller.widget.scm.pangeaMatch.match.choices![index].type ==
    //     SpanChoiceType.distractor) {
    //   await controller.getSpanDetails();
    // }
    // controller.setState(() {});
  }

  void onReplaceSelected() {
    controller.widget.scm
        .onReplacementSelect(
      matchIndex: controller.widget.scm.matchIndex,
      choiceIndex: controller.selectedChoiceIndex!,
    )
        .then((value) {
      controller.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.widget.scm.pangeaMatch == null) {
      return const SizedBox();
    }
    if (controller.error != null) {
      return CardErrorWidget(
        error: controller.error!,
        choreographer: controller.widget.scm.choreographer,
        offset: controller.widget.scm.pangeaMatch?.match.offset,
      );
    }
    final MatchCopy matchCopy = MatchCopy(
      context,
      controller.widget.scm.pangeaMatch!,
    );

    final ScrollController scrollController = ScrollController();

    try {
      return Column(
        children: [
          CardHeader(
            text: controller.error?.toString() ?? matchCopy.title,
            botExpression: controller.error == null
                ? BotExpression.right
                : BotExpression.addled,
          ),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // const SizedBox(height: 10.0),
                    // if (matchCopy.description != null)
                    //   Padding(
                    //     padding: const EdgeInsets.only(),
                    //     child: Text(
                    //       matchCopy.description!,
                    //       style: BotStyle.text(context),
                    //     ),
                    //   ),
                    const SizedBox(height: 8),
                    if (!controller.widget.scm.pangeaMatch!.isITStart)
                      ChoicesArray(
                        originalSpan:
                            controller.widget.scm.pangeaMatch!.matchContent,
                        isLoading: controller.fetchingData,
                        choices:
                            controller.widget.scm.pangeaMatch!.match.choices
                                ?.map(
                                  (e) => Choice(
                                    text: e.value,
                                    color: e.selected ? e.type.color : null,
                                  ),
                                )
                                .toList(),
                        onPressed: onChoiceSelect,
                        uniqueKeyForLayerLink: (int index) => "wordMatch$index",
                        selectedChoiceIndex: controller.selectedChoiceIndex,
                      ),
                    const SizedBox(height: 12),
                    PromptAndFeedback(controller: controller),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Opacity(
                  opacity: 0.8,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        AppConfig.primaryColor.withOpacity(0.1),
                      ),
                    ),
                    onPressed: () {
                      MatrixState.pAnyState.closeOverlay();
                      Future.delayed(
                        Duration.zero,
                        () => controller.widget.scm.onIgnore(),
                      );
                    },
                    child: Center(
                      child: Text(L10n.of(context)!.ignoreInThisText),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (!controller.widget.scm.pangeaMatch!.isITStart)
                Expanded(
                  child: Opacity(
                    opacity: controller.selectedChoiceIndex != null ? 1.0 : 0.5,
                    child: TextButton(
                      onPressed: controller.selectedChoiceIndex != null
                          ? onReplaceSelected
                          : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          (controller.selectedChoice != null
                                  ? controller.selectedChoice!.color
                                  : AppConfig.primaryColor)
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Text(L10n.of(context)!.replace),
                    ),
                  ),
                ),
              const SizedBox(width: 10),
              if (controller.widget.scm.pangeaMatch!.isITStart)
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      MatrixState.pAnyState.closeOverlay();
                      Future.delayed(
                        Duration.zero,
                        () => controller.widget.scm.onITStart(),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        (AppConfig.primaryColor).withOpacity(0.1),
                      ),
                    ),
                    child: Text(L10n.of(context)!.helpMeTranslate),
                  ),
                ),
            ],
          ),
        ],
      );
    } on Exception catch (e) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: StackTrace.current);
      print(e);
      rethrow;
    }
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
    return Container(
      constraints: controller.widget.scm.pangeaMatch!.isITStart
          ? null
          : const BoxConstraints(minHeight: 100),
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
            Text(
              controller.selectedChoice!.feedbackToDisplay(context),
              style: BotStyle.text(context),
            ),
            const SizedBox(height: 8),
            if (controller.selectedChoice?.feedback == null)
              WhyButton(
                onPress: () {
                  if (!controller.fetchingData) {
                    controller.getSpanDetails();
                  }
                },
                loading: controller.fetchingData,
              ),
          ],
          if (!controller.fetchingData &&
              controller.selectedChoiceIndex == null)
            Text(
              controller.widget.scm.pangeaMatch!.match.type.typeName
                  .defaultPrompt(context),
              style: BotStyle.text(context),
            ),
        ],
      ),
    );
  }
}

class LoadingText extends StatefulWidget {
  const LoadingText({
    super.key,
  });

  @override
  _LoadingTextState createState() => _LoadingTextState();
}

class _LoadingTextState extends State<LoadingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          L10n.of(context)!.makingActivity,
          style: BotStyle.text(context),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Text(
              _controller.isAnimating ? '.' * _controller.value.toInt() : '',
              style: BotStyle.text(context),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class StartITButton extends StatelessWidget {
  const StartITButton({
    super.key,
    required this.onITStart,
  });

  final void Function() onITStart;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        leading: const Icon(Icons.translate_outlined),
        title: Text(L10n.of(context)!.helpMeTranslate),
        onTap: () {
          MatrixState.pAnyState.closeOverlay();
          Future.delayed(Duration.zero, () => onITStart());
        },
      ),
    );
  }
}
