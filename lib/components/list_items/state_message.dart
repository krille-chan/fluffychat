import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class StateMessage extends StatelessWidget {
  final Event event;
  const StateMessage(this.event);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          child: Text(
            event.getLocalizedBody(MatrixLocals(L10n.of(context))),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText2.color,
              decoration: event.redacted ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}
