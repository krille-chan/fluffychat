import 'package:bubble/bubble.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';

import '../message_content.dart';

class StateMessage extends StatelessWidget {
  final Event event;
  const StateMessage(this.event);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Bubble(
        color: Color(0xFFF8F8F8),
        elevation: 0,
        alignment: Alignment.center,
        child: MessageContent(event),
      ),
    );
  }
}
