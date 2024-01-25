import 'package:flutter/material.dart';

enum MessageMode { translation, play, definition, image, spellCheck }

class MessageOverlay {
  static void showOverlay(BuildContext context, GlobalKey targetKey) {
    final RenderBox renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Determines the vertical position of the overlay
    final bool isBottomRoomAvailable =
        MediaQuery.of(context).size.height - (offset.dy + size.height) >=
            size.height;

    OverlayEntry overlayEntry;
    MessageMode currentMode = MessageMode.translation;

    // Function to build the content based on the selected mode
    Widget buildContent() {
      switch (currentMode) {
        case MessageMode.translation:
          return const Text('Translation Mode');
        case MessageMode.play:
          return const Text('Play Mode');
        case MessageMode.definition:
          return const Text('Definition Mode');
        case MessageMode.image:
          return const Text('Image Mode');
        case MessageMode.spellCheck:
          return const Text('SpellCheck Mode');
        default:
          return const SizedBox.shrink(); // Returns an empty container
      }
    }

    // Function to show the overlay with an animation
    overlayEntry = OverlayEntry(
      builder: (context) => AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        left: offset.dx + size.width / 2 - screenWidth / 2,
        right: screenWidth - (offset.dx + size.width / 2 + screenWidth / 2),
        top: isBottomRoomAvailable ? offset.dy + size.height : null,
        bottom: isBottomRoomAvailable
            ? null
            : MediaQuery.of(context).size.height - offset.dy,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: screenWidth,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Material(
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Wrap(
                  alignment: WrapAlignment.center,
                  children: MessageMode.values.map((mode) {
                    return IconButton(
                      icon: Icon(_getIconData(mode)),
                      onPressed: () {
                        currentMode = mode;
                        overlayEntry.markNeedsBuild();
                      },
                    );
                  }).toList(),
                ),
                SizeTransition(
                  sizeFactor: currentMode != null
                      ? CurvedAnimation(
                          parent: Overlay.of(context).animation!,
                          curve: Curves.fastOutSlowIn)
                      : const AlwaysStoppedAnimation(0),
                  axisAlignment: -1.0,
                  child: buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  static IconData _getIconData(MessageMode mode) {
    switch (mode) {
      case MessageMode.translation:
        return Icons.g_translate;
      case MessageMode.play:
        return Icons.play_arrow;
      case MessageMode.definition:
        return Icons.book;
      case MessageMode.image:
        return Icons.image;
      case MessageMode.spellCheck:
        return Icons.spellcheck;
      default:
        return Icons.error;
    }
  }
}
