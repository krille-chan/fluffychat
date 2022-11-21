import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';

class CuteContent extends StatefulWidget {
  final Event event;

  const CuteContent(this.event, {Key? key}) : super(key: key);

  @override
  State<CuteContent> createState() => _CuteContentState();
}

class _CuteContentState extends State<CuteContent> {
  static final List<OverlayEntry> overlays = [];

  @override
  void initState() {
    if (AppConfig.autoplayImages && overlays.isEmpty) {
      addOverlay();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: widget.event.fetchSenderUser(),
      builder: (context, snapshot) {
        final label = generateLabel(snapshot.data);

        return GestureDetector(
          onTap: addOverlay,
          child: SizedBox.square(
            dimension: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.event.text,
                  style: const TextStyle(fontSize: 150),
                ),
                if (label != null) Text(label)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget overlayBuilder(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final position = Size(
          Random().nextInt(constraints.maxWidth.round() - 64).toDouble(),
          Random().nextInt(constraints.maxHeight.round() - 64).toDouble());

      return Padding(
        padding: EdgeInsets.only(
            top: position.height,
            left: position.width,
            bottom: constraints.maxHeight - 64 - position.height,
            right: constraints.maxWidth - 64 - position.width),
        child: SizedBox.square(
          dimension: 64,
          child: GestureDetector(
            onTap: removeOverlay,
            child: Text(
              widget.event.text,
              style: const TextStyle(fontSize: 48),
            ),
          ),
        ),
      );
    });
  }

  Future<void> addOverlay() async {
    await Future.delayed(const Duration(milliseconds: 50));
    for (int i = 0; i < 5; i++) {
      final overlay = OverlayEntry(
        builder: overlayBuilder,
      );
      Overlay.of(context)?.insert(overlay);

      Future.delayed(Duration(seconds: Random().nextInt(35))).then((_) {
        overlay.remove();
        overlays.remove(overlay);
      });
      overlays.add(overlay);
    }
  }

  void removeOverlay() {
    if (overlays.isEmpty) return;
    final overlay = overlays.removeLast();
    overlay.remove();
  }

  generateLabel(User? user) {
    switch (widget.event.content['cute_type']) {
      case 'googly_eyes':
        return L10n.of(context)?.googlyEyesContent(
          user?.displayName ??
              widget.event.senderFromMemoryOrFallback.displayName ??
              '',
        );
      case 'cuddle':
        return L10n.of(context)?.cuddleContent(
          user?.displayName ??
              widget.event.senderFromMemoryOrFallback.displayName ??
              '',
        );
      case 'hug':
        return L10n.of(context)?.hugContent(
          user?.displayName ??
              widget.event.senderFromMemoryOrFallback.displayName ??
              '',
        );
    }
  }
}
