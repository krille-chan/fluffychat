import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:async/async.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:just_audio/just_audio.dart';
import 'package:matrix/matrix.dart';
import 'package:opus_caf_converter_dart/opus_caf_converter_dart.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_audio_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/utils/file_description.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import '../../../widgets/matrix.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Color color;
  final Color linkColor;
  final double fontSize;
  // #Pangea
  // final Event event;
  final Event? event;
  final String eventId;
  final String roomId;
  final String senderId;
  final PangeaAudioFile? matrixFile;
  final ChatController chatController;
  final MessageOverlayController? overlayController;
  final bool autoplay;
  // Pangea#

  static const int wavesCount = 40;

  const AudioPlayerWidget(
    this.event, {
    required this.color,
    required this.linkColor,
    required this.fontSize,
    // #Pangea
    required this.eventId,
    required this.roomId,
    required this.senderId,
    this.matrixFile,
    required this.chatController,
    this.overlayController,
    this.autoplay = false,
    // Pangea#
    super.key,
  });

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

enum AudioPlayerStatus { notDownloaded, downloading, downloaded }

class AudioPlayerState extends State<AudioPlayerWidget> {
  static const double buttonSize = 36;

  AudioPlayerStatus status = AudioPlayerStatus.notDownloaded;

  late final MatrixState matrix;
  List<int>? _waveform;
  String? _durationString;

  // #Pangea
  StreamSubscription? _onAudioPositionChanged;
  StreamSubscription? _onAudioStateChanged;

  double playbackSpeed = 1.0;
  // Pangea#

  @override
  void dispose() {
    super.dispose();
    // final audioPlayer = matrix.voiceMessageEventId.value != widget.event.eventId
    final audioPlayer = matrix.voiceMessageEventId.value != widget.eventId
        ? null
        : matrix.audioPlayer;
    if (audioPlayer != null) {
      // #Pangea
      // if (audioPlayer.playing && !audioPlayer.isAtEndPosition) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     ScaffoldMessenger.of(matrix.context).showMaterialBanner(
      //       MaterialBanner(
      //         padding: EdgeInsets.zero,
      //         leading: StreamBuilder(
      //           stream: audioPlayer.playerStateStream.asBroadcastStream(),
      //           builder: (context, _) => IconButton(
      //             onPressed: () {
      //               if (audioPlayer.isAtEndPosition) {
      //                 audioPlayer.seek(Duration.zero);
      //               } else if (audioPlayer.playing) {
      //                 audioPlayer.pause();
      //               } else {
      //                 audioPlayer.play();
      //               }
      //             },
      //             icon: audioPlayer.playing && !audioPlayer.isAtEndPosition
      //                 ? const Icon(Icons.pause_outlined)
      //                 : const Icon(Icons.play_arrow_outlined),
      //           ),
      //         ),
      //         content: StreamBuilder(
      //           stream: audioPlayer.positionStream.asBroadcastStream(),
      //           builder: (context, _) => GestureDetector(
      //             onTap: () => FluffyChatApp.router.go(
      //               // #Pangea
      //               // '/rooms/${widget.event.room.id}?event=${widget.event.eventId}',
      //               '/rooms/${widget.roomId}?event=${widget.eventId}',
      //               // Pangea#
      //             ),
      //             child: Text(
      //               // #Pangea
      //               // '🎙️ ${audioPlayer.position.minuteSecondString} / ${audioPlayer.duration?.minuteSecondString} - ${widget.event.senderFromMemoryOrFallback.calcDisplayname()}',
      //               '🎙️ ${audioPlayer.position.minuteSecondString} / ${audioPlayer.duration?.minuteSecondString} - ${widget.event?.senderFromMemoryOrFallback.calcDisplayname() ?? widget.senderId}',
      //               // Pangea#
      //               maxLines: 1,
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //           ),
      //         ),
      //         actions: [
      //           IconButton(
      //             onPressed: () {
      //               audioPlayer.pause();
      //               audioPlayer.dispose();
      //               matrix.voiceMessageEventId.value =
      //                   matrix.audioPlayer = null;

      //               WidgetsBinding.instance.addPostFrameCallback((_) {
      //                 ScaffoldMessenger.of(matrix.context)
      //                     .clearMaterialBanners();
      //               });
      //             },
      //             icon: const Icon(Icons.close_outlined),
      //           ),
      //         ],
      //       ),
      //     );
      //   });
      //   return;
      // }
      // Pangea#
      audioPlayer.pause();
      audioPlayer.dispose();
      matrix.voiceMessageEventId.value = matrix.audioPlayer = null;
      // #Pangea
      _onAudioPositionChanged?.cancel();
      _onAudioStateChanged?.cancel();
      // Pangea#
    }
  }

