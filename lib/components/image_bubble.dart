import 'package:bubble/bubble.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:fluffychat/utils/matrix_file_extension.dart';

class ImageBubble extends StatefulWidget {
  final Event event;

  const ImageBubble(this.event, {Key key}) : super(key: key);

  @override
  _ImageBubbleState createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  MatrixFile _file;
  dynamic _error;

  Future<MatrixFile> _getFile() async {
    if (_file != null) return _file;
    return widget.event.downloadAndDecryptAttachment();
  }

  @override
  Widget build(BuildContext context) {
    final int size = 400;
    return Bubble(
      padding: BubbleEdges.all(0),
      radius: Radius.circular(10),
      elevation: 0,
      child: Container(
        height: size.toDouble(),
        width: size.toDouble(),
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
                onTap: () => _file.open(),
                child: Image.memory(
                  _file.bytes,
                  width: size.toDouble(),
                  height: size.toDouble(),
                  fit: BoxFit.fill,
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
