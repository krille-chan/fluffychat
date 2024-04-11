import 'dart:developer';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:just_audio/just_audio.dart';
import 'package:matrix/matrix.dart';

class TextToSpeechButton extends StatefulWidget {
  final ChatController controller;
  final Event selectedEvent;

  const TextToSpeechButton({
    super.key,
    required this.controller,
    required this.selectedEvent,
  });

  @override
  _TextToSpeechButtonState createState() => _TextToSpeechButtonState();
}

class _TextToSpeechButtonState extends State<TextToSpeechButton> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late PangeaMessageEvent _pangeaMessageEvent;
  bool _isLoading = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pangeaMessageEvent = PangeaMessageEvent(
      event: widget.selectedEvent,
      timeline: widget.controller.timeline!,
      ownMessage:
          widget.selectedEvent.senderId == Matrix.of(context).client.userID,
    );
  }

  Event? get localAudioEvent =>
      langCode != null && text != null && text!.isNotEmpty
          ? _pangeaMessageEvent.getTextToSpeechLocal(langCode!, text!)
          : null;

  String? get langCode =>
      widget.controller.choreographer.messageOptions.selectedDisplayLang
          ?.langCode ??
      widget.controller.choreographer.l2LangCode;

  String? get text => langCode != null
      ? _pangeaMessageEvent.representationByLanguage(langCode!)?.text
      : null;

  Future<void> _getAudio() async {
    try {
      if (!mounted) return;
      if (text == null || text!.isEmpty) return;
      if (langCode == null || langCode!.isEmpty) return;

      setState(() => _isLoading = true);
      await _pangeaMessageEvent.getTextToSpeechGlobal(langCode!);
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      debugger(when: kDebugMode);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.errorGettingAudio),
        ),
      );
      ErrorHandler.logError(
        e: Exception(),
        s: StackTrace.current,
        m: 'text is null or empty in text_to_speech_button.dart',
        data: {'selectedEvent': widget.selectedEvent, 'langCode': langCode},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final playButton = InkWell(
      borderRadius: BorderRadius.circular(64),
      onTap: text == null || text!.isEmpty ? null : _getAudio,
      child: Material(
        color: AppConfig.primaryColor.withAlpha(64),
        borderRadius: BorderRadius.circular(64),
        child: const Icon(
          // Change the icon based on some condition. If you have an audio player state, use it here.
          Icons.play_arrow_outlined,
          color: AppConfig.primaryColor,
        ),
      ),
    );

    return localAudioEvent == null
        ? Opacity(
            opacity: text == null || text!.isEmpty ? 0.5 : 1,
            child: SizedBox(
              width: 44, // Match the size of the button in AudioPlayerState
              height: 36,
              child: Padding(
                //only left side of the button is padded to match the padding of the AudioPlayerState
                padding: const EdgeInsets.only(left: 8),
                child: playButton,
              ),
            ),
          )
        : Container(
            constraints: const BoxConstraints(
              maxWidth: 250,
            ),
            child: Column(
              children: [
                AudioPlayerWidget(
                  localAudioEvent!,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ],
            ),
          );
  }
}
