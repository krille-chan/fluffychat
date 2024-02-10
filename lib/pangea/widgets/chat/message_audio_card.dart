import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
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

  void fetchAudio() {
    if (!mounted) return;
    setState(() => _isLoading = true);
    widget.messageEvent
        .getAudioGlobal(widget.messageEvent.messageDisplayLangCode)
        .then((Event? event) {
      localAudioEvent = event;
    }).catchError((e) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.errorGettingAudio),
        ),
      );
      return null;
    }).whenComplete(() {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAudio();
  }

  @override
  void dispose() {
    super.dispose();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final playButton = InkWell(
      borderRadius: BorderRadius.circular(64),
      onTap: fetchAudio,
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
          : localAudioEvent != null
              ? Container(
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
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: playButton,
                ),
    );
  }
}
