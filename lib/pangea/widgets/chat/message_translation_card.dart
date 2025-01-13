import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/models/representation_content_model.dart';
import 'package:fluffychat/pangea/repo/full_text_translation_repo.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/widgets/igc/card_error_widget.dart';
import 'package:fluffychat/widgets/matrix.dart';

class MessageTranslationCard extends StatefulWidget {
  final PangeaMessageEvent messageEvent;
  final PangeaTokenText? selection;

  const MessageTranslationCard({
    super.key,
    required this.messageEvent,
    required this.selection,
  });

  @override
  MessageTranslationCardState createState() => MessageTranslationCardState();
}

class MessageTranslationCardState extends State<MessageTranslationCard> {
  PangeaRepresentation? repEvent;
  String? selectionTranslation;
  bool _fetchingTranslation = false;

  @override
  void initState() {
    debugPrint('MessageTranslationCard initState');
    super.initState();
    loadTranslation();
  }

  @override
  void didUpdateWidget(covariant MessageTranslationCard oldWidget) {
    if (oldWidget.selection != widget.selection) {
      debugPrint('selection changed');
      loadTranslation();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> fetchRepresentationText() async {
    if (l1Code == null) return;

    repEvent = widget.messageEvent
        .representationByLanguage(
          l1Code!,
        )
        ?.content;

    if (repEvent == null && mounted) {
      repEvent = await widget.messageEvent.representationByLanguageGlobal(
        langCode: l1Code!,
      );
    }
  }

  Future<void> fetchSelectedTextTranslation() async {
    if (!mounted) return;

    final pangeaController = MatrixState.pangeaController;

    if (!pangeaController.languageController.languagesSet) {
      selectionTranslation = widget.messageEvent.messageDisplayText;
      return;
    }

    final FullTextTranslationResponseModel res =
        await FullTextTranslationRepo.translate(
      accessToken: pangeaController.userController.accessToken,
      request: FullTextTranslationRequestModel(
        text: widget.messageEvent.messageDisplayText,
        srcLang: widget.messageEvent.messageDisplayLangCode,
        tgtLang: l1Code!,
        offset: widget.selection?.offset,
        length: widget.selection?.length,
        userL1: l1Code!,
        userL2: l2Code!,
      ),
    );

    selectionTranslation = res.translations.first;
  }

  Future<void> loadTranslation() async {
    if (!mounted) return;

    setState(() => _fetchingTranslation = true);

    try {
      await (widget.selection != null
          ? fetchSelectedTextTranslation()
          : fetchRepresentationText());
    } catch (err) {
      ErrorHandler.logError(
        e: err,
        data: {},
      );
    }

    if (mounted) {
      setState(() => _fetchingTranslation = false);
    }
  }

  String? get l1Code =>
      MatrixState.pangeaController.languageController.activeL1Code();
  String? get l2Code =>
      MatrixState.pangeaController.languageController.activeL2Code();

  /// Show warning if message's language code is user's L1
  /// or if translated text is same as original text.
  /// Warning does not show if was previously closed
  bool get notGoingToTranslate {
    final bool isWrittenInL1 =
        l1Code != null && widget.messageEvent.originalSent?.langCode == l1Code;
    final bool isTextIdentical = selectionTranslation != null &&
        widget.messageEvent.originalSent?.text == selectionTranslation;

    return (isWrittenInL1 || isTextIdentical);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MessageTranslationCard build');
    if (!_fetchingTranslation &&
        repEvent == null &&
        selectionTranslation == null) {
      return const CardErrorWidget(
        error: "No translation found",
        maxWidth: AppConfig.toolbarMinWidth,
      );
    }

    final loadingTranslation =
        (widget.selection != null && selectionTranslation == null) ||
            (widget.selection == null && repEvent == null);

    if (_fetchingTranslation || loadingTranslation) {
      return const ToolbarContentLoadingIndicator();
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppConfig.toolbarMinWidth,
        maxHeight: AppConfig.toolbarMaxHeight,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.selection != null
                    ? selectionTranslation!
                    : repEvent!.text,
                style: AppConfig.messageTextStyle(
                  widget.messageEvent.event,
                  Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              if (notGoingToTranslate &&
                  widget.selection == null &&
                  !InstructionsEnum.l1Translation.isToggledOff)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InstructionsInlineTooltip(
                        instructionsEnum: InstructionsEnum.l1Translation,
                      ),
                    ),
                  ],
                ),
              if (widget.selection != null &&
                  !InstructionsEnum.clickAgainToDeselect.isToggledOff)
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InstructionsInlineTooltip(
                        instructionsEnum: InstructionsEnum.clickAgainToDeselect,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
