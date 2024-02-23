import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/igc/card_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

class MessageAudioCard extends StatefulWidget {
  final PangeaMessageEvent messageEvent;

  const MessageAudioCard({
    super.key,
    required this.messageEvent,
  });

  @override
  MessageAudioCardState createState() => MessageAudioCardState();
}

class MessageAudioCardState extends State<MessageAudioCard> {
  bool _isLoading = false;
  Event? localAudioEvent;
  PangeaAudioFile? audioFile;

  Future<void> fetchAudio() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final String langCode = widget.messageEvent.messageDisplayLangCode;
      final String? text =
          widget.messageEvent.representationByLanguage(langCode)?.text;
      if (text != null) {
        final Event? localEvent =
            widget.messageEvent.getAudioLocal(langCode, text);
        if (localEvent != null) {
          localAudioEvent = localEvent;
          if (mounted) setState(() => _isLoading = false);
          return;
        }
      }

      audioFile =
          await widget.messageEvent.getMatrixAudioFile(langCode, context);
      if (mounted) setState(() => _isLoading = false);
    } catch (e, _) {
      debugPrint(StackTrace.current.toString());
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.errorGettingAudio),
        ),
      );
      ErrorHandler.logError(
        e: Exception(),
        s: StackTrace.current,
        m: 'something wrong getting audio in MessageAudioCardState',
        data: {
          'widget.messageEvent.messageDisplayLangCode':
              widget.messageEvent.messageDisplayLangCode,
        },
      );
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    fetchAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: _isLoading
          ? SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : localAudioEvent != null || audioFile != null
              ? Container(
                  constraints: const BoxConstraints(
                    maxWidth: 250,
                  ),
                  child: Column(
                    children: [
                      AudioPlayerWidget(
                        localAudioEvent,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        matrixFile: audioFile,
                        autoplay: true,
                      ),
                    ],
                  ),
                )
              : const CardErrorWidget(),
    );
  }
}

class PangeaAudioFile extends MatrixAudioFile {
  List<int>? waveform;

  PangeaAudioFile({
    required super.bytes,
    required super.name,
    super.mimeType,
    super.duration,
    this.waveform,
  });
}
