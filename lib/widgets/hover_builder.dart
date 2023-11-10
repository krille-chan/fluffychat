import 'package:flutter/material.dart';

class HoverBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool hovered) builder;
  const HoverBuilder({required this.builder, super.key});

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => hovered
          ? null
          : setState(() {
              hovered = true;
            }),
      onExit: (_) => !hovered
          ? null
          : setState(() {
              hovered = false;
            }),
      child: widget.builder(context, hovered),
    );
  }
}
