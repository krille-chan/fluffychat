import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../app_config.dart';

class StateMessage extends StatelessWidget {
  final Event event;
  final void Function(String) unfold;
  const StateMessage(this.event, {@required this.unfold});

  @override
  Widget build(BuildContext context) {
    if (event.unsigned['im.fluffychat.collapsed_state_event'] == true) {
      return Container();
    }
    final int counter =
        event.unsigned['im.fluffychat.collapsed_state_event_count'] ?? 0;
    return InkWell(
      onTap: counter != 0 ? () => unfold(event.eventId) : null,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 8.0,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.getLocalizedBody(MatrixLocals(L10n.of(context))),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyText1.fontSize *
                        AppConfig.fontSizeFactor,
                    color: Theme.of(context).textTheme.bodyText2.color,
                    decoration:
                        event.redacted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (counter != 0)
                  Text(
                    counter == 1
                        ? L10n.of(context).oneMoreEvent
                        : L10n.of(context).xMoreEvents(counter.toString()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
