import 'package:flutter/material.dart';

class MouseOverBuilder extends StatefulWidget {
  final Function(BuildContext, bool) builder;

  const MouseOverBuilder({Key key, this.builder}) : super(key: key);
  @override
  _MouseOverBuilderState createState() => _MouseOverBuilderState();
}

class _MouseOverBuilderState extends State<MouseOverBuilder> {
  bool _hover = false;

  void _toggleHover(bool hover) {
    if (_hover != hover) {
      setState(() => _hover = hover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _toggleHover(true),
      onExit: (_) => _toggleHover(false),
      child: widget.builder != null ? widget.builder(context, _hover) : null,
    );
  }
}
