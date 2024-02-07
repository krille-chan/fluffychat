import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_representation_event.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class MessageTranslationCard extends StatefulWidget {
  final PangeaMessageEvent messageEvent;
  final bool immersionMode;

  const MessageTranslationCard({
    super.key,
    required this.messageEvent,
    required this.immersionMode,
  });

  @override
  MessageTranslationCardState createState() => MessageTranslationCardState();
}

class MessageTranslationCardState extends State<MessageTranslationCard> {
  RepresentationEvent? repEvent;
  bool _fetchingRepresentation = false;

  String? translationLangCode() {
    final String? l1Code =
        MatrixState.pangeaController.languageController.activeL1Code(
      roomID: widget.messageEvent.room.id,
    );
    if (widget.immersionMode) return l1Code;

    final String? l2Code =
        MatrixState.pangeaController.languageController.activeL2Code(
      roomID: widget.messageEvent.room.id,
    );
    final String? originalWrittenCode =
        widget.messageEvent.originalWritten?.content.langCode;
    return l1Code == originalWrittenCode ? l2Code : l1Code;
  }

  void fetchRepresentation(BuildContext context) {
    final String? langCode = translationLangCode();
    if (langCode == null) return;

    repEvent = widget.messageEvent.representationByLanguage(
      langCode,
    );

    if (repEvent == null && mounted) {
      setState(() => _fetchingRepresentation = true);
      widget.messageEvent
          .representationByLanguageGlobal(
            context: context,
            langCode: langCode,
          )
          .onError(
            (error, stackTrace) => ErrorHandler.logError(
              e: error,
              s: stackTrace,
            ),
          )
          .then((RepresentationEvent? event) => repEvent = event)
          .whenComplete(
            () => setState(() => _fetchingRepresentation = false),
          );
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRepresentation(context);
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
