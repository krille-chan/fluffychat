import 'package:flutter/material.dart';

import 'package:hermes/utils/error_reporter.dart';

class HermesErrorWidget extends StatefulWidget {
  final FlutterErrorDetails details;
  const HermesErrorWidget(this.details, {super.key});

  @override
  State<HermesErrorWidget> createState() => _HermesErrorWidgetState();
}

class _HermesErrorWidgetState extends State<HermesErrorWidget> {
  static final Set<String> knownExceptions = {};
  @override
  void initState() {
    super.initState();

    if (knownExceptions.contains(widget.details.exception.toString())) {
      return;
    }
    knownExceptions.add(widget.details.exception.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ErrorReporter(context, 'Error Widget').onErrorCallback(
        widget.details.exception,
        widget.details.stack,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange,
      child: Placeholder(
        child: Center(
          child: Material(
            color: Colors.white.withAlpha(230),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
