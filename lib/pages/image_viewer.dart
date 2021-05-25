import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/pages/views/image_viewer_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../utils/matrix_sdk_extensions.dart/event_extension.dart';

class ImageViewer extends StatefulWidget {
  final void Function() onLoaded;

  const ImageViewer({Key key, this.onLoaded}) : super(key: key);

  @override
  ImageViewerController createState() => ImageViewerController();
}

class ImageViewerController extends State<ImageViewer> {
  /// Forward this image to another room.
  void forwardAction(Event event) {
    Matrix.of(context).shareContent = event.content;
    VRouter.of(context).push('/rooms');
  }

  /// Open this file with a system call.
  void openFileAction(Event event) =>
      event.openFile(context, downloadOnly: true);

  /// Go back if user swiped it away
  void onInteractionEnds(ScaleEndDetails endDetails) {
    if (PlatformInfos.usesTouchscreen == false) {
      if (endDetails.velocity.pixelsPerSecond.dy >
          MediaQuery.of(context).size.height * 1.50) {
        Navigator.of(context, rootNavigator: false).pop();
      }
    }
  }

  Future<Event> getEvent() {
    final roomId = VRouter.of(context).pathParameters['roomid'];
    final eventId = VRouter.of(context).pathParameters['eventid'];
    return Matrix.of(context).client.database.getEventById(
          Matrix.of(context).client.id,
          eventId,
          Matrix.of(context).client.getRoomById(roomId),
        );
  }

  @override
  Widget build(BuildContext context) => ImageViewerView(this);
}
