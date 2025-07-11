import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:matrix/matrix.dart';

import 'package:hermes/config/themes.dart';
import 'package:hermes/pages/image_viewer/image_viewer_view.dart';
import 'package:hermes/utils/platform_infos.dart';
import 'package:hermes/utils/show_scaffold_dialog.dart';
import 'package:hermes/widgets/share_scaffold_dialog.dart';
import '../../utils/matrix_sdk_extensions/event_extension.dart';

class ImageViewer extends StatefulWidget {
  final Event event;
  final Timeline? timeline;
  final BuildContext outerContext;

  const ImageViewer(
    this.event, {
    required this.outerContext,
    this.timeline,
    super.key,
  });

  @override
  ImageViewerController createState() => ImageViewerController();
}

class ImageViewerController extends State<ImageViewer> {
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    allEvents = widget.timeline?.events
            .where(
              (event) => {
                MessageTypes.Image,
                MessageTypes.Sticker,
                if (PlatformInfos.supportsVideoPlayer) MessageTypes.Video,
              }.contains(event.messageType),
            )
            .toList()
            .reversed
            .toList() ??
        [widget.event];
    var index =
        allEvents.indexWhere((event) => event.eventId == widget.event.eventId);
    if (index < 0) index = 0;
    pageController = PageController(initialPage: index);
  }

  late final PageController pageController;

  late final List<Event> allEvents;

  void onKeyEvent(KeyEvent event) {
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.keyH:
        if (canGoBack) prevImage();
        break;
      case LogicalKeyboardKey.keyL:
      case LogicalKeyboardKey.arrowDown:
        if (canGoNext) nextImage();
        break;
    }
  }

  void prevImage() async {
    await pageController.previousPage(
      duration: PantheonThemes.animationDuration,
      curve: PantheonThemes.animationCurve,
    );
    if (!mounted) return;
    setState(() {});
  }

  void nextImage() async {
    await pageController.nextPage(
      duration: PantheonThemes.animationDuration,
      curve: PantheonThemes.animationCurve,
    );
    if (!mounted) return;
    setState(() {});
  }

  int get _index => pageController.page?.toInt() ?? 0;

  Event get currentEvent => allEvents[_index];

  bool get canGoNext => _index < allEvents.length - 1;

  bool get canGoBack => _index > 0;

  /// Forward this image to another room.
  void forwardAction() => showScaffoldDialog(
        context: context,
        builder: (context) => ShareScaffoldDialog(
          items: [ContentShareItem(currentEvent.content)],
        ),
      );

  /// Save this file with a system call.
  void saveFileAction(BuildContext context) => currentEvent.saveFile(context);

  /// Save this file with a system call.
  void shareFileAction(BuildContext context) => currentEvent.shareFile(context);

  static const maxScaleFactor = 1.5;

  /// Go back if user swiped it away
  void onInteractionEnds(ScaleEndDetails endDetails) {
    if (!PlatformInfos.usesTouchscreen) {
      if (endDetails.velocity.pixelsPerSecond.dy >
          MediaQuery.sizeOf(context).height * maxScaleFactor) {
        Navigator.of(context, rootNavigator: false).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ImageViewerView(this);
}
