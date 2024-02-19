import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_representation_event.dart';
import 'package:fluffychat/pangea/repo/full_text_translation_repo.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/message_text_selection.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class MessageTranslationCard extends StatefulWidget {
  final PangeaMessageEvent messageEvent;
  final bool immersionMode;
  final MessageTextSelection selection;

  const MessageTranslationCard({
    super.key,
    required this.messageEvent,
    required this.immersionMode,
    required this.selection,
  });

  @override
  MessageTranslationCardState createState() => MessageTranslationCardState();
}

class MessageTranslationCardState extends State<MessageTranslationCard> {
  RepresentationEvent? repEvent;
  String? selectionTranslation;
  String? oldSelectedText;
  String? l1Code;
  String? l2Code;
  bool _fetchingRepresentation = false;

  String? translationLangCode() {
    if (widget.immersionMode) return l1Code;
    final String? originalWrittenCode =
        widget.messageEvent.originalWritten?.content.langCode;
    return l1Code == originalWrittenCode ? l2Code : l1Code;
  }

  Future<void> fetchRepresentation(BuildContext context) async {
    final String? langCode = translationLangCode();
    if (langCode == null) return;

    repEvent = widget.messageEvent.representationByLanguage(
      langCode,
    );

    if (repEvent == null && mounted) {
      repEvent = await widget.messageEvent.representationByLanguageGlobal(
        context: context,
        langCode: langCode,
      );
    }
  }

  Future<void> translateSelection() async {
    final String? targetLang = translationLangCode();

    if (widget.selection.selectedText == null ||
        targetLang == null ||
        l1Code == null ||
        l2Code == null) {
      selectionTranslation = null;
      return;
    }

    oldSelectedText = widget.selection.selectedText;
    final String accessToken =
        await MatrixState.pangeaController.userController.accessToken;

    final resp = await FullTextTranslationRepo.translate(
      accessToken: accessToken,
      request: FullTextTranslationRequestModel(
        text: widget.selection.selectedText!,
        tgtLang: translationLangCode()!,
        userL1: l1Code!,
        userL2: l2Code!,
        srcLang: widget.messageEvent.messageDisplayLangCode,
      ),
    );

    if (mounted) {
      selectionTranslation = resp.bestTranslation;
    }
  }

  Future<void> loadTranslation(Future<void> Function() future) async {
    if (!mounted) return;
    setState(() => _fetchingRepresentation = true);
    try {
      await future();
    } catch (err) {
      ErrorHandler.logError(e: err);
    }

    if (mounted) {
      setState(() => _fetchingRepresentation = false);
    }
  }

  @override
  void initState() {
    super.initState();
    l1Code = MatrixState.pangeaController.languageController.activeL1Code(
      roomID: widget.messageEvent.room.id,
    );
    l2Code = MatrixState.pangeaController.languageController.activeL2Code(
      roomID: widget.messageEvent.room.id,
    );
    setState(() {});

    loadTranslation(() async {
      if (widget.selection.selectedText != null) {
        await translateSelection();
      }
      await fetchRepresentation(context);
    });
  }

  @override
  void didUpdateWidget(covariant MessageTranslationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldSelectedText != widget.selection.selectedText) {
      loadTranslation(translateSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: _fetchingRepresentation
          ? SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : selectionTranslation != null
              ? Text(
                  selectionTranslation!,
                  style: BotStyle.text(context),
                )
              : repEvent != null
                  ? Text(
                      repEvent!.text,
                      style: BotStyle.text(context),
                    )
                  : Text(
                      L10n.of(context)!.oopsSomethingWentWrong,
                      style: BotStyle.text(context),
                    ),
    );
  }
}
