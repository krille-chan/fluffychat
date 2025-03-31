import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/card_error_widget.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/widgets/matrix.dart';

class MessageTranslationCard extends StatefulWidget {
  final PangeaMessageEvent messageEvent;

  const MessageTranslationCard({
    super.key,
    required this.messageEvent,
  });

  @override
  MessageTranslationCardState createState() => MessageTranslationCardState();
}

class MessageTranslationCardState extends State<MessageTranslationCard> {
  PangeaRepresentation? repEvent;
  bool _fetchingTranslation = false;

  @override
  void initState() {
    super.initState();
    loadTranslation();
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

  Future<void> loadTranslation() async {
    if (!mounted) return;

    setState(() => _fetchingTranslation = true);

    try {
      await fetchRepresentationText();
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

    return isWrittenInL1;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MessageTranslationCard build');
    if (!_fetchingTranslation && repEvent == null) {
      return const CardErrorWidget(
        error: "No translation found",
        maxWidth: AppConfig.toolbarMinWidth,
      );
    }

    final loadingTranslation = repEvent == null;

    if (_fetchingTranslation || loadingTranslation) {
      return const ToolbarContentLoadingIndicator();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          repEvent!.text,
          style: AppConfig.messageTextStyle(
            widget.messageEvent.event,
            Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        if (notGoingToTranslate)
          const InstructionsInlineTooltip(
            instructionsEnum: InstructionsEnum.l1Translation,
          ),
      ],
    );
  }
}
