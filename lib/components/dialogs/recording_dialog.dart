import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class RecordingDialog extends StatefulWidget {
  final L10n l10n;

  const RecordingDialog({
    @required this.l10n,
    Key key,
  }) : super(key: key);

  @override
  _RecordingDialogState createState() => _RecordingDialogState();
}

class _RecordingDialogState extends State<RecordingDialog> {
  final FlutterSoundRecorder flutterSound = FlutterSoundRecorder();
  String time = '00:00:00';

  StreamSubscription _recorderSubscription;

  bool error = false;
  String _recordedPath;
  double _decibels = 0;

  void startRecording() async {
    try {
      await flutterSound.openAudioSession();
      await flutterSound.setSubscriptionDuration(Duration(milliseconds: 100));

      final codec = Codec.aacADTS;
      final tempDir = await getTemporaryDirectory();
      _recordedPath = '${tempDir.path}/recording${ext[codec.index]}';

      // delete any existing file
      var outputFile = File(_recordedPath);
      if (outputFile.existsSync()) {
        await outputFile.delete();
      }

      await flutterSound.startRecorder(codec: codec, toFile: _recordedPath);

      _recorderSubscription = flutterSound.onProgress.listen((e) {
        setState(() {
          _decibels = e.decibels;
          time =
              '${e.duration.inMinutes.toString().padLeft(2, '0')}:${(e.duration.inSeconds % 60).toString().padLeft(2, '0')}';
        });
      });
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
    if (flutterSound.isRecording) flutterSound.stopRecorder();
    _recorderSubscription?.cancel();
    flutterSound.closeAudioSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (error) {
      Timer(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    }
    const maxDecibalWidth = 64.0;
    final decibalWidth = min(_decibels / 2, maxDecibalWidth).toDouble();
    return AlertDialog(
      content: Row(
        children: <Widget>[
          Container(
            width: maxDecibalWidth,
            height: maxDecibalWidth,
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 50),
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
              '${widget.l10n.recording}: $time',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            widget.l10n.cancel.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText2.color.withAlpha(150),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Row(
            children: <Widget>[
              Text(widget.l10n.send.toUpperCase()),
              SizedBox(width: 4),
              Icon(Icons.send_outlined, size: 15),
            ],
          ),
          onPressed: () async {
            await _recorderSubscription?.cancel();
            await flutterSound.stopRecorder();
            Navigator.of(context).pop<String>(_recordedPath);
          },
        ),
      ],
    );
  }
}
