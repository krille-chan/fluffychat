import 'package:bubble/bubble.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:link_text/link_text.dart';

class StateMessage extends StatelessWidget {
  final Event event;
  const StateMessage(this.event);

  @override
  Widget build(BuildContext context) {
    if (event.type == EventTypes.Redaction) return Container();
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: Opacity(
        opacity: 0.5,
        child: Bubble(
          elevation: 0,
          color: Colors.black,
          alignment: Alignment.center,
          child: LinkText(
            text: event.getLocalizedBody(context),
            textStyle: TextStyle(
              color: Colors.white,
              decoration: event.redacted ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}
