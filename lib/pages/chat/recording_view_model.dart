// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_recorder/flutter_recorder.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'events/audio_player.dart';

class RecordingViewModel extends StatefulWidget {
  final Widget Function(BuildContext, RecordingViewModelState) builder;

  const RecordingViewModel({required this.builder, super.key});

  @override
  RecordingViewModelState createState() => RecordingViewModelState();
}

class RecordingViewModelState extends State<RecordingViewModel> {
  Timer? _recorderSubscription;
  Duration duration = Duration.zero;

  bool get isRecording => Recorder.instance.isDeviceStarted();

  final List<double> amplitudeTimeline = [];

  String? fileName;

  String path = '';

  bool isPaused = false;

  Future<void> startRecording(Room room) async {
    if (PlatformInfos.isMobile) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (!mounted) return;
        showOkAlertDialog(
          context: context,
          title: L10n.of(context).oopsSomethingWentWrong,
          message: L10n.of(context).noPermission,
        );
        return;
      }
    }

    room.client.getConfig(); // Preload server file configuration.

    try {
      await Recorder.instance.init(
        format: PCMFormat.f32le,
        sampleRate: AppSettings.audioRecordingSamplingRate.value,
        channels: RecorderChannels.mono,
        androidInputPreset: AndroidInputPreset.voiceRecognition,
      );
      Recorder.instance.start();

      setState(() {});

      fileName = 'voice_message_${DateTime.now().millisecondsSinceEpoch}.ogg';

      if (!kIsWeb) {
        final tempDir = await getTemporaryDirectory();
        path = path_lib.join(tempDir.path, fileName);
      }

      await WakelockPlus.enable();

      _subscribe();

      Recorder.instance.setVisualizationEnabled(true);

      Recorder.instance.startRecording(
        completeFilePath: path,
        format: .opusOgg,
      );
      if (!mounted) return;
      setState(() => duration = Duration.zero);
    } catch (e, s) {
      Logs().w('Unable to start voice message recording', e, s);
      if (!mounted) return;
      showOkAlertDialog(
        context: context,
        title: L10n.of(context).oopsSomethingWentWrong,
        message: e.toString(),
      );
      setState(_reset);
    }
  }

  @override
  void dispose() {
    _reset();
    super.dispose();
  }

  void _subscribe() {
    const tickTime = Duration(milliseconds: 100);
    _recorderSubscription?.cancel();
    _recorderSubscription = Timer.periodic(tickTime, (_) {
      final volume = 100 + Recorder.instance.getVolumeDb() * 2;
      setState(() {
        amplitudeTimeline.add(volume < 1 ? 1 : volume);
        duration += tickTime;
      });
    });
  }

  void _reset() {
    WakelockPlus.disable();
    _recorderSubscription?.cancel();
    if (Recorder.instance.isDeviceStarted()) Recorder.instance.stop();
    Recorder.instance.deinit();

    fileName = null;
    duration = Duration.zero;
    amplitudeTimeline.clear();
    isPaused = false;
  }

  void cancel() {
    setState(_reset);
  }

  void pause() {
    Recorder.instance.setPauseRecording(pause: true);
    _recorderSubscription?.cancel();
    setState(() {
      isPaused = true;
    });
  }

  void resume() {
    Recorder.instance.setPauseRecording(pause: false);
    _subscribe();
    setState(() {
      isPaused = false;
    });
  }

  Future<void> stopAndSend(
    Future<void> Function(
      String path,
      int duration,
      List<int> waveform,
      String fileName,
    )
    onSend,
  ) async {
    final path = this.path;
    _recorderSubscription?.cancel();
    Recorder.instance.stopRecording();
    Recorder.instance.stop();
    if (path.isEmpty) throw Exception('Recording failed!');

    const waveCount = AudioPlayerWidget.wavesCount;
    final step = amplitudeTimeline.length < waveCount
        ? 1
        : (amplitudeTimeline.length / waveCount).round();
    final waveform = <int>[];
    for (var i = 0; i < amplitudeTimeline.length; i += step) {
      waveform.add((amplitudeTimeline[i] / 100 * 1024).round());
    }

    onSend(path, duration.inMilliseconds, waveform, fileName!);

    cancel();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, this);
}
