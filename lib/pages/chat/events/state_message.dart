import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import '../../../config/app_config.dart';

class StateMessage extends StatelessWidget {
  final Event event;
  const StateMessage(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          ),
          child: FutureBuilder<String>(
            future: event.calcLocalizedBody(MatrixLocals(L10n.of(context)!)),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ??
                    event.calcLocalizedBodyFallback(
                      MatrixLocals(L10n.of(context)!),
                    ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14 * AppConfig.fontSizeFactor,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  decoration:
                      event.redacted ? TextDecoration.lineThrough : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
