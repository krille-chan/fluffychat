import 'package:bubble/bubble.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/image_view.dart';
import 'package:flutter/material.dart';

class ImageBubble extends StatefulWidget {
  final Event event;
  final bool tapToView;
  final BoxFit fit;
  final bool maxSize;
  final Color backgroundColor;
  final double radius;

  const ImageBubble(
    this.event, {
    this.tapToView = true,
    this.maxSize = true,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.radius = 10.0,
    Key key,
  }) : super(key: key);

  @override
  _ImageBubbleState createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  static final Map<String, MatrixFile> _matrixFileMap = {};
  MatrixFile get _file => _matrixFileMap[widget.event.eventId];
  set _file(MatrixFile file) {
    _matrixFileMap[widget.event.eventId] = file;
  }

  dynamic _error;

  Future<MatrixFile> _getFile() async {
    if (_file != null) return _file;
    return widget.event
        .downloadAndDecryptAttachment(getThumbnail: widget.event.hasThumbnail);
  }

  @override
  Widget build(BuildContext context) {
    return Bubble(
      padding: BubbleEdges.all(0),
      radius: Radius.circular(widget.radius),
      color: widget.backgroundColor ?? Theme.of(context).secondaryHeaderColor,
      elevation: 0,
      child: Container(
        height: widget.maxSize ? 300 : null,
        width: widget.maxSize ? 400 : null,
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
                onTap: () {
                  if (!widget.tapToView) return;
                  Navigator.of(context).push(
                    AppRoute(
                      ImageView(widget.event),
                    ),
                  );
                },
                child: Hero(
                  tag: widget.event.eventId,
                  child: Image.memory(
                    _file.bytes,
                    fit: widget.fit,
                  ),
                ),
              );
            }
            _getFile().then((MatrixFile file) {
              setState(() => _file = file);
            }, onError: (error, stacktrace) {
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
