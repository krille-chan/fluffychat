import 'dart:async';
import 'dart:typed_data';

import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/message_download_content.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../../utils/ui_fake.dart' if (dart.library.html) 'dart:ui' as ui;
import 'matrix.dart';
import '../../utils/event_extension.dart';

class AudioPlayer extends StatefulWidget {
  final Color color;
  final Event event;

  static String currentId;

  const AudioPlayer(this.event, {this.color = Colors.black, Key key})
      : super(key: key);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

enum AudioPlayerStatus { notDownloaded, downloading, downloaded }

class _AudioPlayerState extends State<AudioPlayer> {
  AudioPlayerStatus status = AudioPlayerStatus.notDownloaded;

  final FlutterSoundPlayer flutterSound = FlutterSoundPlayer();

  StreamSubscription soundSubscription;
  Uint8List audioFile;

  String statusText = '00:00';
  double currentPosition = 0;
  double maxPosition = 0;

  String webSrcUrl;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      ui.platformViewRegistry.registerViewFactory(
          'web_audio_player',
          (int viewId) => html.AudioElement()
            ..src = webSrcUrl
            ..autoplay = false
            ..controls = true
            ..style.border = 'none');
    }
  }

  @override
  void dispose() {
    if (flutterSound.isPlaying) {
      flutterSound.stopPlayer();
    }
    if (flutterSound.isOpen()) {
      flutterSound.closeAudioSession();
    }
    soundSubscription?.cancel();
    super.dispose();
  }

  Future<void> _downloadAction() async {
    if (status != AudioPlayerStatus.notDownloaded) return;
    setState(() => status = AudioPlayerStatus.downloading);
    try {
      final matrixFile =
          await widget.event.downloadAndDecryptAttachmentCached();
      setState(() {
        audioFile = matrixFile.bytes;
        status = AudioPlayerStatus.downloaded;
      });
      _playAction();
    } catch (e, s) {
      Logs().v('Could not download audio file', e, s);
      AdaptivePageLayout.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toLocalizedString(context)),
        ),
      );
    }
  }

  void _playAction() async {
    if (AudioPlayer.currentId != widget.event.eventId) {
      if (AudioPlayer.currentId != null) {
        if (!flutterSound.isStopped) {
          await flutterSound.stopPlayer();
          setState(() => null);
        }
      }
      AudioPlayer.currentId = widget.event.eventId;
    }
    switch (flutterSound.playerState) {
      case PlayerState.isPlaying:
        await flutterSound.pausePlayer();
        break;
      case PlayerState.isPaused:
        await flutterSound.resumePlayer();
        break;
      case PlayerState.isStopped:
      default:
        if (!flutterSound.isOpen()) {
          await flutterSound.openAudioSession(
              focus: AudioFocus.requestFocusAndStopOthers,
              category: SessionCategory.playback);
        }

        await flutterSound.setSubscriptionDuration(Duration(milliseconds: 100));
        await flutterSound.startPlayer(fromDataBuffer: audioFile);
        soundSubscription ??= flutterSound.onProgress.listen((e) {
          if (AudioPlayer.currentId != widget.event.eventId) {
            soundSubscription?.cancel()?.then((f) => soundSubscription = null);
            setState(() {
              currentPosition = 0;
              statusText = '00:00';
            });
            AudioPlayer.currentId = null;
          } else if (e != null) {
            final txt =
                '${e.position.inMinutes.toString().padLeft(2, '0')}:${(e.position.inSeconds % 60).toString().padLeft(2, '0')}';
            setState(() {
              maxPosition = e.duration.inMilliseconds.toDouble();
              currentPosition = e.position.inMilliseconds.toDouble();
              statusText = txt;
            });
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      if (widget.event.content['url'] is String) {
        webSrcUrl = Uri.parse(widget.event.content['url'])
            .getDownloadLink(Matrix.of(context).client);
        return Container(
          height: 50,
          width: 300,
          child: HtmlElementView(viewType: 'web_audio_player'),
        );
      }
      return MessageDownloadContent(widget.event, widget.color);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 30,
          child: status == AudioPlayerStatus.downloading
              ? CircularProgressIndicator(strokeWidth: 2)
              : IconButton(
                  icon: Icon(
                    flutterSound.isPlaying
                        ? Icons.pause_outlined
                        : Icons.play_arrow_outlined,
                    color: widget.color,
                  ),
                  tooltip: flutterSound.isPlaying
                      ? L10n.of(context).audioPlayerPause
                      : L10n.of(context).audioPlayerPlay,
                  onPressed: () {
                    if (status == AudioPlayerStatus.downloaded) {
                      _playAction();
                    } else {
                      _downloadAction();
                    }
                  },
                ),
        ),
        Expanded(
          child: Slider(
            value: currentPosition,
            onChanged: (double position) => flutterSound
                .seekToPlayer(Duration(milliseconds: position.toInt())),
            max: status == AudioPlayerStatus.downloaded ? maxPosition : 0,
            min: 0,
          ),
        ),
        Text(
          statusText,
          style: TextStyle(
            color: widget.color,
          ),
        ),
      ],
    );
  }
}
