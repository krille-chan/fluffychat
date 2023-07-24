import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/settings_chat/settings_chat.dart';
import 'package:fluffychat/widgets/animated_emoji_plain_text.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CuteContent extends StatefulWidget {
  final Event event;
  final Color color;

  const CuteContent(
    this.event, {
    super.key,
    required this.color,
  });

  @override
  State<CuteContent> createState() => _CuteContentState();
}

class _CuteContentState extends State<CuteContent> {
  static bool _isOverlayShown = false;
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    if (initialized == false) {
      initialized = true;

      if (Matrix.of(context).client.autoplayAnimatedContent ??
          !kIsWeb && !_isOverlayShown) {
        addOverlay();
      }
    }
    return FutureBuilder<User?>(
      future: widget.event.fetchSenderUser(),
      builder: (context, snapshot) {
        final label = generateLabel(snapshot.data);

        return GestureDetector(
          onTap: addOverlay,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextLinkifyEmojify(
                widget.event.text,
                fontSize: 150,
                textColor: widget.color,
              ),
              if (label != null) Text(label),
            ],
          ),
        );
      },
    );
  }

  Future<void> addOverlay() async {
    _isOverlayShown = true;
    await Future.delayed(const Duration(milliseconds: 50));

    OverlayEntry? overlay;
    overlay = OverlayEntry(
      builder: (context) => CuteEventOverlay(
        emoji: widget.event.text,
        onAnimationEnd: () {
          _isOverlayShown = false;
          overlay?.remove();
        },
      ),
    );
    Overlay.of(context).insert(overlay);
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

class CuteEventOverlay extends StatefulWidget {
  final String emoji;
  final VoidCallback onAnimationEnd;

  const CuteEventOverlay({
    super.key,
    required this.emoji,
    required this.onAnimationEnd,
  });

  @override
  State<CuteEventOverlay> createState() => _CuteEventOverlayState();
}

class _CuteEventOverlayState extends State<CuteEventOverlay>
    with TickerProviderStateMixin {
  final List<Size> items = List.generate(
    50,
    (index) => Size(
      Random().nextDouble(),
      4 + (Random().nextDouble() * 4),
    ),
  );

  AnimationController? controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    controller?.forward();
    controller?.addStatusListener(_hideOverlay);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller!,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth - _CuteOverlayContent.size;
          final height = constraints.maxHeight + _CuteOverlayContent.size;
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: OverflowBox(
              child: Stack(
                alignment: Alignment.bottomLeft,
                fit: StackFit.expand,
                children: items
                    .map(
                      (position) => Positioned(
                        left: position.width * width,
                        bottom: (height *
                                .25 *
                                position.height *
                                (controller?.value ?? 0)) -
                            _CuteOverlayContent.size,
                        child: _CuteOverlayContent(
                          emoji: widget.emoji,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  void _hideOverlay(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onAnimationEnd.call();
    }
  }
}

class _CuteOverlayContent extends StatelessWidget {
  static const double size = 64.0;
  final String emoji;

  const _CuteOverlayContent({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      size: const Size.square(size),
      child: ClipRect(
        clipBehavior: Clip.hardEdge,
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 56),
        ),
      ),
    );
  }
}
