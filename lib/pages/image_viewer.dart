import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/pages/views/image_viewer_ui.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

import '../utils/event_extension.dart';

class ImageViewer extends StatefulWidget {
  final Event event;
  final void Function() onLoaded;

  const ImageViewer(this.event, {Key key, this.onLoaded}) : super(key: key);

  @override
  ImageViewerController createState() => ImageViewerController();
}

class ImageViewerController extends State<ImageViewer> {
  /// Forward this image to another room.
  void forwardAction() {
    Matrix.of(context).shareContent = widget.event.content;
    AdaptivePageLayout.of(context).popUntilIsFirst();
  }

  /// Open this file with a system call.
  void openFileAction() => widget.event.openFile(context, downloadOnly: true);

  /// Go back if user swiped it away
  void onInteractionEnds(ScaleEndDetails endDetails) {
    if (PlatformInfos.usesTouchscreen == false) {
      if (endDetails.velocity.pixelsPerSecond.dy >
          MediaQuery.of(context).size.height * 1.50) {
        Navigator.of(context, rootNavigator: false).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ImageViewerUI(this);
}
