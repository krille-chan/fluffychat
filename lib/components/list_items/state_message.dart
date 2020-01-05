import 'package:bubble/bubble.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';

import '../message_content.dart';

class StateMessage extends StatelessWidget {
  final Event event;
  const StateMessage(this.event);

  @override
  Widget build(BuildContext context) {
    if (event.type == EventTypes.Redaction) return Container();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        opacity: 0.5,
        child: Bubble(
          color: Colors.black,
          elevation: 0,
          alignment: Alignment.center,
          child: MessageContent(event, textColor: Colors.white),
        ),
      ),
    );
  }
}
