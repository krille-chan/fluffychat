import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/image_bubble.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import '../utils/event_extension.dart';

class ImageView extends StatelessWidget {
  final Event event;

  const ImageView(this.event, {Key key}) : super(key: key);

  void _forwardAction(BuildContext context) async {
    Matrix.of(context).shareContent = event.content;
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        backgroundColor: Color(0x44000000),
        actions: [
          IconButton(
            icon: Icon(Icons.reply),
            onPressed: () => _forwardAction(context),
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () => event.openFile(context),
            color: Colors.white,
          ),
        ],
      ),
      body: ZoomableWidget(
        minScale: 1.0,
        maxScale: 10.0,
        child: ImageBubble(
          event,
          tapToView: false,
          fit: BoxFit.contain,
          backgroundColor: Colors.black,
          maxSize: false,
          radius: 0.0,
        ),
      ),
    );
  }
}
