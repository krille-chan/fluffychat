import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:just_audio/just_audio.dart';
import 'package:matrix/matrix.dart';
import 'package:opus_caf_converter_dart/opus_caf_converter_dart.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import '../../../utils/matrix_sdk_extensions/event_extension.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Color color;
  final double fontSize;
  final Event event;

  static String? currentId;

  static const int wavesCount = 40;

  const AudioPlayerWidget(
    this.event, {
    this.color = Colors.black,
    required this.fontSize,
    super.key,
  });

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

enum AudioPlayerStatus { notDownloaded, downloading, downloaded }

class AudioPlayerState extends State<AudioPlayerWidget> {
  AudioPlayerStatus status = AudioPlayerStatus.notDownloaded;
  AudioPlayer? audioPlayer;

  StreamSubscription? onAudioPositionChanged;
  StreamSubscription? onDurationChanged;
  StreamSubscription? onPlayerStateChanged;
  StreamSubscription? onPlayerError;

  String? statusText;
  double currentPosition = 0;
  double maxPosition = 1;

  MatrixFile? matrixFile;
  File? audioFile;

  @override
  void dispose() {
    if (audioPlayer?.playerState.playing == true) {
      audioPlayer?.stop();
    }
    onAudioPositionChanged?.cancel();
    onDurationChanged?.cancel();
    onPlayerStateChanged?.cancel();
    onPlayerError?.cancel();

    super.dispose();
  }

  void _startAction() {
    if (status == AudioPlayerStatus.downloaded) {
      _playAction();
    } else {
      _downloadAction();
    }
  }

