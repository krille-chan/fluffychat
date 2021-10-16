import 'dart:async';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:wakelock/wakelock.dart';

class RecordingDialog extends StatefulWidget {
  static const String recordingFileType = 'm4a';
  const RecordingDialog({
    Key key,
  }) : super(key: key);

  @override
  _RecordingDialogState createState() => _RecordingDialogState();
}

class _RecordingDialogState extends State<RecordingDialog> {
  Timer _recorderSubscription;
  Duration _duration = Duration.zero;

  bool error = false;
  String _recordedPath;
  final _audioRecorder = Record();
  Amplitude _amplitude;

  Future<void> startRecording() async {
    try {
      final tempDir = await getTemporaryDirectory();
      _recordedPath =
          '${tempDir.path}/recording${DateTime.now().microsecondsSinceEpoch}.${RecordingDialog.recordingFileType}';

      final result = await _audioRecorder.hasPermission();
      if (result != true) {
        setState(() => error = true);
        return;
      }
      await Wakelock.enable();
      await _audioRecorder.start(
          path: _recordedPath, encoder: AudioEncoder.AAC);
      setState(() => _duration = Duration.zero);
      _recorderSubscription?.cancel();
      _recorderSubscription =
          Timer.periodic(const Duration(milliseconds: 100), (_) async {
        _amplitude = await _audioRecorder.getAmplitude();
        setState(() {
          _duration += const Duration(milliseconds: 100);
        });
      });
    } catch (e, s) {
      SentryController.captureException(e, s);
      setState(() => error = true);
    }
  }

  @override
  void initState() {
    super.initState();
    startRecording();
  }

  @override
  void dispose() {
    Wakelock.disable();
    _recorderSubscription?.cancel();
    _audioRecorder.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const maxDecibalWidth = 64.0;
    final decibalWidth =
        ((_amplitude == null || _amplitude.current == double.negativeInfinity
                        ? 0
                        : _amplitude.current / _amplitude.max)
                    .abs() +
                1) *
            (maxDecibalWidth / 4).toDouble();
    final time =
        '${_duration.inMinutes.toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}';
    final content = error
        ? Text(L10n.of(context).oopsSomethingWentWrong)
        : Row(
            children: <Widget>[
              Container(
                width: maxDecibalWidth,
                height: maxDecibalWidth,
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: decibalWidth,
                  height: decibalWidth,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(decibalWidth),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${L10n.of(context).recording}: $time',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
    if (PlatformInfos.isCupertinoStyle) {
      return CupertinoAlertDialog(
        content: content,
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
            child: Text(
              L10n.of(context).cancel.toUpperCase(),
              style: TextStyle(
                color:
                    Theme.of(context).textTheme.bodyText2.color.withAlpha(150),
              ),
            ),
          ),
          if (error != true)
            CupertinoDialogAction(
              onPressed: () async {
                _recorderSubscription?.cancel();
                await _audioRecorder.stop();
                Navigator.of(context, rootNavigator: false)
                    .pop<String>(_recordedPath);
              },
              child: Text(L10n.of(context).send.toUpperCase()),
            ),
        ],
      );
    }
    return AlertDialog(
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
          child: Text(
            L10n.of(context).cancel.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText2.color.withAlpha(150),
            ),
          ),
        ),
        if (error != true)
          TextButton(
            onPressed: () async {
              _recorderSubscription?.cancel();
              await _audioRecorder.stop();
              Navigator.of(context, rootNavigator: false)
                  .pop<String>(_recordedPath);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(L10n.of(context).send.toUpperCase()),
                const SizedBox(width: 4),
                const Icon(Icons.send_outlined, size: 15),
              ],
            ),
          ),
      ],
    );
  }
}
