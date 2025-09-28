import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:matrix/matrix.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'events/audio_player.dart';

class RecordingViewModel extends StatefulWidget {
  final Widget Function(BuildContext, RecordingViewModelState) builder;

  const RecordingViewModel({
    required this.builder,
    super.key,
  });

  @override
  RecordingViewModelState createState() => RecordingViewModelState();
}

class RecordingViewModelState extends State<RecordingViewModel> {
  Timer? _recorderSubscription;
  Duration duration = Duration.zero;

  bool error = false;
  bool isSending = false;

  bool get isRecording => _audioRecorder != null;

  AudioRecorder? _audioRecorder;
  final List<double> amplitudeTimeline = [];

  String? fileName;

  bool isPaused = false;

  Future<void> startRecording(Room room) async {
    room.client.getConfig(); // Preload server file configuration.
    if (PlatformInfos.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt < 19) {
        showOkAlertDialog(
          context: context,
          title: L10n.of(context).unsupportedAndroidVersion,
          message: L10n.of(context).unsupportedAndroidVersionLong,
          okLabel: L10n.of(context).close,
        );
        return;
      }
    }
    if (await AudioRecorder().hasPermission() == false) return;

    final store = Matrix.of(context).store;

    final audioRecorder = _audioRecorder ??= AudioRecorder();
    setState(() {});

    try {
      final codec = kIsWeb
          // Web seems to create webm instead of ogg when using opus encoder
          // which does not play on iOS right now. So we use wav for now:
          ? AudioEncoder.wav
          // Everywhere else we use opus if supported by the platform:
          : await audioRecorder.isEncoderSupported(AudioEncoder.opus)
              ? AudioEncoder.opus
              : AudioEncoder.aacLc;
      fileName =
          'recording${DateTime.now().microsecondsSinceEpoch}.${codec.fileExtension}';
      String? path;
      if (!kIsWeb) {
        final tempDir = await getTemporaryDirectory();
        path = path_lib.join(tempDir.path, fileName);
      }

      final result = await audioRecorder.hasPermission();
      if (result != true) {
        setState(() => error = true);
        return;
      }
      await WakelockPlus.enable();

      await audioRecorder.start(
        RecordConfig(
          bitRate: AppSettings.audioRecordingBitRate.getItem(store),
          sampleRate: AppSettings.audioRecordingSamplingRate.getItem(store),
          numChannels: AppSettings.audioRecordingNumChannels.getItem(store),
          autoGain: AppSettings.audioRecordingAutoGain.getItem(store),
          echoCancel: AppSettings.audioRecordingEchoCancel.getItem(store),
          noiseSuppress: AppSettings.audioRecordingNoiseSuppress.getItem(store),
          encoder: codec,
        ),
        path: path ?? '',
      );
      setState(() => duration = Duration.zero);
      _subscribe();
    } catch (_) {
      setState(() => error = true);
      rethrow;
    }
  }

  @override
  void dispose() {
    _reset();
    super.dispose();
  }

  void _subscribe() {
    _recorderSubscription?.cancel();
    _recorderSubscription =
        Timer.periodic(const Duration(milliseconds: 100), (_) async {
      final amplitude = await _audioRecorder!.getAmplitude();
      var value = 100 + amplitude.current * 2;
      value = value < 1 ? 1 : value;
      amplitudeTimeline.add(value);
      setState(() {
        duration += const Duration(milliseconds: 100);
      });
    });
  }

  void _reset() {
    WakelockPlus.disable();
    _recorderSubscription?.cancel();
    _audioRecorder?.stop();
    _audioRecorder = null;
    isSending = false;
    error = false;
    fileName = null;
    duration = Duration.zero;
    amplitudeTimeline.clear();
    isPaused = false;
  }

  void cancel() {
    setState(() {
      _reset();
    });
  }

  void pause() {
    _audioRecorder?.pause();
    _recorderSubscription?.cancel();
    setState(() {
      isPaused = true;
    });
  }

  void resume() {
    _audioRecorder?.resume();
    _subscribe();
    setState(() {
      isPaused = false;
    });
  }

  void stopAndSend(
    Future<void> Function(
      String path,
      int duration,
      List<int> waveform,
      String? fileName,
    ) onSend,
  ) async {
    _recorderSubscription?.cancel();
    final path = await _audioRecorder?.stop();

    if (path == null) throw ('Recording failed!');
    const waveCount = AudioPlayerWidget.wavesCount;
    final step = amplitudeTimeline.length < waveCount
        ? 1
        : (amplitudeTimeline.length / waveCount).round();
    final waveform = <int>[];
    for (var i = 0; i < amplitudeTimeline.length; i += step) {
      waveform.add((amplitudeTimeline[i] / 100 * 1024).round());
    }

    setState(() {
      isSending = true;
    });
    try {
      await onSend(path, duration.inMilliseconds, waveform, fileName);
    } catch (e, s) {
      Logs().e('Unable to send voice message', e, s);
      setState(() {
        isSending = false;
      });
      return;
    }

    cancel();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, this);
}

extension on AudioEncoder {
  String get fileExtension {
    switch (this) {
      case AudioEncoder.aacLc:
      case AudioEncoder.aacEld:
      case AudioEncoder.aacHe:
        return 'm4a';
      case AudioEncoder.opus:
        return 'ogg';
      case AudioEncoder.wav:
        return 'wav';
      case AudioEncoder.amrNb:
      case AudioEncoder.amrWb:
      case AudioEncoder.flac:
      case AudioEncoder.pcm16bits:
        throw UnsupportedError('Not yet used');
    }
  }
}
