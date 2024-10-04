import 'dart:developer';

import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/controllers/contextual_definition_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/widgets/common/p_circular_loader.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart';
import 'package:matrix/matrix.dart';

import '../../models/word_data_model.dart';
import '../flag.dart';
import 'card_error_widget.dart';

class WordDataCard extends StatefulWidget {
  final bool hasInfo;
  final String word;
  final String fullText;
  final String? choiceFeedback;
  final String wordLang;
  final String fullTextLang;
  final Room room;

  const WordDataCard({
    super.key,
    required this.word,
    required this.wordLang,
    required this.hasInfo,
    required this.fullText,
    required this.fullTextLang,
    required this.room,
    this.choiceFeedback,
  });

  @override
  State<WordDataCard> createState() => WordDataCardController();
}

class WordDataCardController extends State<WordDataCard> {
  final PangeaController controller = MatrixState.pangeaController;

  bool isLoadingWordNet = false;
  bool isLoadingContextualDefinition = false;
  ContextualDefinitionResponseModel? contextualDefinitionRes;
  WordData? wordData;
  Object? wordNetError;

  Object? definitionError;
  LanguageModel? activeL1;
  LanguageModel? activeL2;

  Response get noLanguages => Response("", 405);

  @override
  void initState() {
    if (!mounted) return;
    activeL1 = controller.languageController.activeL1Model()!;
    activeL2 = controller.languageController.activeL2Model()!;
    if (activeL1 == null || activeL2 == null) {
      wordNetError = noLanguages;
      definitionError = noLanguages;
    } else if (!widget.hasInfo) {
      getContextualDefinition();
    } else {
      getWordNet();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WordDataCard oldWidget) {
    // debugger(when: kDebugMode);
    if (oldWidget.word != widget.word) {
      if (!widget.hasInfo) {
        getContextualDefinition();
      } else {
        getWordNet();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> getContextualDefinition() async {
    ContextualDefinitionRequestModel? req;
    try {
      req = ContextualDefinitionRequestModel(
        fullText: widget.fullText,
        word: widget.word,
        feedbackLang: activeL1?.langCode ?? LanguageKeys.defaultLanguage,
        fullTextLang: widget.fullTextLang,
        wordLang: widget.wordLang,
      );
      if (!mounted) return;

      setState(() {
        contextualDefinitionRes = null;
        definitionError = null;
        isLoadingContextualDefinition = true;
      });

      contextualDefinitionRes = await controller.definitions.get(req);
      if (contextualDefinitionRes == null) {
        definitionError = Exception("Error getting definition");
      }
      GoogleAnalytics.contextualRequest();
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack, data: req?.toJson());
      definitionError = Exception("Error getting definition");
    } finally {
      if (mounted) setState(() => isLoadingContextualDefinition = false);
    }
  }

  Future<void> getWordNet() async {
    if (mounted) {
      setState(() {
        wordData = null;
        isLoadingWordNet = true;
      });
    }
    try {
      wordData = await controller.wordNet.getWordDataGlobal(
        word: widget.word,
        fullText: widget.fullText,
        userL1: activeL1?.langCode,
        userL2: activeL2?.langCode,
      );
    } catch (err) {
      ErrorHandler.logError(
        e: err,
        s: StackTrace.current,
        data: {"word": widget.word, "hasInfo": widget.hasInfo},
      );
      wordNetError = err;
    } finally {
      if (mounted) setState(() => isLoadingWordNet = false);
    }
  }

  void handleGetDefinitionButtonPress() {
    if (isLoadingContextualDefinition) return;
    getContextualDefinition();
  }

  @override
  Widget build(BuildContext context) => WordDataCardView(controller: this);
}

class WordDataCardView extends StatelessWidget {
  const WordDataCardView({
    super.key,
    required this.controller,
  });

  final WordDataCardController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.wordNetError != null) {
      return CardErrorWidget(error: controller.wordNetError);
    }
    if (controller.activeL1 == null || controller.activeL2 == null) {
      ErrorHandler.logError(m: "should not be here");
      return CardErrorWidget(error: controller.noLanguages);
    }

    final ScrollController scrollController = ScrollController();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (controller.widget.choiceFeedback != null)
                Text(
                  controller.widget.choiceFeedback!,
                  style: BotStyle.text(context),
                ),
              const SizedBox(height: 5.0),
              if (controller.wordData != null &&
                  controller.wordNetError == null &&
                  controller.activeL1 != null &&
                  controller.activeL2 != null)
                WordNetInfo(
                  wordData: controller.wordData!,
                  activeL1: controller.activeL1!,
                  activeL2: controller.activeL2!,
                ),
              if (controller.isLoadingWordNet) const PCircular(),
              const SizedBox(height: 5.0),
              // if (controller.widget.hasInfo &&
              //     !controller.isLoadingContextualDefinition &&
              //     controller.contextualDefinitionRes == null)
              //   Material(
              //     type: MaterialType.transparency,
              //     child: ListTile(
              //       leading: const BotFace(
              //           width: 40, expression: BotExpression.surprised),
              //       title: Text(L10n.of(context)!.askPangeaBot),
              //       onTap: controller.handleGetDefinitionButtonPress,
              //     ),
              //   ),
              if (controller.isLoadingContextualDefinition) const PCircular(),
              if (controller.contextualDefinitionRes != null)
                Text(
                  controller.contextualDefinitionRes!.text,
                  style: BotStyle.text(context),
                ),
              if (controller.definitionError != null)
                Text(
                  L10n.of(context)!.sorryNoResults,
                  style: BotStyle.text(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordNetInfo extends StatelessWidget {
  final WordData wordData;
  final LanguageModel activeL1;
  final LanguageModel activeL2;

  const WordNetInfo({
    super.key,
    required this.wordData,
    required this.activeL1,
    required this.activeL2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SensesForLanguage(
          wordData: wordData,
          languageType: LanguageType.target,
          language: activeL2,
        ),
        SensesForLanguage(
          wordData: wordData,
          languageType: LanguageType.base,
          language: activeL1,
        ),
      ],
    );
  }
}

enum LanguageType {
  target,
  base,
}

class SensesForLanguage extends StatelessWidget {
  const SensesForLanguage({
    super.key,
    required this.wordData,
    required this.languageType,
    required this.language,
  });

  final LanguageModel language;
  final LanguageType languageType;
  final WordData wordData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
            child: LanguageFlag(
              language: language,
            ),
          ),
          Expanded(
            child: PartOfSpeechBlock(
              wordData: wordData,
              languageType: languageType,
            ),
          ),
        ],
      ),
    );
  }
}

