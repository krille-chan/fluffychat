import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pangea/analytics_misc/text_loading_shimmer.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/toolbar/controllers/text_to_speech_controller.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class MessageAudioCard extends StatefulWidget {
  final MessageOverlayController overlayController;
  final VoidCallback? onError;

  const MessageAudioCard({
    super.key,
    required this.overlayController,
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

  PangeaMessageEvent get messageEvent =>
      widget.overlayController.pangeaMessageEvent;

  Future<void> fetchAudio() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final String langCode = messageEvent.messageDisplayLangCode;
      final Event? localEvent = messageEvent.getTextToSpeechLocal(
        langCode,
        messageEvent.messageDisplayText,
      );

      if (localEvent != null) {
        audioFile = await localEvent.getPangeaAudioFile();
      } else {
        audioFile = await messageEvent.getMatrixAudioFile(
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
              messageEvent.messageDisplayLangCode,
        },
      );
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const TextLoadingShimmer(width: 200)
        : audioFile != null
            ? AudioPlayerWidget(
                null,
                eventId: "${messageEvent.eventId}_practice",
                roomId: messageEvent.room.id,
                senderId: messageEvent.senderId,
                matrixFile: audioFile,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: AppConfig.messageFontSize * AppConfig.fontSizeFactor,
                chatController: widget.overlayController.widget.chatController,
                overlayController: widget.overlayController,
                linkColor: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary,
              )
            : const SizedBox();
  }
}

class PangeaAudioFile extends MatrixAudioFile {
  List<int>? waveform;
  List<TTSToken>? tokens;

  PangeaAudioFile({
    required super.bytes,
    required super.name,
    super.mimeType,
    super.duration,
    this.waveform,
    required this.tokens,
  });
}
