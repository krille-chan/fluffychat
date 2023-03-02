import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'dismiss_keyboard.dart';

class PIPView extends StatefulWidget {
  final PIPViewCorner initialCorner;
  final double? floatingWidth;
  final double? floatingHeight;
  final bool avoidKeyboard;

  final Widget Function(
    BuildContext context,
    bool isFloating,
  ) builder;

  const PIPView({
    Key? key,
    required this.builder,
    this.initialCorner = PIPViewCorner.topRight,
    this.floatingWidth,
    this.floatingHeight,
    this.avoidKeyboard = true,
  }) : super(key: key);

  @override
  PIPViewState createState() => PIPViewState();

  static PIPViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<PIPViewState>();
  }
}

class PIPViewState extends State<PIPView> with TickerProviderStateMixin {
  late AnimationController _toggleFloatingAnimationController;
  late AnimationController _dragAnimationController;
  late PIPViewCorner _corner;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  bool _floating = false;
  Map<PIPViewCorner, Offset> _offsets = {};

  @override
  void initState() {
    super.initState();
    _corner = widget.initialCorner;
    _toggleFloatingAnimationController = AnimationController(
      duration: FluffyThemes.animationDuration,
      vsync: this,
    );
    _dragAnimationController = AnimationController(
      duration: FluffyThemes.animationDuration,
      vsync: this,
    );
  }

  void _updateCornersOffsets({
    required Size spaceSize,
    required Size widgetSize,
    required EdgeInsets windowPadding,
  }) {
    _offsets = _calculateOffsets(
      spaceSize: spaceSize,
      widgetSize: widgetSize,
      windowPadding: windowPadding,
    );
  }

  bool _isAnimating() {
    return _toggleFloatingAnimationController.isAnimating ||
        _dragAnimationController.isAnimating;
  }

  void setFloating(bool floating) {
    if (_isAnimating()) return;
    dismissKeyboard(context);
    setState(() {
      _floating = floating;
    });
    _toggleFloatingAnimationController.forward();
  }

