import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';

class RecordingDialog extends StatefulWidget {
  final Function onFinished;
  final L10n l10n;

  const RecordingDialog({
    this.onFinished,
    @required this.l10n,
    Key key,
  }) : super(key: key);

  @override
  _RecordingDialogState createState() => _RecordingDialogState();
}

class _RecordingDialogState extends State<RecordingDialog> {
  FlutterSound flutterSound = FlutterSound();
  String time = '00:00:00';

  StreamSubscription _recorderSubscription;

  bool error = false;

  void startRecording() async {
    try {
      await flutterSound.startRecorder(
        codec: t_CODEC.CODEC_AAC,
      );
      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        var date =
            DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
        setState(() => time = DateFormat('mm:ss:SS', 'en_US').format(date));
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (error) {
      Timer(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    }
    return AlertDialog(
      content: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.red,
            radius: 8,
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
            final result = await flutterSound.stopRecorder();
            if (widget.onFinished != null) {
              widget.onFinished(result);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