  void _onButtonTap() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(matrix.context).clearMaterialBanners();
    });

    final currentPlayer =
        // #Pangea
        // matrix.voiceMessageEventId.value != widget.event.eventId
        matrix.voiceMessageEventId.value != widget.eventId
            // Pangea#
            ? null
            : matrix.audioPlayer;

    if (currentPlayer != null) {
      // #Pangea
      currentPlayer.setSpeed(playbackSpeed);
      // Pangea#
      if (currentPlayer.isAtEndPosition) {
        currentPlayer.seek(Duration.zero);
      } else if (currentPlayer.playing) {
        currentPlayer.pause();
      } else {
        currentPlayer.play();
      }
      return;
    }

    // #Pangea
    // matrix.voiceMessageEventId.value = widget.event.eventId;
    matrix.voiceMessageEventId.value = widget.eventId;
    // Pangea#
    matrix.audioPlayer
      ?..stop()
      ..dispose();
    File? file;
    MatrixFile? matrixFile;

    setState(() => status = AudioPlayerStatus.downloading);
    try {
      // #Pangea
      // matrixFile = await widget.event.downloadAndDecryptAttachment();
      matrixFile = await widget.event?.downloadAndDecryptAttachment();
      // Pangea#

      // #Pangea
      // if (!kIsWeb) {
      if (!kIsWeb) {
        if (matrixFile != null) {
          // Pangea#
          final tempDir = await getTemporaryDirectory();
          final fileName = Uri.encodeComponent(
            // #Pangea
            // widget.event.attachmentOrThumbnailMxcUrl()!.pathSegments.last,
            widget.event!.attachmentOrThumbnailMxcUrl()!.pathSegments.last,
            // Pangea#
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
          // #Pangea
        } else if (widget.matrixFile != null) {
          final tempDir = await getTemporaryDirectory();

          file = File('${tempDir.path}/${widget.matrixFile!.name}');
          await file.writeAsBytes(widget.matrixFile!.bytes);
        }
        // Pangea#
      }

      setState(() {
        status = AudioPlayerStatus.downloaded;
      });
    } catch (e, s) {
      Logs().v('Could not download audio file', e, s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toLocalizedString(context)),
        ),
      );
      rethrow;
    }
    if (!context.mounted) return;
    // #Pangea
    // if (matrix.voiceMessageEventId.value != widget.event.eventId) return;
    if (matrix.voiceMessageEventId.value != widget.eventId) return;
    matrix.audioPlayer?.dispose();
    // Pangea#

    final audioPlayer = matrix.audioPlayer = AudioPlayer();

    // #Pangea
    audioPlayer.setSpeed(playbackSpeed);
    _onAudioPositionChanged?.cancel();
    _onAudioPositionChanged =
        matrix.audioPlayer!.positionStream.listen((state) {
      // Pass current timestamp to overlay, so it can highlight as necessary
      if (widget.matrixFile?.tokens != null) {
        widget.overlayController?.highlightCurrentText(
          state.inMilliseconds,
          widget.matrixFile!.tokens!,
        );
      }
    });

    _onAudioStateChanged?.cancel();
    _onAudioStateChanged =
        matrix.audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        matrix.audioPlayer!.stop();
        matrix.audioPlayer!.seek(Duration.zero);
      }
    });
    // Pangea#

    // #Pangea
    // if (file != null) {
    //   audioPlayer.setFilePath(file.path);
    // } else {
    //   await audioPlayer.setAudioSource(MatrixFileAudioSource(matrixFile));
    // }
    if (file != null) {
      audioPlayer.setFilePath(file.path);
    } else {
      try {
        if (widget.matrixFile != null) {
          await audioPlayer.setAudioSource(
            BytesAudioSource(
              widget.matrixFile!.bytes,
              widget.matrixFile!.mimeType,
            ),
          );
        } else {
          await audioPlayer.setAudioSource(MatrixFileAudioSource(matrixFile!));
        }
      } catch (e, _) {
        debugger(when: kDebugMode);
      }
    }
    // Pangea#

    audioPlayer.play().onError(
          ErrorReporter(context, 'Unable to play audio message')
              .onErrorCallback,
        );
  }

  void _toggleSpeed() async {
    final audioPlayer = matrix.audioPlayer;
    // #Pangea
    // if (audioPlayer == null) return;
    switch (playbackSpeed) {
      case 1.0:
        setState(() => playbackSpeed = 0.75);
      case 0.75:
        setState(() => playbackSpeed = 0.5);
      case 0.5:
        setState(() => playbackSpeed = 1.25);
      case 1.25:
        setState(() => playbackSpeed = 1.5);
      default:
        setState(() => playbackSpeed = 1.0);
    }
    if (audioPlayer == null) return;
    // Pangea#
    switch (audioPlayer.speed) {
      // #Pangea
      // case 1.0:
      //   await audioPlayer.setSpeed(1.25);
      //   break;
      // case 1.25:
      //   await audioPlayer.setSpeed(1.5);
      //   break;
      // case 1.5:
      //   await audioPlayer.setSpeed(2.0);
      //   break;
      // case 2.0:
      //   await audioPlayer.setSpeed(0.5);
      //   break;
      // case 0.5:
      case 1.0:
        await audioPlayer.setSpeed(0.75);
        break;
      case 0.75:
        await audioPlayer.setSpeed(0.5);
        break;
      case 0.5:
        await audioPlayer.setSpeed(1.25);
        break;
      case 1.25:
        await audioPlayer.setSpeed(1.5);
        break;
      case 1.5:
      // Pangea#
      default:
        await audioPlayer.setSpeed(1.0);
        break;
    }
    setState(() {});
  }

  List<int>? _getWaveform() {
    // #Pangea
    final eventWaveForm = widget.matrixFile?.waveform ??
        widget.event?.content
            .tryGetMap<String, dynamic>('org.matrix.msc1767.audio')
            ?.tryGetList<int>('waveform');
    // final eventWaveForm = widget.event?.content
    //     .tryGetMap<String, dynamic>('org.matrix.msc1767.audio')
    //     ?.tryGetList<int>('waveform');
    // Pangea#
    if (eventWaveForm == null || eventWaveForm.isEmpty) {
      return null;
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

  @override
  void initState() {
    super.initState();
    matrix = Matrix.of(context);
    _waveform = _getWaveform();

    // #Pangea
    // if (matrix.voiceMessageEventId.value == widget.event.eventId &&
    if (matrix.voiceMessageEventId.value == widget.eventId &&
        // Pangea#
        matrix.audioPlayer != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(matrix.context).clearMaterialBanners();
      });
    }

    // #Pangea
    // final durationInt = widget.event.content
    //     .tryGetMap<String, dynamic>('info')
    //     ?.tryGet<int>('duration');
    int? durationInt;
    if (widget.matrixFile?.duration != null) {
      durationInt = widget.matrixFile!.duration;
    } else {
      durationInt = widget.event?.content
          .tryGetMap<String, dynamic>('info')
          ?.tryGet<int>('duration');
    }
    // Pangea#
    if (durationInt != null) {
      final duration = Duration(milliseconds: durationInt);
      _durationString = duration.minuteSecondString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final waveform = _waveform;

    return ValueListenableBuilder(
      valueListenable: matrix.voiceMessageEventId,
      builder: (context, eventId, _) {
        // #Pangea
        // final audioPlayer =
        //     eventId != widget.event.eventId ? null : matrix.audioPlayer;
        final audioPlayer =
            eventId != widget.eventId ? null : matrix.audioPlayer;
        // Pangea#

        // #Pangea
        // final fileDescription = widget.event.fileDescription;
        final fileDescription = widget.event?.fileDescription;
        // Pangea#

        // #Pangea
        // return StreamBuilder<Object>(
        return AbsorbPointer(
          absorbing: widget.event != null && !widget.event!.status.isSent,
          child: StreamBuilder<Object>(
            // Pangea#
            stream: audioPlayer == null
                ? null
                : StreamGroup.merge([
                    audioPlayer.positionStream.asBroadcastStream(),
                    audioPlayer.playerStateStream.asBroadcastStream(),
                  ]),
            builder: (context, _) {
              final maxPosition =
                  audioPlayer?.duration?.inMilliseconds.toDouble() ?? 1.0;
              var currentPosition =
                  audioPlayer?.position.inMilliseconds.toDouble() ?? 0.0;
              if (currentPosition > maxPosition) currentPosition = maxPosition;

              final wavePosition = (currentPosition / maxPosition) *
                  AudioPlayerWidget.wavesCount;

              final statusText = audioPlayer == null
                  ? _durationString ?? '00:00'
                  : audioPlayer.position.minuteSecondString;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: FluffyThemes.columnWidth,
                      ),
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
                                    // #Pangea
                                    // onLongPress: () =>
                                    //     widget.event.saveFile(context),
                                    onLongPress: () =>
                                        widget.event?.saveFile(context),
                                    // Pangea#
                                    onTap: _onButtonTap,
                                    child: Material(
                                      color: widget.color.withAlpha(64),
                                      borderRadius: BorderRadius.circular(64),
                                      child: Icon(
                                        audioPlayer?.playing == true &&
                                                audioPlayer?.isAtEndPosition ==
                                                    false
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
                                if (waveform != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 1,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: i < wavePosition
                                                      ? widget.color
                                                      : widget.color
                                                          .withAlpha(128),
                                                  borderRadius:
                                                      BorderRadius.circular(64),
                                                ),
                                                height:
                                                    32 * (waveform[i] / 1024),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                SizedBox(
                                  height: 32,
                                  child: Slider(
                                    // #Pangea
                                    // thumbColor: widget.event.senderId ==
                                    //         widget.event.room.client.userID
                                    //       ? theme.colorScheme.onPrimary
                                    //       : theme.colorScheme.primary,
                                    thumbColor: widget.senderId ==
                                            Matrix.of(context).client.userID
                                        ? widget.color
                                        : theme.colorScheme.onSurface,
                                    // Pangea#
                                    activeColor: waveform == null
                                        ? widget.color
                                        : Colors.transparent,
                                    inactiveColor: waveform == null
                                        ? widget.color.withAlpha(128)
                                        : Colors.transparent,
                                    max: maxPosition,
                                    value: currentPosition,
                                    onChanged: (position) => audioPlayer == null
                                        ? _onButtonTap()
                                        : audioPlayer.seek(
                                            Duration(
                                              milliseconds: position.round(),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // #Pangea
                          // SizedBox(
                          //   width: 36,
                          //   child: Text(
                          //     statusText,
                          //     style: TextStyle(
                          //       color: widget.color,
                          //       fontSize: 12,
                          //     ),
                          //   ),
                          // ),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: widget.color,
                              fontSize: 12,
                            ),
                          ),
                          // Pangea#
                          const SizedBox(width: 8),
                          // #Pangea
                          Material(
                            color: widget.color.withAlpha(64),
                            borderRadius:
                                BorderRadius.circular(AppConfig.borderRadius),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(AppConfig.borderRadius),
                              onTap: _toggleSpeed,
                              child: SizedBox(
                                width: 32,
                                height: 20,
                                child: Center(
                                  child: Text(
                                    '${audioPlayer?.speed.toString() ?? playbackSpeed}x',
                                    style: TextStyle(
                                      color: widget.color,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // AnimatedCrossFade(
                          //   firstChild: Padding(
                          //     padding: const EdgeInsets.only(right: 8.0),
                          //     child: Icon(
                          //       Icons.mic_none_outlined,
                          //       color: widget.color,
                          //     ),
                          //   ),
                          //   secondChild: Material(
                          //     color: widget.color.withAlpha(64),
                          //     borderRadius:
                          //         BorderRadius.circular(AppConfig.borderRadius),
                          //     child: InkWell(
                          //       borderRadius:
                          //           BorderRadius.circular(AppConfig.borderRadius),
                          //       onTap: _toggleSpeed,
                          //       child: SizedBox(
                          //         width: 32,
                          //         height: 20,
                          //         child: Center(
                          //           child: Text(
                          //             '${audioPlayer?.speed.toString()}x',
                          //             style: TextStyle(
                          //               color: widget.color,
                          //               fontSize: 9,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          //   alignment: Alignment.center,
                          //   crossFadeState: audioPlayer == null
                          //       ? CrossFadeState.showFirst
                          //       : CrossFadeState.showSecond,
                          //   duration: FluffyThemes.animationDuration,
                          // ),
                          // Pangea#
                        ],
                      ),
                    ),
                    if (fileDescription != null) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Linkify(
                          text: fileDescription,
                          textScaleFactor:
                              MediaQuery.textScalerOf(context).scale(1),
                          style: TextStyle(
                            color: widget.color,
                            fontSize: widget.fontSize,
                          ),
                          options: const LinkifyOptions(humanize: false),
                          linkStyle: TextStyle(
                            color: widget.linkColor,
                            fontSize: widget.fontSize,
                            decoration: TextDecoration.underline,
                            decorationColor: widget.linkColor,
                          ),
                          onOpen: (url) =>
                              UrlLauncher(context, url.url).launchUrl(),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
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

extension on AudioPlayer {
  bool get isAtEndPosition {
    final duration = this.duration;
    if (duration == null) return true;
    return position >= duration;
  }
}

extension on Duration {
  String get minuteSecondString =>
      '${inMinutes.toString().padLeft(2, '0')}:${(inSeconds % 60).toString().padLeft(2, '0')}';
}

// #Pangea
class BytesAudioSource extends StreamAudioSource {
  final Uint8List bytes;
  final String mimeType;
  BytesAudioSource(this.bytes, this.mimeType);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: mimeType,
    );
  }
}
// Pangea#
