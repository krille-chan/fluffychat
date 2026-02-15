import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/image_viewer/image_viewer_view.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/show_scaffold_dialog.dart';
import 'package:fluffychat/widgets/share_scaffold_dialog.dart';
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
    allEvents =
        widget.timeline?.events
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
    var index = allEvents.indexWhere(
      (event) => event.eventId == widget.event.eventId,
    );
    if (index < 0) index = 0;
    pageController = PageController(initialPage: index);
  }

  late final PageController pageController;

  late final List<Event> allEvents;

  bool isZoomed = false;

  void setZoomed(bool value) {
    if (isZoomed == value) return;
    setState(() {
      isZoomed = value;
    });
  }

  void handleDriveScroll(double delta) {
    if (pageController.positions.isEmpty) return;
    final maxScrollExtent = pageController.position.maxScrollExtent;
    final minScrollExtent = pageController.position.minScrollExtent;
    final newOffset = (pageController.offset - delta).clamp(minScrollExtent, maxScrollExtent);
    pageController.jumpTo(newOffset);
  }

  void handleDriveScrollEnd(ScaleEndDetails details) {
    if (pageController.positions.isEmpty) return;
    
    // Determine the target page based on velocity and current offset
    final velocity = details.velocity.pixelsPerSecond.dy;
    final currentOffset = pageController.offset;
    final screenHeight = MediaQuery.sizeOf(context).height;
    
    // Default to current page
    int targetDisplayIndex = (currentOffset / screenHeight).round();
    
    // Adjust target page based on fling velocity
    if (velocity < -500) {
      // Swiped up (Next image)
      targetDisplayIndex = (currentOffset / screenHeight).ceil();
    } else if (velocity > 500) {
      // Swiped down (Prev image)
      targetDisplayIndex = (currentOffset / screenHeight).floor();
    }
    
    // Ensure bounds
    if (targetDisplayIndex < 0) targetDisplayIndex = 0;
    if (targetDisplayIndex >= allEvents.length) targetDisplayIndex = allEvents.length - 1;

    
    pageController.animateToPage(
      targetDisplayIndex,
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
    );
  }

  void onKeyEvent(KeyEvent event) {
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
        if (canGoBack && !isZoomed) prevImage();
        break;
      case LogicalKeyboardKey.arrowDown:
        if (canGoNext && !isZoomed) nextImage();
        break;
    }
  }

  void prevImage() async {
    await pageController.previousPage(
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
    );
    if (!mounted) return;
    setState(() {});
  }

  void nextImage() async {
    await pageController.nextPage(
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
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
    builder: (context) =>
        ShareScaffoldDialog(items: [ContentShareItem(currentEvent.content)]),
  );

  /// Save this file with a system call.
  void saveFileAction(BuildContext context) => currentEvent.saveFile(context);

  /// Save this file with a system call.
  void shareFileAction(BuildContext context) => currentEvent.shareFile(context);

  static const maxScaleFactor = 1.5;

  /// Go back if user swiped it away
  void onInteractionEnds(ScaleEndDetails endDetails) {
    if (PlatformInfos.usesTouchscreen == false) {
      if (endDetails.velocity.pixelsPerSecond.dy >
          MediaQuery.sizeOf(context).height * maxScaleFactor) {
        Navigator.of(context, rootNavigator: false).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ImageViewerView(this);
}
