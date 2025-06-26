import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:flutter/material.dart';

class NewWordOverlay extends StatefulWidget {
  final Widget child;
  final bool show;
  final Color overlayColor;
  final VoidCallback? onComplete;

  const NewWordOverlay({
    super.key,
    required this.child,
    required this.show,
    required this.overlayColor,
    this.onComplete,
  });

  @override
  State<NewWordOverlay> createState() => _NewWordOverlayState();
}

class _NewWordOverlayState extends State<NewWordOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _xpScaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Alignment> _alignmentAnim;
  late final Animation<Offset> _offsetAnim;
  final bool _showOverlay = true;
  Widget xpSeedWidget = const SizedBox();
  Widget? get svg => ConstructLevelEnum.seeds.icon();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _xpScaleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.bounceOut),
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _alignmentAnim = AlignmentTween(
      begin: Alignment.center,
      end: Alignment.topRight,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Offset animation: stays at Offset.zero, then moves up and right
    _offsetAnim = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.1, -0.1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    xpSeedWidget = Container(
      child: svg,
    );

    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showOverlay) return widget.child;
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: FadeTransition(
            opacity: ReverseAnimation(_fadeAnim),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: widget.overlayColor,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Align(
                      alignment: _alignmentAnim.value,
                      child: FractionalTranslation(
                        translation: _offsetAnim.value,
                        child: ScaleTransition(
                          scale: _xpScaleAnim,
                          child: Transform.scale(
                            scale: 2 * (1 - _fadeAnim.value),
                            child: xpSeedWidget,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
