import 'package:bubble/bubble.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/material.dart';

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
      child: Bubble(
        elevation: 0,
        color: Theme.of(context).backgroundColor.withOpacity(0.66),
        alignment: Alignment.center,
        child: Text(
          event.getLocalizedBody(L10n.of(context)),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2.color,
            decoration: event.redacted ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}
