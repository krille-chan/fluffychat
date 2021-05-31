import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:fluffychat/widgets/event_content/message_download_content.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../../utils/matrix_sdk_extensions.dart/event_extension.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Color color;
  final Event event;

  static String currentId;

  const AudioPlayerWidget(this.event, {this.color = Colors.black, Key key})
      : super(key: key);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

enum AudioPlayerStatus { notDownloaded, downloading, downloaded }

class _AudioPlayerState extends State<AudioPlayerWidget> {
  AudioPlayerStatus status = AudioPlayerStatus.notDownloaded;
  final AudioPlayer audioPlayer = AudioPlayer();

  StreamSubscription onAudioPositionChanged;
  StreamSubscription onDurationChanged;
  StreamSubscription onPlayerStateChanged;
  StreamSubscription onPlayerError;

  String statusText = '00:00';
  double currentPosition = 0;
  double maxPosition = 0;

  File audioFile;

  @override
  void dispose() {
    if (audioPlayer.state == AudioPlayerState.PLAYING) {
      audioPlayer.stop();
    }
    onAudioPositionChanged?.cancel();
    onDurationChanged?.cancel();
    onPlayerStateChanged?.cancel();
    onPlayerError?.cancel();

    super.dispose();
  }

  Future<void> _downloadAction() async {
    if (status != AudioPlayerStatus.notDownloaded) return;
    setState(() => status = AudioPlayerStatus.downloading);
    try {
      final matrixFile =
          await widget.event.downloadAndDecryptAttachmentCached();
      final tempDir = await getTemporaryDirectory();
      final fileName = matrixFile.name.contains('.')
          ? matrixFile.name
          : '${matrixFile.name}.mp3';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(matrixFile.bytes);

      setState(() {
        audioFile = file;
        status = AudioPlayerStatus.downloaded;
      });
      _playAction();
    } catch (e, s) {
      Logs().v('Could not download audio file', e, s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toLocalizedString(context)),
        ),
      );
    }
  }

  void _playAction() async {
    if (AudioPlayerWidget.currentId != widget.event.eventId) {
      if (AudioPlayerWidget.currentId != null) {
        if (audioPlayer.state != AudioPlayerState.STOPPED) {
          await audioPlayer.stop();
          setState(() => null);
        }
      }
      AudioPlayerWidget.currentId = widget.event.eventId;
    }
    switch (audioPlayer.state) {
      case AudioPlayerState.PLAYING:
        await audioPlayer.pause();
        break;
      case AudioPlayerState.PAUSED:
        await audioPlayer.resume();
        break;
      case AudioPlayerState.STOPPED:
      default:
        onAudioPositionChanged ??=
            audioPlayer.onAudioPositionChanged.listen((state) {
          setState(() {
            statusText =
                '${state.inMinutes.toString().padLeft(2, '0')}:${(state.inSeconds % 60).toString().padLeft(2, '0')}';
            currentPosition = state.inMilliseconds.toDouble();
          });
        });
        onDurationChanged ??= audioPlayer.onDurationChanged.listen((max) =>
            setState(() => maxPosition = max.inMilliseconds.toDouble()));
        onPlayerStateChanged ??= audioPlayer.onPlayerStateChanged
            .listen((_) => setState(() => null));
        onPlayerError ??= audioPlayer.onPlayerError.listen((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(L10n.of(context).oopsSomethingWentWrong),
            ),
          );
          SentryController.captureException(e, StackTrace.current);
        });

        await audioPlayer.play(audioFile.path);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformInfos.isLinux || PlatformInfos.isWindows) {
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
                    audioPlayer.state == AudioPlayerState.PLAYING
                        ? Icons.pause_outlined
                        : Icons.play_arrow_outlined,
                    color: widget.color,
                  ),
                  tooltip: audioPlayer.state == AudioPlayerState.PLAYING
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
            activeColor: Theme.of(context).colorScheme.secondaryVariant,
            inactiveColor: widget.color.withAlpha(64),
            value: currentPosition,
            onChanged: (double position) =>
                audioPlayer.seek(Duration(milliseconds: position.toInt())),
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
