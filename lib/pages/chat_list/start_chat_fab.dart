import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';

class StartChatFab extends StatelessWidget {
  const StartChatFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'start_chat_fab',
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      onPressed: () => context.go('/rooms/newprivatechat'),
      tooltip: L10n.of(context).newChat,
      child: const Icon(Icons.edit_square),
    );
  }
}
