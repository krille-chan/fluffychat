import 'dart:ui';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_representation_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/message_context_menu.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import '../../models/pangea_match_model.dart';

class PangeaRichText extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final bool immersionMode;
  final ToolbarDisplayController toolbarController;
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
  RepresentationEvent? repEvent;
  bool _fetchingRepresentation = false;
  double get blur => _fetchingRepresentation && widget.immersionMode ? 5 : 0;

  @override
  void initState() {
    super.initState();
    setTextSpan();
  }

  Future<void> setTextSpan() async {
    setState(() => _fetchingRepresentation = true);
    try {
      await widget.pangeaMessageEvent.getDisplayRepresentation(context);
    } catch (err) {
      ErrorHandler.logError(e: err);
    }
    setState(() => _fetchingRepresentation = false);

    widget.toolbarController.toolbar?.textSelection.setMessageText(
      widget.pangeaMessageEvent.displayMessageText,
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO - take out of build function of every message
    final Widget richText = SelectableText.rich(
      onSelectionChanged: (selection, cause) => widget
          .toolbarController.toolbar?.textSelection
          .onTextSelection(selection),
      onTap: () => widget.toolbarController.showToolbar(context),
      focusNode: widget.toolbarController.focusNode,
      contextMenuBuilder: (context, state) =>
          MessageContextMenu.contextMenuOverride(
        context: context,
        textSelection: state,
        onDefine: () => widget.toolbarController.showToolbar(
          context,
          mode: MessageMode.definition,
        ),
        onListen: () => widget.toolbarController.showToolbar(
          context,
          mode: MessageMode.play,
        ),
      ),
      TextSpan(
        text: widget.pangeaMessageEvent.displayMessageText,
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
