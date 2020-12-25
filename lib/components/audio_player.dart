import 'dart:async';
import 'dart:typed_data';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/message_download_content.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import '../utils/ui_fake.dart' if (dart.library.html) 'dart:ui' as ui;
import 'matrix.dart';
import '../utils/event_extension.dart';

class AudioPlayer extends StatefulWidget {
  final Color color;
  final Event event;

  static String currentId;

  const AudioPlayer(this.event, {this.color = Colors.black, Key key})
      : super(key: key);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

enum AudioPlayerStatus { NOT_DOWNLOADED, DOWNLOADING, DOWNLOADED }

class _AudioPlayerState extends State<AudioPlayer> {
  AudioPlayerStatus status = AudioPlayerStatus.NOT_DOWNLOADED;

  FlutterSound flutterSound = FlutterSound();

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
    if (flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING) {
      flutterSound.stopPlayer();
    }
    soundSubscription?.cancel();
    super.dispose();
  }

  Future<void> _downloadAction() async {
    if (status != AudioPlayerStatus.NOT_DOWNLOADED) return;
    setState(() => status = AudioPlayerStatus.DOWNLOADING);
    try {
      final matrixFile =
          await widget.event.downloadAndDecryptAttachmentCached();
      setState(() {
        audioFile = matrixFile.bytes;
        status = AudioPlayerStatus.DOWNLOADED;
      });
      _playAction();
    } catch (e, s) {
      Logs().v('Could not download audio file', e, s);
      await FlushbarHelper.createError(message: e.toLocalizedString(context))
          .show(context);
    }
  }

  void _playAction() async {
    if (AudioPlayer.currentId != widget.event.eventId) {
      if (AudioPlayer.currentId != null) {
        if (flutterSound.audioState != t_AUDIO_STATE.IS_STOPPED) {
          await flutterSound.stopPlayer();
          setState(() => null);
        }
      }
      AudioPlayer.currentId = widget.event.eventId;
    }
    switch (flutterSound.audioState) {
      case t_AUDIO_STATE.IS_PLAYING:
        await flutterSound.pausePlayer();
        break;
      case t_AUDIO_STATE.IS_PAUSED:
        await flutterSound.resumePlayer();
        break;
      case t_AUDIO_STATE.IS_RECORDING:
        break;
      case t_AUDIO_STATE.IS_STOPPED:
        await flutterSound.startPlayerFromBuffer(
          audioFile,
          codec: t_CODEC.CODEC_AAC,
        );
        soundSubscription ??= flutterSound.onPlayerStateChanged.listen((e) {
          if (AudioPlayer.currentId != widget.event.eventId) {
            soundSubscription?.cancel()?.then((f) => soundSubscription = null);
            setState(() {
              currentPosition = 0;
              statusText = '00:00';
            });
            AudioPlayer.currentId = null;
          } else if (e != null) {
            var date =
                DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
            var txt = DateFormat('mm:ss', 'en_US').format(date);
            setState(() {
              maxPosition = e.duration;
              currentPosition = e.currentPosition;
              statusText = txt;
            });
            if (e.duration == e.currentPosition) {
              soundSubscription
                  ?.cancel()
                  ?.then((f) => soundSubscription = null);
            }
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
          child: status == AudioPlayerStatus.DOWNLOADING
              ? CircularProgressIndicator(strokeWidth: 2)
              : IconButton(
                  icon: Icon(
                    flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: widget.color,
                  ),
                  onPressed: () {
                    if (status == AudioPlayerStatus.DOWNLOADED) {
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
            onChanged: (double position) =>
                flutterSound.seekToPlayer(position.toInt()),
            max: status == AudioPlayerStatus.DOWNLOADED ? maxPosition : 0,
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
