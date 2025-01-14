import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_show_popup.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_toolbar_selection_area.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../models/pangea_match_model.dart';

class PangeaRichText extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final bool immersionMode;
  final TextStyle? style;
  final bool isOverlay;
  final ChatController controller;
  final Event? nextEvent;
  final Event? prevEvent;

  const PangeaRichText({
    super.key,
    required this.pangeaMessageEvent,
    required this.immersionMode,
    required this.isOverlay,
    required this.controller,
    this.nextEvent,
    this.prevEvent,
    this.style,
  });

  @override
  PangeaRichTextState createState() => PangeaRichTextState();
}

class PangeaRichTextState extends State<PangeaRichText> {
  final PangeaController pangeaController = MatrixState.pangeaController;
  bool _fetchingRepresentation = false;
  double get blur => (_fetchingRepresentation && widget.immersionMode) ||
          !pangeaController.languageController.languagesSet
      ? 5
      : 0;
  String textSpan = "";
  PangeaRepresentation? repEvent;

  @override
  void initState() {
    super.initState();
    setTextSpan();
  }

  @override
  void didUpdateWidget(PangeaRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    setTextSpan();
  }

  void _setTextSpan(String newTextSpan) {
    try {
      if (!mounted) return; // Early exit if the widget is no longer in the tree
      setState(() {
        textSpan = newTextSpan;
      });
    } catch (error, stackTrace) {
      ErrorHandler.logError(
        e: PangeaWarningError(error),
        s: stackTrace,
        m: "Error setting text span in PangeaRichText",
        data: {
          "newTextSpan": newTextSpan,
        },
      );
    }
  }

  void setTextSpan() {
    if (_fetchingRepresentation) {
      _setTextSpan(
        widget.pangeaMessageEvent.event
            .getDisplayEvent(widget.pangeaMessageEvent.timeline)
            .body,
      );
      return;
    }

    if (widget.pangeaMessageEvent.eventId.contains("webdebug")) {
      debugger(when: kDebugMode);
    }

    repEvent = widget.pangeaMessageEvent.messageDisplayRepresentation?.content;
    if (repEvent == null) {
      setState(() => _fetchingRepresentation = true);
      widget.pangeaMessageEvent
          .representationByLanguageGlobal(
        langCode: widget.pangeaMessageEvent.messageDisplayLangCode,
      )
          .onError((error, stackTrace) {
        ErrorHandler.logError(
          e: PangeaWarningError(error),
          s: stackTrace,
          m: "Error fetching representation",
          data: {
            "langCode": widget.pangeaMessageEvent.messageDisplayLangCode,
          },
        );
        return null;
      }).then((event) {
        if (!mounted) return;
        repEvent = event;
        _setTextSpan(repEvent?.text ?? widget.pangeaMessageEvent.body);
      }).whenComplete(() {
        if (mounted) {
          setState(() => _fetchingRepresentation = false);
        }
      });

      _setTextSpan(widget.pangeaMessageEvent.body);
    } else {
      _setTextSpan(repEvent!.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (blur > 0) {
      instructionsShowPopup(
        context,
        InstructionsEnum.blurMeansTranslate,
        widget.pangeaMessageEvent.eventId,
      );
    }

    //TODO - take out of build function of every message
    final Widget richText = ToolbarSelectionArea(
      event: widget.pangeaMessageEvent.event,
      isOverlay: widget.isOverlay,
      pangeaMessageEvent: widget.pangeaMessageEvent,
      controller: widget.controller,
      nextEvent: widget.nextEvent,
      prevEvent: widget.prevEvent,
      child: RichText(
        text: TextSpan(
          text: textSpan,
          style: widget.style,
          children: [
            if (_fetchingRepresentation)
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
      ),
    );

    return blur > 0
        ? ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blur,
              sigmaY: blur,
            ),
            child: richText,
          )
        : richText;
  }

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
