import 'dart:async';

import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordingDialog extends StatefulWidget {
  static const String recordingFileType = 'aac';
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

  void startRecording() async {
    try {
      final tempDir = await getTemporaryDirectory();
      _recordedPath =
          '${tempDir.path}/recording${DateTime.now().microsecondsSinceEpoch}.${RecordingDialog.recordingFileType}';

      final result = await _audioRecorder.hasPermission();
      if (result != true) {
        setState(() => error = true);
        return;
      }
      await _audioRecorder.start(
          path: _recordedPath, encoder: AudioEncoder.AAC);
      setState(() => _duration = Duration.zero);
      _recorderSubscription?.cancel();
      _recorderSubscription = Timer.periodic(Duration(seconds: 1),
          (_) => setState(() => _duration += Duration(seconds: 1)));
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
    _recorderSubscription?.cancel();
    _audioRecorder.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const maxDecibalWidth = 64.0;
    final decibalWidth =
        ((_duration.inSeconds % 2) + 1) * (maxDecibalWidth / 4).toDouble();
    final time =
        '${_duration.inMinutes.toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}';

    return AlertDialog(
      content: error
          ? Text(L10n.of(context).oopsSomethingWentWrong)
          : Row(
              children: <Widget>[
                Container(
                  width: maxDecibalWidth,
                  height: maxDecibalWidth,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: decibalWidth,
                    height: decibalWidth,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(decibalWidth),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${L10n.of(context).recording}: $time',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
      actions: <Widget>[
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
                SizedBox(width: 4),
                Icon(Icons.send_outlined, size: 15),
              ],
            ),
          ),
      ],
    );
  }
}
