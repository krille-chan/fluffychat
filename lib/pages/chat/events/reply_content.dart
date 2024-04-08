import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import '../../../config/app_config.dart';

class ReplyContent extends StatelessWidget {
  final Event replyEvent;
  final bool ownMessage;
  final Timeline? timeline;
  final Color? backgroundColor;

  const ReplyContent(
    this.replyEvent, {
    this.ownMessage = false,
    super.key,
    this.timeline,
    this.backgroundColor,
  });

  static const BorderRadius borderRadius = BorderRadius.only(
    topRight: Radius.circular(AppConfig.borderRadius / 2),
    bottomRight: Radius.circular(AppConfig.borderRadius / 2),
  );

  @override
  Widget build(BuildContext context) {
    final timeline = this.timeline;
    final displayEvent =
        timeline != null ? replyEvent.getDisplayEvent(timeline) : replyEvent;
    final fontSize = AppConfig.messageFontSize * AppConfig.fontSizeFactor;
    final color = ownMessage
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.primary;

    return Material(
      color: backgroundColor ??
          Theme.of(context)
              .colorScheme
              .background
              .withOpacity(ownMessage ? 0.2 : 0.33),
      borderRadius: borderRadius,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 3,
            height: fontSize * 2 + 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<User?>(
                  future: displayEvent.fetchSenderUser(),
                  builder: (context, snapshot) {
                    return Text(
                      '${snapshot.data?.calcDisplayname() ?? displayEvent.senderFromMemoryOrFallback.calcDisplayname()}:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: fontSize,
                      ),
                    );
                  },
                ),
                Text(
                  displayEvent.calcLocalizedBodyFallback(
                    MatrixLocals(L10n.of(context)!),
                    withSenderNamePrefix: false,
                    hideReply: true,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: ownMessage
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onBackground,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
