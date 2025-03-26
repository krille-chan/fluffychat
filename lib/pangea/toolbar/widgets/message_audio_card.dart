import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pangea/analytics_misc/text_loading_shimmer.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/card_error_widget.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/toolbar/controllers/text_to_speech_controller.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class MessageAudioCard extends StatefulWidget {
  final PangeaMessageEvent messageEvent;
  final MessageOverlayController overlayController;
  final Function(bool) setIsPlayingAudio;
  final VoidCallback? onError;

  const MessageAudioCard({
    super.key,
    required this.messageEvent,
    required this.overlayController,
    required this.setIsPlayingAudio,
    this.onError,
  });

  @override
  MessageAudioCardState createState() => MessageAudioCardState();
}

class MessageAudioCardState extends State<MessageAudioCard> {
  bool _isLoading = false;
  PangeaAudioFile? audioFile;

  @override
  void initState() {
    super.initState();
    fetchAudio();
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
          alignment: Alignment.center,
          height: 40,
          child: _isLoading
              ? const TextLoadingShimmer(width: 200)
              : audioFile != null
                  ? AudioPlayerWidget(
                      null,
                      matrixFile: audioFile,
                      sectionStartMS: null,
                      sectionEndMS: null,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      setIsPlayingAudio: widget.setIsPlayingAudio,
                      fontSize:
                          AppConfig.messageFontSize * AppConfig.fontSizeFactor,
                      padding: 0,
                      isOverlay: true,
                      chatController:
                          widget.overlayController.widget.chatController,
                      overlayController: widget.overlayController,
                      linkColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onPrimary,
                    )
                  : const CardErrorWidget(
                      error: "Null audio file in message_audio_card",
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
