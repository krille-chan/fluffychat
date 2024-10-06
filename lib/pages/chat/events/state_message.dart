import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import '../../../config/app_config.dart';

class StateMessage extends StatelessWidget {
  final Event event;
  const StateMessage(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            event.calcLocalizedBodyFallback(
              MatrixLocals(L10n.of(context)),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12 * AppConfig.fontSizeFactor,
              decoration: event.redacted ? TextDecoration.lineThrough : null,
              shadows: [
                Shadow(
                  color: theme.colorScheme.surface,
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
