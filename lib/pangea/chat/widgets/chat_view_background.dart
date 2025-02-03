import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';

class ChatViewBackground extends StatefulWidget {
  final Choreographer choreographer;
  const ChatViewBackground(this.choreographer, {super.key});

  @override
  ChatViewBackgroundState createState() => ChatViewBackgroundState();
}

class ChatViewBackgroundState extends State<ChatViewBackground> {
  StreamSubscription? _choreoSub;

  @override
  void initState() {
    // Rebuild the widget each time there's an update from choreo
    _choreoSub = widget.choreographer.stateListener.stream.listen((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _choreoSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.choreographer.itController.willOpen
        ? Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Material(
              borderOnForeground: false,
              color: const Color.fromRGBO(0, 0, 0, 1).withAlpha(150),
              clipBehavior: Clip.antiAlias,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent,
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