  void stopFloating() {
    if (_isAnimating()) return;
    dismissKeyboard(context);
    _toggleFloatingAnimationController.reverse().whenCompleteOrCancel(() {
      if (mounted) {
        setState(() {
          _floating = false;
        });
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;
    setState(() {
      _dragOffset = _dragOffset.translate(
        details.delta.dx,
        details.delta.dy,
      );
    });
  }

  void _onPanCancel() {
    if (!_isDragging) return;
    setState(() {
      _dragAnimationController.value = 0;
      _dragOffset = Offset.zero;
      _isDragging = false;
    });
  }

  void _onPanEnd(_) {
    if (!_isDragging) return;

    final nearestCorner = _calculateNearestCorner(
      offset: _dragOffset,
      offsets: _offsets,
    );
    setState(() {
      _corner = nearestCorner;
      _isDragging = false;
    });
    _dragAnimationController.forward().whenCompleteOrCancel(() {
      _dragAnimationController.value = 0;
      _dragOffset = Offset.zero;
    });
  }

  void _onPanStart(_) {
    if (_isAnimating()) return;
    setState(() {
      _dragOffset = _offsets[_corner]!;
      _isDragging = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var windowPadding = mediaQuery.padding;
    if (widget.avoidKeyboard) {
      windowPadding += mediaQuery.viewInsets;
    }
    final isFloating = _floating;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        var floatingWidth = widget.floatingWidth;
        var floatingHeight = widget.floatingHeight;
        if (floatingWidth == null && floatingHeight != null) {
          floatingWidth = width / height * floatingHeight;
        }
        floatingWidth ??= 100.0;
        floatingHeight ??= height / width * floatingWidth;

        final floatingWidgetSize = Size(floatingWidth, floatingHeight);
        final fullWidgetSize = Size(width, height);

        _updateCornersOffsets(
          spaceSize: fullWidgetSize,
          widgetSize: floatingWidgetSize,
          windowPadding: windowPadding,
        );

        final calculatedOffset = _offsets[_corner];

        // BoxFit.cover
        final widthRatio = floatingWidth / width;
        final heightRatio = floatingHeight / height;
        final scaledDownScale = widthRatio > heightRatio
            ? floatingWidgetSize.width / fullWidgetSize.width
            : floatingWidgetSize.height / fullWidgetSize.height;

        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: Listenable.merge([
                _toggleFloatingAnimationController,
                _dragAnimationController,
              ]),
              builder: (context, child) {
                final animationCurve = CurveTween(
                  curve: Curves.easeInOutQuad,
                );
                final dragAnimationValue = animationCurve.transform(
                  _dragAnimationController.value,
                );
                final toggleFloatingAnimationValue = animationCurve.transform(
                  _toggleFloatingAnimationController.value,
                );

                final floatingOffset = _isDragging
                    ? _dragOffset
                    : Tween<Offset>(
                        begin: _dragOffset,
                        end: calculatedOffset,
                      ).transform(
                        _dragAnimationController.isAnimating
                            ? dragAnimationValue
                            : toggleFloatingAnimationValue,
                      );
                final borderRadius = Tween<double>(
                  begin: 0,
                  end: 10,
                ).transform(toggleFloatingAnimationValue);
                final width = Tween<double>(
                  begin: fullWidgetSize.width,
                  end: floatingWidgetSize.width,
                ).transform(toggleFloatingAnimationValue);
                final height = Tween<double>(
                  begin: fullWidgetSize.height,
                  end: floatingWidgetSize.height,
                ).transform(toggleFloatingAnimationValue);
                final scale = Tween<double>(
                  begin: 1,
                  end: scaledDownScale,
                ).transform(toggleFloatingAnimationValue);
                return Positioned(
                  left: floatingOffset.dx,
                  top: floatingOffset.dy,
                  child: GestureDetector(
                    onPanStart: isFloating ? _onPanStart : null,
                    onPanUpdate: isFloating ? _onPanUpdate : null,
                    onPanCancel: isFloating ? _onPanCancel : null,
                    onPanEnd: isFloating ? _onPanEnd : null,
                    onTap: isFloating ? stopFloating : null,
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        width: width,
                        height: height,
                        child: Transform.scale(
                          scale: scale,
                          child: OverflowBox(
                            maxHeight: fullWidgetSize.height,
                            maxWidth: fullWidgetSize.width,
                            child: IgnorePointer(
                              ignoring: isFloating,
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Builder(
                builder: (context) => widget.builder(context, isFloating),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum PIPViewCorner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class _CornerDistance {
  final PIPViewCorner corner;
  final double distance;

  _CornerDistance({
    required this.corner,
    required this.distance,
  });
}

PIPViewCorner _calculateNearestCorner({
  required Offset offset,
  required Map<PIPViewCorner, Offset> offsets,
}) {
  _CornerDistance calculateDistance(PIPViewCorner corner) {
    final distance = offsets[corner]!
        .translate(
          -offset.dx,
          -offset.dy,
        )
        .distanceSquared;
    return _CornerDistance(
      corner: corner,
      distance: distance,
    );
  }

  final distances = PIPViewCorner.values.map(calculateDistance).toList();

  distances.sort((cd0, cd1) => cd0.distance.compareTo(cd1.distance));

  return distances.first.corner;
}

Map<PIPViewCorner, Offset> _calculateOffsets({
  required Size spaceSize,
  required Size widgetSize,
  required EdgeInsets windowPadding,
}) {
  Offset getOffsetForCorner(PIPViewCorner corner) {
    const spacing = 16;
    final left = spacing + windowPadding.left;
    final top = spacing + windowPadding.top;
    final right =
        spaceSize.width - widgetSize.width - windowPadding.right - spacing;
    final bottom =
        spaceSize.height - widgetSize.height - windowPadding.bottom - spacing;

    switch (corner) {
      case PIPViewCorner.topLeft:
        return Offset(left, top);
      case PIPViewCorner.topRight:
        return Offset(right, top);
      case PIPViewCorner.bottomLeft:
        return Offset(left, bottom);
      case PIPViewCorner.bottomRight:
        return Offset(right, bottom);
      default:
        throw Exception('Not implemented.');
    }
  }

  const corners = PIPViewCorner.values;
  final offsets = <PIPViewCorner, Offset>{};
  for (final corner in corners) {
    offsets[corner] = getOffsetForCorner(corner);
  }

  return offsets;
}
