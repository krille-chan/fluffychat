import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/pangea/choreographer/controllers/contextual_definition_controller.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../learning_settings/widgets/flag.dart';
import '../../models/word_data_model.dart';
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
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "request": req?.toJson(),
        },
      );
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
      return CardErrorWidget(
        error: controller.wordNetError!,
        maxWidth: AppConfig.toolbarMinWidth,
      );
    }
    if (controller.activeL1 == null || controller.activeL2 == null) {
      ErrorHandler.logError(
        m: "should not be here",
        data: {
          "activeL1": controller.activeL1?.toJson(),
          "activeL2": controller.activeL2?.toJson(),
        },
      );
      return CardErrorWidget(
        error: controller.noLanguages,
        maxWidth: AppConfig.toolbarMinWidth,
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppConfig.toolbarMinWidth,
        maxHeight: AppConfig.toolbarMaxHeight,
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
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
                if (controller.isLoadingWordNet)
                  const ToolbarContentLoadingIndicator(),
                const SizedBox(height: 5.0),
                // if (controller.widget.hasInfo &&
                //     !controller.isLoadingContextualDefinition &&
                //     controller.contextualDefinitionRes == null)
                //   Material(
                //     type: MaterialType.transparency,
                //     child: ListTile(
                //       leading: const BotFace(
                //           width: 40, expression: BotExpression.surprised),
                //       title: Text(L10n.of(context).askPangeaBot),
                //       onTap: controller.handleGetDefinitionButtonPress,
                //     ),
                //   ),
                if (controller.isLoadingContextualDefinition)
                  const ToolbarContentLoadingIndicator(),
                if (controller.contextualDefinitionRes != null)
                  Text(
                    controller.contextualDefinitionRes!.text,
                    style: BotStyle.text(context),
                    textAlign: TextAlign.center,
                  ),
                if (controller.definitionError != null)
                  Text(
                    L10n.of(context).sorryNoResults,
                    style: BotStyle.text(context),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SensesForLanguage(
          wordData: wordData,
          languageType: LanguageType.target,
          language: activeL2,
        ),
        const SizedBox(height: 10),
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
    if (pos == null || pos.isEmpty) pos = L10n.of(context).unkDisplayName;
    return "$word (${wordData.formattedPartOfSpeech(languageType)})";
  }

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LanguageFlag(language: language),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedTitle(context),
                style: BotStyle.text(context, italics: true, bold: false),
              ),
              const SizedBox(height: 4),
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
                        text: "${L10n.of(context).definition}: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: definition),
                    ],
                  ),
                ),
              const SizedBox(height: 4),
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
                        text: "${L10n.of(context).exampleSentence}: ",
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
      ],
    );
  }
}
