// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/utd_dialog.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../../config/app_config.dart';

class StateMessage extends StatelessWidget {
  final Event event;
  final void Function()? onExpand;
  final bool isCollapsed;
  const StateMessage(
    this.event, {
    this.onExpand,
    this.isCollapsed = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedSize(
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
      child: isCollapsed
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Material(
                    color: theme.colorScheme.surface.withAlpha(128),
                    borderRadius: BorderRadius.circular(
                      AppConfig.borderRadius / 3,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            if (event.type != EventTypes.Encrypted)
                              TextSpan(
                                text: event.calcLocalizedBodyFallback(
                                  MatrixLocals(L10n.of(context)),
                                ),
                              )
                            else ...[
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Avatar(
                                    name: event.senderFromMemoryOrFallback
                                        .calcDisplayname(),
                                    size: 14,
                                    mxContent: event
                                        .senderFromMemoryOrFallback
                                        .avatarUrl,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: L10n.of(context).messageNotDecryptable,
                              ),
                              if (!event.redacted)
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(7),
                                      onTap: () =>
                                          UtdDialog.show(context, event),
                                      child: Icon(
                                        Icons.info_outlined,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                            if (onExpand != null) ...[
                              const TextSpan(text: '\n'),
                              TextSpan(
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: theme.colorScheme.primary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = onExpand,
                                text: L10n.of(context).moreEvents,
                              ),
                            ],
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          decoration: event.redacted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