class PartOfSpeechBlock extends StatelessWidget {
  final WordData wordData;
  final LanguageType languageType;

  const PartOfSpeechBlock({
    super.key,
    required this.wordData,
    required this.languageType,
  });

  String get exampleSentence => languageType == LanguageType.target
      ? wordData.targetExampleSentence
      : wordData.baseExampleSentence;

  String get definition => languageType == LanguageType.target
      ? wordData.targetDefinition
      : wordData.baseDefinition;

  String formattedTitle(BuildContext context) {
    final String word = languageType == LanguageType.target
        ? wordData.targetWord
        : wordData.baseWord;
    String? pos = wordData.formattedPartOfSpeech(languageType);
    if (pos == null || pos.isEmpty) pos = L10n.of(context)!.unkDisplayName;
    return "$word (${wordData.formattedPartOfSpeech(languageType)})";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              formattedTitle(context),
              style: BotStyle.text(context, italics: true, bold: false),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 14.0, bottom: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  if (definition.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        style: BotStyle.text(
                          context,
                          italics: false,
                          bold: false,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "${L10n.of(context)!.definition}: ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: definition),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (exampleSentence.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        style: BotStyle.text(
                          context,
                          italics: false,
                          bold: false,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "${L10n.of(context)!.exampleSentence}: ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: exampleSentence),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectToDefine extends StatelessWidget {
  const SelectToDefine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            L10n.of(context)!.selectToDefine,
            style: BotStyle.text(context),
          ),
        ),
      ),
    );
  }
}
