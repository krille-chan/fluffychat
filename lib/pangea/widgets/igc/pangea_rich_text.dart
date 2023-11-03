import 'dart:developer';
import 'dart:ui';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../models/igc_text_data_model.dart';
import '../../models/language_detection_model.dart';
import '../../models/pangea_match_model.dart';
import '../../models/pangea_representation_event.dart';
import '../../utils/bot_style.dart';
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
    Key? key,
    required this.pangeaMessageEvent,
    required this.selected,
    required this.selectedDisplayLang,
    required this.immersionMode,
    required this.definitions,
    this.choreographer,
    this.existingStyle,
  }) : super(key: key);

  @override
  PangeaRichTextState createState() => PangeaRichTextState();
}

class PangeaRichTextState extends State<PangeaRichText> {
  final PangeaController pangeaController = MatrixState.pangeaController;
  bool _fetchingRepresentation = false;
  bool _fetchingTokens = false;
  double get blur => _fetchingRepresentation && widget.immersionMode ? 5 : 0;
  List<TextSpan> textSpan = [];

  @override
  void initState() {
    super.initState();
    setState(() => textSpan = getTextSpan(context));
  }

  @override
  void didUpdateWidget(PangeaRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    textSpan = getTextSpan(context);
    setState(() => textSpan = getTextSpan(context));
  }

  @override
  Widget build(BuildContext context) {
    //TODO - take out of build function of every message
    // if (areLanguagesSet) {

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

    final Widget richText = RichText(
      text: TextSpan(
        children: [
          ...textSpan,
          if (widget.selected && (_fetchingRepresentation || _fetchingTokens))
            // if (widget.selected)
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
      ),
    );

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
          Breadcrumb.fromJson({"repEvent.event": repEvent.event?.toJson()}));
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
      defaultStyle: textStyle(repEvent, context),
      handleClick: true,
      spanCardModel: null,
      showTokens: widget.definitions,
      transformTargetId: widget.pangeaMessageEvent.eventId,
      room: widget.pangeaMessageEvent.room,
    );
  }

  List<TextSpan> simpleText(String text) => [
        TextSpan(
          text: text,
          style: widget.existingStyle,
        )
      ];

  List<TextSpan> textWithBotStyle(
          RepresentationEvent repEvent, BuildContext context) =>
      [
        TextSpan(
          text: repEvent.text,
          style: textStyle(repEvent, context),
        )
      ];

  TextStyle? textStyle(RepresentationEvent repEvent, BuildContext context) =>
      // !repEvent.botAuthored
      true
          ? widget.existingStyle
          : BotStyle.text(context,
              existingStyle: widget.existingStyle, setColor: false);

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
      PangeaMatch pangeaMatch, String replacement) async {
    debugPrint("PTODO implement onReplacementSelect");
  }

  Future<void> onSentenceRewrite(String sentenceRewrite) async {
    debugPrint("PTODO implement onSentenceRewrite");
  }
}