  Future<void> _downloadAction() async {
    if (status != AudioPlayerStatus.notDownloaded) return;
    setState(() => status = AudioPlayerStatus.downloading);
    try {
      final matrixFile = await widget.event.downloadAndDecryptAttachment();
      File? file;

      if (!kIsWeb) {
        final tempDir = await getTemporaryDirectory();
        final fileName = Uri.encodeComponent(
          widget.event.attachmentOrThumbnailMxcUrl()!.pathSegments.last,
        );
        file = File('${tempDir.path}/${fileName}_${matrixFile.name}');

        await file.writeAsBytes(matrixFile.bytes);

        if (Platform.isIOS &&
            matrixFile.mimeType.toLowerCase() == 'audio/ogg') {
          Logs().v('Convert ogg audio file for iOS...');
          final convertedFile = File('${file.path}.caf');
          if (await convertedFile.exists() == false) {
            OpusCaf().convertOpusToCaf(file.path, convertedFile.path);
          }
          file = convertedFile;
        }
      }

      setState(() {
        audioFile = file;
        this.matrixFile = matrixFile;
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
    final audioPlayer = this.audioPlayer ??= AudioPlayer();
    if (AudioPlayerWidget.currentId != widget.event.eventId) {
      if (AudioPlayerWidget.currentId != null) {
        if (audioPlayer.playerState.playing) {
          await audioPlayer.stop();
          setState(() {});
        }
      }
      AudioPlayerWidget.currentId = widget.event.eventId;
    }
    if (audioPlayer.playerState.playing) {
      await audioPlayer.pause();
      return;
    } else if (audioPlayer.position != Duration.zero) {
      await audioPlayer.play();
      return;
    }

    onAudioPositionChanged ??= audioPlayer.positionStream.listen((state) {
      if (maxPosition <= 0) return;
      setState(() {
        statusText =
            '${state.inMinutes.toString().padLeft(2, '0')}:${(state.inSeconds % 60).toString().padLeft(2, '0')}';
        currentPosition = state.inMilliseconds.toDouble();
      });
      if (state.inMilliseconds.toDouble() == maxPosition) {
        audioPlayer.stop();
        audioPlayer.seek(null);
      }
    });
    onDurationChanged ??= audioPlayer.durationStream.listen((max) {
      if (max == null || max == Duration.zero) return;
      setState(() => maxPosition = max.inMilliseconds.toDouble());
    });
    onPlayerStateChanged ??=
        audioPlayer.playingStream.listen((_) => setState(() {}));
    final audioFile = this.audioFile;
    if (audioFile != null) {
      audioPlayer.setFilePath(audioFile.path);
    } else {
      await audioPlayer.setAudioSource(MatrixFileAudioSource(matrixFile!));
    }
    audioPlayer.play().onError(
          ErrorReporter(context, 'Unable to play audio message')
              .onErrorCallback,
        );
  }

  static const double buttonSize = 36;

  String? get _durationString {
    final durationInt = widget.event.content
        .tryGetMap<String, dynamic>('info')
        ?.tryGet<int>('duration');
    if (durationInt == null) return null;
    final duration = Duration(milliseconds: durationInt);
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  List<int> _getWaveform() {
    final eventWaveForm = widget.event.content
        .tryGetMap<String, dynamic>('org.matrix.msc1767.audio')
        ?.tryGetList<int>('waveform');
    if (eventWaveForm == null || eventWaveForm.isEmpty) {
      return List<int>.filled(AudioPlayerWidget.wavesCount, 500);
    }
    while (eventWaveForm.length < AudioPlayerWidget.wavesCount) {
      for (var i = 0; i < eventWaveForm.length; i = i + 2) {
        eventWaveForm.insert(i, eventWaveForm[i]);
      }
    }
    var i = 0;
    final step = (eventWaveForm.length / AudioPlayerWidget.wavesCount).round();
    while (eventWaveForm.length > AudioPlayerWidget.wavesCount) {
      eventWaveForm.removeAt(i);
      i = (i + step) % AudioPlayerWidget.wavesCount;
    }
    return eventWaveForm.map((i) => i > 1024 ? 1024 : i).toList();
  }

  late final List<int> waveform;

  void _toggleSpeed() async {
    final audioPlayer = this.audioPlayer;
    if (audioPlayer == null) return;
    switch (audioPlayer.speed) {
      case 1.0:
        await audioPlayer.setSpeed(1.25);
        break;
      case 1.25:
        await audioPlayer.setSpeed(1.5);
        break;
      case 1.5:
        await audioPlayer.setSpeed(2.0);
        break;
      case 2.0:
        await audioPlayer.setSpeed(0.5);
        break;
      case 0.5:
      default:
        await audioPlayer.setSpeed(1.0);
        break;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    waveform = _getWaveform();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final statusText = this.statusText ??= _durationString ?? '00:00';
    final audioPlayer = this.audioPlayer;

    final body = widget.event.content.tryGet<String>('body') ??
        widget.event.content.tryGet<String>('filename');
    final displayBody = body != null &&
        body.isNotEmpty &&
        widget.event.content['org.matrix.msc1767.audio'] == null;

    final wavePosition =
        (currentPosition / maxPosition) * AudioPlayerWidget.wavesCount;

    final fontSize = 12 * AppConfig.fontSizeFactor;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: FluffyThemes.columnWidth),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: buttonSize,
                  height: buttonSize,
                  child: status == AudioPlayerStatus.downloading
                      ? CircularProgressIndicator(
                          strokeWidth: 2,
                          color: widget.color,
                        )
                      : InkWell(
                          borderRadius: BorderRadius.circular(64),
                          onLongPress: () => widget.event.saveFile(context),
                          onTap: _startAction,
                          child: Material(
                            color: widget.color.withAlpha(64),
                            borderRadius: BorderRadius.circular(64),
                            child: Icon(
                              audioPlayer?.playerState.playing == true
                                  ? Icons.pause_outlined
                                  : Icons.play_arrow_outlined,
                              color: widget.color,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            for (var i = 0;
                                i < AudioPlayerWidget.wavesCount;
                                i++)
                              Expanded(
                                child: Container(
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: i < wavePosition
                                          ? widget.color
                                          : widget.color.withAlpha(128),
                                      borderRadius: BorderRadius.circular(64),
                                    ),
                                    height: 32 * (waveform[i] / 1024),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                        child: Slider(
                          thumbColor: widget.event.senderId ==
                                  widget.event.room.client.userID
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.primary,
                          activeColor: Colors.transparent,
                          inactiveColor: Colors.transparent,
                          max: maxPosition,
                          value: currentPosition,
                          onChanged: (position) => audioPlayer == null
                              ? _startAction()
                              : audioPlayer.seek(
                                  Duration(milliseconds: position.round()),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 36,
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Badge(
                  isLabelVisible: audioPlayer != null,
                  label: audioPlayer == null
                      ? null
                      : Text(
                          '${audioPlayer.speed.toString()}x',
                        ),
                  backgroundColor: theme.colorScheme.secondary,
                  textColor: theme.colorScheme.onSecondary,
                  child: InkWell(
                    splashColor: widget.color.withAlpha(128),
                    borderRadius: BorderRadius.circular(64),
                    onTap: audioPlayer == null ? null : _toggleSpeed,
                    child: Icon(
                      Icons.mic_none_outlined,
                      color: widget.color,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          if (displayBody) ...[
            const SizedBox(height: 8),
            Linkify(
              text: body,
              style: TextStyle(
                color: widget.color,
                fontSize: fontSize,
              ),
              options: const LinkifyOptions(humanize: false),
              linkStyle: TextStyle(
                color: widget.color.withAlpha(150),
                fontSize: fontSize,
                decoration: TextDecoration.underline,
                decorationColor: widget.color.withAlpha(150),
              ),
              onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
            ),
          ],
        ],
      ),
    );
  }
}

/// To use a MatrixFile as an AudioSource for the just_audio package
class MatrixFileAudioSource extends StreamAudioSource {
  final MatrixFile file;
  MatrixFileAudioSource(this.file);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= file.bytes.length;
    return StreamAudioResponse(
      sourceLength: file.bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(file.bytes.sublist(start, end)),
      contentType: file.mimeType,
    );
  }
}
