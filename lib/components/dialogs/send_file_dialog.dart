import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:native_imaging/native_imaging.dart' as native;

import '../../utils/matrix_file_extension.dart';
import '../../utils/room_send_file_extension.dart';
import '../../components/dialogs/simple_dialogs.dart';
import '../../l10n/l10n.dart';

class SendFileDialog extends StatefulWidget {
  final Room room;
  final MatrixFile file;

  const SendFileDialog({this.room, this.file, Key key}) : super(key: key);

  @override
  _SendFileDialogState createState() => _SendFileDialogState();
}

class _SendFileDialogState extends State<SendFileDialog> {
  bool origImage = false;

  Future<void> _send() async {
    var file = widget.file;
    if (file is MatrixImageFile && !origImage) {
      final imgFile = file as MatrixImageFile;
      // resize to max 1600 x 1600
      try {
        await native.init();
        var nativeImg = native.Image();
        try {
          await nativeImg.loadEncoded(imgFile.bytes);
          imgFile.width = nativeImg.width();
          imgFile.height = nativeImg.height();
        } on UnsupportedError {
          final dartCodec = await instantiateImageCodec(imgFile.bytes);
          final dartFrame = await dartCodec.getNextFrame();
          imgFile.width = dartFrame.image.width;
          imgFile.height = dartFrame.image.height;
          final rgbaData = await dartFrame.image.toByteData();
          final rgba = Uint8List.view(
              rgbaData.buffer, rgbaData.offsetInBytes, rgbaData.lengthInBytes);
          dartFrame.image.dispose();
          dartCodec.dispose();
          nativeImg.loadRGBA(imgFile.width, imgFile.height, rgba);
        }

        const max = 1600;
        if (imgFile.width > max || imgFile.height > max) {
          var w = max, h = max;
          if (imgFile.width > imgFile.height) {
            h = max * imgFile.height ~/ imgFile.width;
          } else {
            w = max * imgFile.width ~/ imgFile.height;
          }

          final scaledImg = nativeImg.resample(w, h, native.Transform.lanczos);
          nativeImg.free();
          nativeImg = scaledImg;
        }
        final jpegBytes = await nativeImg.toJpeg(75);
        file = MatrixImageFile(
            bytes: jpegBytes,
            name: 'scaled_' + imgFile.name.split('.').first + '.jpg');
        nativeImg.free();
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
        FlatButton(
          child: Text(L10n.of(context).cancel),
          onPressed: () {
            // just close the dialog
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(L10n.of(context).send),
          onPressed: () async {
            await SimpleDialogs(context).tryRequestWithLoadingDialog(_send());
            await Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
