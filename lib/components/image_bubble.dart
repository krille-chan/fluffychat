import 'package:bubble/bubble.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:fluffychat/utils/matrix_file_extension.dart';

import 'dialogs/simple_dialogs.dart';

class ImageBubble extends StatefulWidget {
  final Event event;

  const ImageBubble(this.event, {Key key}) : super(key: key);

  @override
  _ImageBubbleState createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  static Map<String, MatrixFile> _matrixFileMap = {};
  MatrixFile get _file => _matrixFileMap[widget.event.eventId];
  set _file(MatrixFile file) {
    _matrixFileMap[widget.event.eventId] = file;
  }

  dynamic _error;

  Future<MatrixFile> _getFile() async {
    if (_file != null) return _file;
    return widget.event.downloadAndDecryptAttachment(getThumbnail: true);
  }

  @override
  Widget build(BuildContext context) {
    return Bubble(
      padding: BubbleEdges.all(0),
      radius: Radius.circular(10),
      color: Theme.of(context).secondaryHeaderColor,
      elevation: 0,
      child: Container(
        height: 300,
        width: 400,
        child: Builder(
          builder: (BuildContext context) {
            if (_error != null) {
              return Center(
                child: Text(
                  _error.toString(),
                ),
              );
            }
            if (_file != null) {
              return InkWell(
                onTap: () async {
                  final MatrixFile matrixFile =
                      await SimpleDialogs(context).tryRequestWithLoadingDialog(
                    widget.event.downloadAndDecryptAttachment(),
                  );
                  matrixFile.open();
                },
                child: Image.memory(
                  _file.bytes,
                  fit: BoxFit.cover,
                ),
              );
            }
            _getFile().then((MatrixFile file) {
              setState(() => _file = file);
            }, onError: (error) {
              setState(() => _error = error);
            });
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
