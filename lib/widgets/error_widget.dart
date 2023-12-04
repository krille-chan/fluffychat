import 'package:flutter/material.dart';

import 'package:fluffychat/utils/error_reporter.dart';

class FluffyChatErrorWidget extends StatefulWidget {
  final FlutterErrorDetails details;
  const FluffyChatErrorWidget(this.details, {super.key});

  @override
  State<FluffyChatErrorWidget> createState() => _FluffyChatErrorWidgetState();
}

class _FluffyChatErrorWidgetState extends State<FluffyChatErrorWidget> {
  @override
  void initState() {
    super.initState();

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
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '😲 Oh no! Something is broken 😲\n${widget.details.exception}',
                maxLines: 5,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
