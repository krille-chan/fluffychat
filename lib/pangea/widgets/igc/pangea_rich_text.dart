import 'dart:developer';
import 'dart:ui';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/events/html_message.dart';
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
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../models/pangea_match_model.dart';
import '../../models/pangea_representation_event.dart';
import '../../utils/instructions.dart';

class PangeaRichText extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final TextStyle? style;
  final bool selected;
  final LanguageModel? selectedDisplayLang;
  final bool immersionMode;
  final bool definitions;
  final Choreographer? choreographer;
  final ShowDefintionUtil? messageToolbar;

  const PangeaRichText({
    super.key,
    required this.pangeaMessageEvent,
    required this.selected,
    required this.selectedDisplayLang,
    required this.immersionMode,
    required this.definitions,
    this.choreographer,
    this.style,
    this.messageToolbar,
  });

  @override
  PangeaRichTextState createState() => PangeaRichTextState();
}

class PangeaRichTextState extends State<PangeaRichText> {
  final PangeaController pangeaController = MatrixState.pangeaController;
  bool _fetchingRepresentation = false;
  double get blur => _fetchingRepresentation && widget.immersionMode ? 5 : 0;
  String textSpan = "";

  @override
  void initState() {
    super.initState();
    updateTextSpan();
  }

  @override
  void didUpdateWidget(PangeaRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateTextSpan();
  }

  void updateTextSpan() {
    setState(() {
      textSpan = getTextSpan(context);
      widget.messageToolbar?.messageText = textSpan;
    });
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

    final Widget richText = widget.pangeaMessageEvent.isHtml
        ? HtmlMessage(
            html: textSpan,
            room: widget.pangeaMessageEvent.room,
            textColor: widget.style?.color ?? Colors.black,
            messageToolbar: widget.messageToolbar,
          )
        : SelectableText.rich(
            onSelectionChanged: (selection, cause) =>
                widget.messageToolbar?.onTextSelection(
              selectedText: selection,
              cause: cause,
              context: context,
            ),
            onTap: () => messageToolbar?.onTextTap(context),
            focusNode: widget.messageToolbar?.focusNode,
            contextMenuBuilder: (context, state) =>
                widget.messageToolbar?.contextMenuOverride(
                  context: context,
                  textSelection: state,
                ) ??
                const SizedBox(),
            TextSpan(
              text: textSpan,
              style: widget.style,
              children: [
                if (widget.selected && (_fetchingRepresentation))
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

  String getTextSpan(BuildContext context) {
    final String? displayLangCode =
        widget.selected ? widget.selectedDisplayLang?.langCode : userL2LangCode;

    if (displayLangCode == null || !widget.immersionMode) {
      return widget.pangeaMessageEvent.body;
    }

    if (widget.pangeaMessageEvent.eventId.contains("webdebug")) {
      debugger(when: kDebugMode);
      return widget.pangeaMessageEvent.body;
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
      return widget.pangeaMessageEvent.body;
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
    }

    return widget.pangeaMessageEvent.isHtml
        ? repEvent.formatBody() ?? repEvent.text
        : repEvent.text;
  }

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
}
