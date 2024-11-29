import 'dart:developer';
import 'dart:math';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pangea/controllers/text_to_speech_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/chat/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/widgets/chat/tts_controller.dart';
import 'package:fluffychat/pangea/widgets/igc/card_error_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class MessageAudioCard extends StatefulWidget {
  final PangeaMessageEvent messageEvent;
  final MessageOverlayController overlayController;
  final PangeaTokenText? selection;
  final TtsController tts;
  final Function(bool) setIsPlayingAudio;
  final VoidCallback? onError;

  const MessageAudioCard({
    super.key,
    required this.messageEvent,
    required this.overlayController,
    required this.tts,
    required this.setIsPlayingAudio,
    this.selection,
    this.onError,
  });

  @override
  MessageAudioCardState createState() => MessageAudioCardState();
}

class MessageAudioCardState extends State<MessageAudioCard> {
  bool _isLoading = false;
  PangeaAudioFile? audioFile;

  int? sectionStartMS;
  int? sectionEndMS;

  @override
  void initState() {
    super.initState();
    fetchAudio();

    // initializeTTS();
  }

  // initializeTTS() async {
  //   tts.setupTTS().then((value) => setState(() {}));
  // }

  @override
  void didUpdateWidget(covariant oldWidget) {
    // if (oldWidget.selection != widget.selection && widget.selection != null) {
    //   debugPrint('selection changed');
    //   setSectionStartAndEndFromSelection();
    //   playSelectionAudio();
    // }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> playSelectionAudio() async {
    if (widget.selection == null) return;
    final PangeaTokenText selection = widget.selection!;
    final tokenText = selection.content;

    await widget.tts.tryToSpeak(
      tokenText,
      context,
      widget.messageEvent.eventId,
    );
  }

  void setSectionStartAndEnd(int? start, int? end) => mounted
      ? setState(() {
          sectionStartMS = start;
          sectionEndMS = end;
        })
      : null;

  void setSectionStartAndEndFromSelection() async {
    if (audioFile == null) {
      // should never happen but just in case
      debugger(when: kDebugMode);
      return;
    }

    if (audioFile!.duration == null) {
      // should never happen but just in case
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: 'audioFile duration is null in MessageAudioCardState',
        data: {
          'audioFile': audioFile,
        },
      );
      return setSectionStartAndEnd(null, null);
    }

    // if there is no selection, we don't need to do anything
    // but clear the section start and end
    if (widget.selection == null) {
      return setSectionStartAndEnd(null, null);
    }

    final PangeaTokenText selection = widget.selection!;
    final List<TTSToken> tokens = audioFile!.tokens;

    // find the token that corresponds to the selection
    // set the start to the start of the token
    // set the end to the start of the next token or to the duration of the audio if
    // if there is no next token
    for (int i = 0; i < tokens.length; i++) {
      final TTSToken ttsToken = tokens[i];
      if (ttsToken.text.offset == selection.offset) {
        return setSectionStartAndEnd(
          max(ttsToken.startMS - 150, 0),
          min(ttsToken.endMS + 150, audioFile!.duration!),
        );
      }
    }

    // if we didn't find the token, we should pause if debug and log an error
    debugger(when: kDebugMode);
    ErrorHandler.logError(
      e: 'could not find token for selection in MessageAudioCardState',
      data: {
        'selection': selection,
        'tokens': tokens,
        'sttTokens': audioFile!.tokens,
      },
    );

    setSectionStartAndEnd(null, null);
  }

  Future<void> fetchAudio() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final String langCode = widget.messageEvent.messageDisplayLangCode;
      final Event? localEvent = widget.messageEvent.getTextToSpeechLocal(
        langCode,
        widget.messageEvent.messageDisplayText,
      );

      if (localEvent != null) {
        audioFile = await localEvent.getPangeaAudioFile();
      } else {
        audioFile = await widget.messageEvent.getMatrixAudioFile(
          langCode,
        );
      }
      debugPrint("audio file is now: $audioFile. setting starts and ends...");
      setSectionStartAndEndFromSelection();
      if (mounted) setState(() => _isLoading = false);
    } catch (e, s) {
      widget.onError?.call();
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        m: 'something wrong getting audio in MessageAudioCardState',
        data: {
          'widget.messageEvent.messageDisplayLangCode':
              widget.messageEvent.messageDisplayLangCode,
        },
      );
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: _isLoading
              ? const ToolbarContentLoadingIndicator()
              : audioFile != null
                  ? AudioPlayerWidget(
                      null,
                      matrixFile: audioFile,
                      sectionStartMS: sectionStartMS,
                      sectionEndMS: sectionEndMS,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      setIsPlayingAudio: widget.setIsPlayingAudio,
                    )
                  : const CardErrorWidget(
                      error: "Null audio file in message_audio_card",
                      maxWidth: AppConfig.toolbarMinWidth,
                    ),
        ),
      ],
    );
  }
}

class PangeaAudioFile extends MatrixAudioFile {
  List<int>? waveform;
  List<TTSToken> tokens;

  PangeaAudioFile({
    required super.bytes,
    required super.name,
    super.mimeType,
    super.duration,
    this.waveform,
    required this.tokens,
  });
}
