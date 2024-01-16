import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/show_defintion_util.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../models/igc_text_data_model.dart';
import '../../models/language_detection_model.dart';
import '../../models/pangea_match_model.dart';
import '../../models/pangea_representation_event.dart';
import '../../utils/instructions.dart';

class PangeaRichText extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final TextStyle? existingStyle;
  final bool selected;
  final LanguageModel? selectedDisplayLang;
  final bool immersionMode;
  final bool definitions;
  final Choreographer? choreographer;

  const PangeaRichText({
    super.key,
    required this.pangeaMessageEvent,
    required this.selected,
    required this.selectedDisplayLang,
    required this.immersionMode,
    required this.definitions,
    this.choreographer,
    this.existingStyle,
  });

  @override
  PangeaRichTextState createState() => PangeaRichTextState();
}

class PangeaRichTextState extends State<PangeaRichText> {
  final PangeaController pangeaController = MatrixState.pangeaController;
  bool _fetchingRepresentation = false;
  bool _fetchingTokens = false;
  double get blur => _fetchingRepresentation && widget.immersionMode ? 5 : 0;
  List<TextSpan> textSpan = [];
  ShowDefintionUtil? messageToolbar;

  @override
  void initState() {
    super.initState();
    setState(() => textSpan = getTextSpan(context));
  }

