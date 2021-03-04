import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import '../../utils/matrix_file_extension.dart';
import '../../utils/room_send_file_extension.dart';
import '../../utils/resize_image.dart';

class SendFileDialog extends StatefulWidget {
  final Room room;
  final MatrixFile file;

  const SendFileDialog({
    this.room,
    this.file,
    Key key,
  }) : super(key: key);

  @override
  _SendFileDialogState createState() => _SendFileDialogState();
}

class _SendFileDialogState extends State<SendFileDialog> {
  bool origImage = false;
  bool _isSending = false;
  Future<void> _send() async {
    var file = widget.file;
    if (file is MatrixImageFile && !origImage) {
      try {
        file = await resizeImage(file, max: 1600);
      } catch (e) {
        // couldn't resize
      }
    }
    await widget.room.sendFileEventWithThumbnail(file);
  }

  @override
  Widget build(BuildContext context) {
    var sendStr = L10n.of(context).sendFile;
    if (widget.file is MatrixImageFile) {
      sendStr = L10n.of(context).sendImage;
    } else if (widget.file is MatrixAudioFile) {
      sendStr = L10n.of(context).sendAudio;
    } else if (widget.file is MatrixVideoFile) {
      sendStr = L10n.of(context).sendVideo;
    }
    Widget contentWidget;
    if (widget.file is MatrixImageFile) {
      contentWidget = Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Flexible(
          child: Image.memory(
            widget.file.bytes,
            fit: BoxFit.contain,
          ),
        ),
        Text(widget.file.name),
        Row(
          children: <Widget>[
            Checkbox(
              value: origImage,
              onChanged: (v) => setState(() => origImage = v),
            ),
            InkWell(
              onTap: () => setState(() => origImage = !origImage),
              child: Text(L10n.of(context).sendOriginal +
                  ' (${widget.file.sizeString})'),
            ),
          ],
        )
      ]);
    } else {
      contentWidget = Text('${widget.file.name} (${widget.file.sizeString})');
    }
    return AlertDialog(
      title: Text(sendStr),
      content: contentWidget,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // just close the dialog
            Navigator.of(context, rootNavigator: false).pop();
          },
          child: Text(L10n.of(context).cancel),
        ),
        TextButton(
          onPressed: _isSending
              ? null
              : () async {
                  setState(() {
                    _isSending = true;
                  });
                  await showFutureLoadingDialog(
                      context: context, future: () => _send());
                  Navigator.of(context, rootNavigator: false).pop();
                },
          child: Text(L10n.of(context).send),
        ),
      ],
    );
  }
}
