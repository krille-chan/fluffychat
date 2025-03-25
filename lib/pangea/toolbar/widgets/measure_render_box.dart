import 'package:flutter/material.dart';

class MeasureRenderBox extends StatefulWidget {
  final Widget child;
  final ValueChanged<RenderBox>? onChange;

  const MeasureRenderBox({
    super.key,
    required this.child,
    required this.onChange,
  });

  @override
  MeasureRenderBoxState createState() => MeasureRenderBoxState();
}

class MeasureRenderBoxState extends State<MeasureRenderBox> {
  Offset? _lastOffset;
  Size? _lastSize;

  void _updateOffset() {
    if (widget.onChange == null) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final offset = renderBox.localToGlobal(Offset.zero);
      if (_lastOffset == null ||
          _lastOffset != offset ||
          _lastSize == null ||
          _lastSize != renderBox.size) {
        _lastOffset = offset;
        _lastSize = renderBox.size;
        widget.onChange!(renderBox);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateOffset());
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _updateOffset());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: widget.child,
      ),
    );
  }
}
