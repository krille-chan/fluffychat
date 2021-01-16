import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/image_bubble.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../utils/event_extension.dart';

class ImageView extends StatelessWidget {
  final Event event;
  final void Function() onLoaded;

  const ImageView(this.event, {Key key, this.onLoaded}) : super(key: key);

  void _forwardAction(BuildContext context) async {
    Matrix.of(context).shareContent = event.content;
    AdaptivePageLayout.of(context).popUntilIsFirst();
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
            icon: Icon(Icons.reply_outlined),
            onPressed: () => _forwardAction(context),
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.download_outlined),
            onPressed: () => event.openFile(context, downloadOnly: true),
            color: Colors.white,
          ),
        ],
      ),
      body: PhotoView.customChild(
        minScale: 1.0,
        maxScale: 10.0,
        child: ImageBubble(
          event,
          tapToView: false,
          onLoaded: onLoaded,
          fit: BoxFit.contain,
          backgroundColor: Colors.black,
          maxSize: false,
          radius: 0.0,
          thumbnailOnly: false,
        ),
      ),
    );
  }
}
