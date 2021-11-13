import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import '../../../config/app_config.dart';

class StateMessage extends StatelessWidget {
  final Event event;
  final void Function(String) unfold;
  const StateMessage(this.event, {@required this.unfold, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (event.unsigned['im.fluffychat.collapsed_state_event'] == true) {
      return Container();
    }
    final int counter =
        event.unsigned['im.fluffychat.collapsed_state_event_count'] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Center(
        child: InkWell(
          onTap: counter != 0 ? () => unfold(event.eventId) : null,
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.getLocalizedBody(MatrixLocals(L10n.of(context))),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14 * AppConfig.fontSizeFactor,
                    color: Theme.of(context).textTheme.bodyText2.color,
                    decoration:
                        event.redacted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (counter != 0)
                  Text(
                    L10n.of(context).moreEvents(counter),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * AppConfig.fontSizeFactor,
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
