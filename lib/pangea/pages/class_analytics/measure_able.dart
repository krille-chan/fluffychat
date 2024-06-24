import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MeasurableWidget extends StatefulWidget {
  final Widget child;
  final Function(Size? size, Offset? position) onChange;

  const MeasurableWidget({
    super.key,
    required this.onChange,
    required this.child,
  });

  @override
  _WidgetSizeState createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<MeasurableWidget> {
  var widgetKey = GlobalKey();
  Offset? oldPosition;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void postFrameCallback(_) {
    final context = widgetKey.currentContext;
    if (context == null) return;

    final RenderBox? box =
        widgetKey.currentContext?.findRenderObject() as RenderBox?;

    if (box != null && box.hasSize) {
      final Offset position = box.localToGlobal(Offset.zero);

      if (oldPosition != null) {
        if (oldPosition!.dx == position.dx && oldPosition!.dy == position.dy) {
          return;
        }
      }
      oldPosition = position;

      final newSize = context.size;
      widget.onChange(newSize, position);
    }
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }
}
