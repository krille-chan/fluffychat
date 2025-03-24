import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class LemmaWidget extends StatefulWidget {
  final PangeaToken token;
  final PangeaMessageEvent pangeaMessageEvent;
  final VoidCallback onEdit;
  final VoidCallback onEditDone;
  final TtsController tts;
  final MessageOverlayController? overlayController;

  const LemmaWidget({
    super.key,
    required this.token,
    required this.pangeaMessageEvent,
    required this.onEdit,
    required this.onEditDone,
    required this.tts,
    required this.overlayController,
  });

  @override
  LemmaWidgetState createState() => LemmaWidgetState();
}

class LemmaWidgetState extends State<LemmaWidget> {
  bool _editMode = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEditMode(bool value) {
    value ? widget.onEdit() : widget.onEditDone();
    setState(() => _editMode = value);
  }

  Future<void> _editLemma() async {
    try {
      final existingTokens = widget.pangeaMessageEvent.originalSent!.tokens!
          .map((token) => PangeaToken.fromJson(token.toJson()))
          .toList();

      // change the morphological tag in the selected token
      final tokenIndex = existingTokens.indexWhere(
        (token) => token.text.offset == widget.token.text.offset,
      );

      if (tokenIndex == -1) {
        throw Exception("Token not found in message");
      }

      existingTokens[tokenIndex].lemma.text = _controller.text;
      await widget.pangeaMessageEvent.room.pangeaSendTextEvent(
        widget.pangeaMessageEvent.messageDisplayText,
        editEventId: widget.pangeaMessageEvent.eventId,
        originalSent: widget.pangeaMessageEvent.originalSent?.content,
        originalWritten: widget.pangeaMessageEvent.originalWritten?.content,
        tokensSent: PangeaMessageTokens(
          tokens: existingTokens,
          detections: widget.pangeaMessageEvent.originalSent!.detections,
        ),
        tokensWritten: widget.pangeaMessageEvent.originalWritten?.tokens != null
            ? PangeaMessageTokens(
                tokens: widget.pangeaMessageEvent.originalWritten!.tokens!,
                detections:
                    widget.pangeaMessageEvent.originalWritten?.detections,
              )
            : null,
        choreo: widget.pangeaMessageEvent.originalSent?.choreo,
        messageTag: ModelKey.messageTagLemmaEdit,
      );

      _toggleEditMode(false);
    } catch (e) {
      SnackBar(
        content: Text(L10n.of(context).oopsSomethingWentWrong),
      );
      ErrorHandler.logError(
        e: e,
        data: {
          "token": widget.token.toJson(),
          "pangeaMessageEvent": widget.pangeaMessageEvent.event.content,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_editMode) {
      _controller.text = widget.token.lemma.text;
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 10.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${L10n.of(context).pangeaBotIsFallible} ${L10n.of(context).whatIsLemma}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            TextField(
              minLines: 1,
              maxLines: 3,
              controller: _controller,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _toggleEditMode(false),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: Text(L10n.of(context).cancel),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _controller.text != widget.token.lemma.text
                        ? showFutureLoadingDialog(
                            context: context,
                            future: () async => _editLemma(),
                          )
                        : null;
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: Text(L10n.of(context).saveChanges),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: L10n.of(context).doubleClickToEdit,
          child: GestureDetector(
            onLongPress: () => _toggleEditMode(true),
            onDoubleTap: () => _toggleEditMode(true),
            child: Text(
              widget.token.lemma.text,
              style: Theme.of(context).textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (widget.token.lemma.text.toLowerCase() ==
            widget.token.text.content.toLowerCase())
          WordAudioButton(
            text: widget.token.text.content,
            isSelected:
                MessageMode.listening == widget.overlayController?.toolbarMode,
            baseOpacity: 0.4,
            callbackOverride:
                widget.overlayController?.messageAnalyticsEntry?.hasActivity(
                          MessageMode.listening.associatedActivityType!,
                          widget.token,
                        ) ==
                        true
                    ? () => widget.overlayController
                        ?.updateToolbarMode(MessageMode.listening)
                    : null,
          ),
      ],
    );
  }
}