  @override
  void didUpdateWidget(PangeaRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() => textSpan = getTextSpan(context));
  }

  @override
  Widget build(BuildContext context) {
    //TODO - take out of build function of every message
    // if (areLanguagesSet) {
    messageToolbar = ShowDefintionUtil(
      targetId: widget.pangeaMessageEvent.eventId,
      room: widget.pangeaMessageEvent.room,
      langCode: widget.selectedDisplayLang?.langCode ??
          userL2LangCode ??
          LanguageKeys.unknownLanguage,
      messageText: textSpan.map((x) => x.text).join(),
    );

    if (!widget.selected &&
        widget.selectedDisplayLang != null &&
        widget.selectedDisplayLang!.langCode != LanguageKeys.unknownLanguage) {
      pangeaController.instructions.show(
        context,
        InstructionsEnum.clickMessage,
        widget.pangeaMessageEvent.eventId,
      );
    } else if (blur > 0) {
      pangeaController.instructions.show(
        context,
        InstructionsEnum.blurMeansTranslate,
        widget.pangeaMessageEvent.eventId,
      );
    }

    final TextSpan richTextSpan = TextSpan(
      children: [
        ...textSpan,
        if (widget.selected && (_fetchingRepresentation || _fetchingTokens))
          const WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: AppConfig.secondaryColor,
                ),
              ),
            ),
          ),
      ],
    );

    final Widget richText = widget.selected
        ? SelectableText.rich(
            richTextSpan,
            onSelectionChanged: (selection, cause) => kIsWeb
                ? messageToolbar?.onTextSelection(selection, cause, context)
                : null,
            focusNode: messageToolbar?.focusNode,
            contextMenuBuilder: (context, selection) {
              return AdaptiveTextSelectionToolbar.buttonItems(
                anchors: selection.contextMenuAnchors,
                buttonItems: [
                  ...selection.contextMenuButtonItems,
                  ContextMenuButtonItem(
                    label: L10n.of(context)!.showDefinition,
                    onPressed: () {
                      messageToolbar?.showDefinition(context);
                      messageToolbar?.focusNode.unfocus();
                    },
                  ),
                ],
              );
            },
          )
        : RichText(text: richTextSpan);

    return blur > 0
        ? ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: richText,
          )
        : richText;
  }

  List<TextSpan> getTextSpan(BuildContext context) {
    final String? displayLangCode =
        widget.selected ? widget.selectedDisplayLang?.langCode : userL2LangCode;

    if (displayLangCode == null || !widget.immersionMode) {
      return simpleText(widget.pangeaMessageEvent.body);
    }

    if (widget.pangeaMessageEvent.eventId.contains("webdebug")) {
      debugger(when: kDebugMode);
      return simpleText(widget.pangeaMessageEvent.body);
    }

    final RepresentationEvent? repEvent =
        widget.pangeaMessageEvent.representationByLanguage(
      displayLangCode,
    );

    if (repEvent == null) {
      _fetchingRepresentation = true;

      setState(() => {});
      widget.pangeaMessageEvent
          .representationByLanguageGlobal(
            context: context,
            langCode: displayLangCode,
          )
          .onError((error, stackTrace) => ErrorHandler.logError())
          .whenComplete(() => setState(() => _fetchingRepresentation = false));
      return simpleText(widget.pangeaMessageEvent.body);
    }

    if (repEvent.event?.eventId.contains("web") ?? false) {
      Sentry.addBreadcrumb(
        Breadcrumb.fromJson({"repEvent.event": repEvent.event?.toJson()}),
      );
      Sentry.addBreadcrumb(
        Breadcrumb(
          message:
              "representationByLanguageGlobal returned RepEvent with event ID containing 'web' - ${repEvent.event?.eventId}",
        ),
      );
      // debugger(when: kDebugMode);
      return textWithBotStyle(repEvent, context);
    }

    if (!widget.selected ||
        displayLangCode != userL2LangCode ||
        !widget.definitions) {
      return textWithBotStyle(repEvent, context);
    }

    if (repEvent.tokens == null) {
      setState(() => _fetchingTokens = true);
      repEvent
          .tokensGlobal(context)
          .onError((error, stackTrace) => ErrorHandler.logError())
          .whenComplete(() => setState(() => _fetchingTokens = false));

      return textWithBotStyle(repEvent, context);
    }

    return IGCTextData(
      originalInput: repEvent.text,
      fullTextCorrection: repEvent.text,
      matches: [],
      detections: [LanguageDetection(langCode: displayLangCode)],
      tokens: repEvent.tokens!,
      enableIT: true,
      enableIGC: true,
      userL2: userL2LangCode ?? LanguageKeys.unknownLanguage,
      userL1: userL1LangCode ?? LanguageKeys.unknownLanguage,
    ).constructTokenSpan(
      context: context,
      defaultStyle: widget.existingStyle,
      handleClick: true,
      spanCardModel: null,
      transformTargetId: widget.pangeaMessageEvent.eventId,
      room: widget.pangeaMessageEvent.room,
    );
  }

  List<TextSpan> simpleText(String text) => [
        TextSpan(
          text: text,
          style: widget.existingStyle,
        ),
      ];

  List<TextSpan> textWithBotStyle(
    RepresentationEvent repEvent,
    BuildContext context,
  ) =>
      [
        TextSpan(
          text: repEvent.text,
          style: widget.existingStyle,
        ),
      ];

  bool get areLanguagesSet =>
      userL2LangCode != null && userL2LangCode != LanguageKeys.unknownLanguage;

  String? get userL2LangCode =>
      pangeaController.languageController.activeL2Code(
        roomID: widget.pangeaMessageEvent.room.id,
      );

  String? get userL1LangCode =>
      pangeaController.languageController.activeL1Code(
        roomID: widget.pangeaMessageEvent.room.id,
      );

  Future<void> onIgnore() async {
    debugPrint("PTODO implement onIgnore");
  }

  Future<void> onITStart() async {
    debugPrint("PTODO implement onITStart");
  }

  Future<void> onReplacementSelect(
    PangeaMatch pangeaMatch,
    String replacement,
  ) async {
    debugPrint("PTODO implement onReplacementSelect");
  }

  Future<void> onSentenceRewrite(String sentenceRewrite) async {
    debugPrint("PTODO implement onSentenceRewrite");
  }

  // void onTextSelection(
  //   TextSelection selection,
  //   SelectionChangedCause? _,
  // ) =>
  //     selection.isCollapsed
  //         ? clearTextSelection()
  //         : setTextSelection(selection);

  // void setTextSelection(TextSelection selection) {
  //   textSelection = selection;
  //   if (BrowserContextMenu.enabled && kIsWeb) {
  //     BrowserContextMenu.disableContextMenu();
  //   }
  //   kIsWeb ? showToolbar() : showDefinition();
  // }

  // void clearTextSelection() {
  //   textSelection = null;
  //   if (kIsWeb && !BrowserContextMenu.enabled) {
  //     BrowserContextMenu.enableContextMenu();
  //   }
  // }

  // void showToolbar() async {
  //   if (toolbarShowing || !kIsWeb) return;
  //   toolbarShowing = true;
  //   await Future.delayed(const Duration(seconds: 2));

  //   final toolbarFuture = MessageToolbar.showToolbar(
  //     context,
  //     widget.pangeaMessageEvent.eventId,
  //     _focusNode.offset,
  //   );

  //   final resp = await toolbarFuture;
  //   toolbarShowing = false;

  //   switch (resp) {
  //     case null:
  //       break;
  //     case 1:
  //       showDefinition();
  //       break;
  //     default:
  //       break;
  //   }
  // }

  // void showDefinition() {
  // final String messageText = textSpan.map((x) => x.text).join();
  // final String fullText = textSelection!.textInside(messageText);
  // final String langCode = widget.selectedDisplayLang?.langCode ??
  //     userL2LangCode ??
  //     LanguageKeys.unknownLanguage;

  //   OverlayUtil.showPositionedCard(
  //     context: context,
  //     cardToShow: WordDataCard(
  //       word: fullText,
  //       wordLang: langCode,
  //       fullText: messageText,
  //       fullTextLang: langCode,
  //       hasInfo: false,
  //       room: widget.pangeaMessageEvent.room,
  //     ),
  //     cardSize: const Size(300, 300),
  //     transformTargetId: widget.pangeaMessageEvent.eventId,
  //     backDropToDismiss: false,
  //   );
  // }
}
