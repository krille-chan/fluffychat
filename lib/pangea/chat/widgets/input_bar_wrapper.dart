import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_input_row.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/pangea_text_controller.dart';

class ChatInputRowWrapper extends StatefulWidget {
  final ChatController controller;

  const ChatInputRowWrapper({
    required this.controller,
    super.key,
  });

  @override
  State<ChatInputRowWrapper> createState() => ChatInputRowWrapperState();
}

class ChatInputRowWrapperState extends State<ChatInputRowWrapper> {
  StreamSubscription? _choreoSub;
  String _currentText = '';

  @override
  void initState() {
    // Rebuild the widget each time there's an update from choreo
    _choreoSub = widget.controller.choreographer.stateStream.stream.listen((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _choreoSub?.cancel();
    super.dispose();
  }

  void refreshOnChange(String text) {
    final bool decreasedFromMaxLength =
        _currentText.length >= PangeaTextController.maxLength &&
            text.length < PangeaTextController.maxLength;
    final bool reachedMaxLength =
        _currentText.length < PangeaTextController.maxLength &&
            text.length < PangeaTextController.maxLength;

    if (decreasedFromMaxLength || reachedMaxLength) {
      setState(() {});
    }
    _currentText = text;
  }

  @override
  Widget build(BuildContext context) => ChatInputRow(widget.controller);
}
