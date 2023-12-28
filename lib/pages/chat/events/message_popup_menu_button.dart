import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

class MessagePopupMenuButton extends StatelessWidget {
  final Event event;
  final double height;
  final void Function() onReply;
  final void Function() onSelect;

  const MessagePopupMenuButton({
    required this.event,
    required this.onReply,
    required this.onSelect,
    this.height = 38,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: height,
      height: height,
      child: PopupMenuButton(
        iconSize: height / 2,
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: onSelect,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outlined),
                const SizedBox(width: 16),
                Text(L10n.of(context)!.select),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: onReply,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.reply_outlined),
                const SizedBox(width: 16),
                Text(L10n.of(context)!.reply),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
