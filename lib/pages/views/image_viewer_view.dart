import 'package:famedlysdk/famedlysdk.dart';

import '../image_viewer.dart';
import 'package:fluffychat/widgets/event_content/image_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ImageViewerView extends StatelessWidget {
  final ImageViewerController controller;

  const ImageViewerView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Event>(
        future: controller.getEvent(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Color(0x44000000),
              ),
              body: Center(
                  child: snapshot.hasError
                      ? Text(
                          L10n.of(context).oopsSomethingWentWrong,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      : CircularProgressIndicator()),
            );
          }
          final event = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0x44000000),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: Navigator.of(context, rootNavigator: false).pop,
                color: Colors.white,
                tooltip: L10n.of(context).close,
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.reply_outlined),
                  onPressed: () => controller.forwardAction(event),
                  color: Colors.white,
                  tooltip: L10n.of(context).share,
                ),
                IconButton(
                  icon: Icon(Icons.download_outlined),
                  onPressed: () => controller.openFileAction(event),
                  color: Colors.white,
                  tooltip: L10n.of(context).downloadFile,
                ),
              ],
            ),
            body: InteractiveViewer(
              minScale: 1.0,
              maxScale: 10.0,
              onInteractionEnd: controller.onInteractionEnds,
              child: Center(
                child: ImageBubble(
                  event,
                  tapToView: false,
                  onLoaded: controller.widget.onLoaded,
                  fit: BoxFit.contain,
                  backgroundColor: Colors.black,
                  maxSize: false,
                  radius: 0.0,
                  thumbnailOnly: false,
                ),
              ),
            ),
          );
        });
  }
}
