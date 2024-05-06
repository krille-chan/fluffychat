import 'dart:developer';
import 'dart:ui';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/representation_content_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/instructions.dart';
import 'package:fluffychat/pangea/widgets/chat/message_context_menu.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../enum/message_mode_enum.dart';
import '../../models/pangea_match_model.dart';

class PangeaRichText extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final bool immersionMode;
  final ToolbarDisplayController? toolbarController;
  final TextStyle? style;

  const PangeaRichText({
    super.key,
    required this.pangeaMessageEvent,
    required this.immersionMode,
    required this.toolbarController,
    this.style,
  });

  @override
  PangeaRichTextState createState() => PangeaRichTextState();
}

class PangeaRichTextState extends State<PangeaRichText> {
  final PangeaController pangeaController = MatrixState.pangeaController;
  bool _fetchingRepresentation = false;
  double get blur => _fetchingRepresentation && widget.immersionMode ? 5 : 0;
  String textSpan = "";
  PangeaRepresentation? repEvent;

  @override
  void initState() {
    super.initState();
    updateTextSpan();
  }

  void updateTextSpan() {
    setState(() {
      textSpan = getTextSpan();
    });
  }

  @override
  void didUpdateWidget(PangeaRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateTextSpan();
  }

  String getTextSpan() {
    if (_fetchingRepresentation == true) {
      return widget.pangeaMessageEvent.body;
    }

    if (repEvent != null) {
      return repEvent!.text;
    }

    if (widget.pangeaMessageEvent.eventId.contains("webdebug")) {
      debugger(when: kDebugMode);
    }

    repEvent = widget.pangeaMessageEvent
        .representationByLanguage(
          widget.pangeaMessageEvent.messageDisplayLangCode,
        )
        ?.content;

    if (repEvent == null) {
      setState(() => _fetchingRepresentation = true);

      widget.pangeaMessageEvent
          .representationByLanguageGlobal(
            context: context,
            langCode: widget.pangeaMessageEvent.messageDisplayLangCode,
          )
          .onError(
            (error, stackTrace) =>
                ErrorHandler.logError(e: error, s: stackTrace),
          )
          .then((event) {
        repEvent = event;
        widget.toolbarController?.toolbar?.textSelection.setMessageText(
          repEvent?.text ?? widget.pangeaMessageEvent.body,
        );
      }).whenComplete(() {
        if (mounted) {
          setState(() => _fetchingRepresentation = false);
        }
      });
      return widget.pangeaMessageEvent.body;
    } else {
      widget.toolbarController?.toolbar?.textSelection.setMessageText(
        repEvent!.text,
      );
      setState(() {});
    }

    return repEvent!.text;
  }

  @override
  Widget build(BuildContext context) {
    if (blur > 0) {
      pangeaController.instructions.show(
        context,
        InstructionsEnum.blurMeansTranslate,
        widget.pangeaMessageEvent.eventId,
      );
    } else {
      pangeaController.instructions.show(
        context,
        InstructionsEnum.clickMessage,
        widget.pangeaMessageEvent.eventId,
        true,
      );
    }

    //TODO - take out of build function of every message
    final Widget richText = SelectableText.rich(
      onSelectionChanged: (selection, cause) {
        if (cause == SelectionChangedCause.longPress &&
            !(widget.toolbarController?.highlighted ?? false) &&
            !(widget.toolbarController?.controller.selectedEvents.any(
                  (e) => e.eventId == widget.pangeaMessageEvent.eventId,
                ) ??
                false)) {
          widget.toolbarController?.controller.onSelectMessage(
            widget.pangeaMessageEvent.event,
          );
          return;
        }
        widget.toolbarController?.toolbar?.textSelection
            .onTextSelection(selection);
      },
      onTap: () => widget.toolbarController?.showToolbar(context),
      enableInteractiveSelection:
          widget.toolbarController?.highlighted ?? false,
      contextMenuBuilder: (context, state) =>
          widget.toolbarController?.highlighted ?? true
              ? const SizedBox.shrink()
              : MessageContextMenu.contextMenuOverride(
                  context: context,
                  textSelection: state,
                  onDefine: () => widget.toolbarController?.showToolbar(
                    context,
                    mode: MessageMode.definition,
                  ),
                  onListen: () => widget.toolbarController?.showToolbar(
                    context,
                    mode: MessageMode.textToSpeech,
                  ),
                ),
      TextSpan(
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
    );

    return blur > 0
        ? ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: richText,
          )
        : richText;
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
