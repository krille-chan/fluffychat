import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_representation_event.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
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
  // RepresentationEvent? repEvent;
  bool _isLoading = false;
  Event? localAudioEvent;
  // String langCode = "en";

  // void setLangCode() {
  //   final String? l2Code =
  //       MatrixState.pangeaController.languageController.activeL2Code(
  //     roomID: widget.messageEvent.room.id,
  //   );
  //   setState(() => langCode = l2Code ?? "en");
  // }

  // void fetchRepresentation(BuildContext context) {
  //   repEvent = widget.messageEvent.representationByLanguage(
  //     langCode,
  //   );

  //   if (repEvent == null) {
  //     setState(() => _isLoading = true);
  //     widget.messageEvent
  //         .representationByLanguageGlobal(
  //           context: context,
  //           langCode: langCode,
  //         )
  //         .onError((error, stackTrace) => ErrorHandler.logError())
  //         .then(((RepresentationEvent? event) => repEvent = event))
  //         .whenComplete(
  //           () => setState(() => _isLoading = false),
  //         );
  //   }
  // }

  void fetchAudio() {
    if (!mounted) return;
    // final String? text = widget.messageEvent.displayMessageText;
    // if (text == null || text.isEmpty) return;
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
    widget.messageEvent
        .getDisplayRepresentation(context)
        .then((_) => fetchAudio());
  }

  @override
  Widget build(BuildContext context) {
    final playButton = InkWell(
      borderRadius: BorderRadius.circular(64),
      onTap: () => widget.messageEvent
          .getDisplayRepresentation(context)
          .then((event) => event == null ? null : fetchAudio),
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
              :
              // Opacity(
              //     opacity: widget.messageEvent.getDisplayRepresentation().then((event) => event == null ? ) == null
              //         ? 0.5
              //         : 1,
              //     // child: SizedBox(
              //     //   width: 44,
              //     //   height: 36,
              //     child:
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: playButton,
                ),
      // ),
      // ),
    );
  }
}
