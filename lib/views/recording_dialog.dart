import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordingDialog extends StatefulWidget {
  static const String recordingFileType = 'mp3';
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

  void startRecording() async {
    try {
      final tempDir = await getTemporaryDirectory();
      _recordedPath =
          '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.${RecordingDialog.recordingFileType}';

      // delete any existing file
      final outputFile = File(_recordedPath);
      if (outputFile.existsSync()) {
        await outputFile.delete();
      }

      await Record.start(path: _recordedPath);
      setState(() => _duration = Duration.zero);
      _recorderSubscription?.cancel();
      _recorderSubscription = Timer.periodic(Duration(seconds: 1),
          (_) => setState(() => _duration += Duration(seconds: 1)));
    } catch (e) {
      error = true;
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
    Record.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (error) {
      Timer(Duration(seconds: 1), () {
        Navigator.of(context, rootNavigator: false).pop();
      });
    }
    const maxDecibalWidth = 64.0;
    final decibalWidth =
        ((_duration.inSeconds % 2) + 1) * (maxDecibalWidth / 4).toDouble();
    final time =
        '${_duration.inMinutes.toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}';

    return AlertDialog(
      content: Row(
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
        TextButton(
          onPressed: () async {
            _recorderSubscription?.cancel();
            await Record.stop();
            Navigator.of(context, rootNavigator: false)
                .pop<String>(_recordedPath);
          },
          child: Row(
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
