import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'chat_list.dart';

class StartChatFloatingActionButton extends StatelessWidget {
  final ChatListController controller;

  const StartChatFloatingActionButton({Key? key, required this.controller})
      : super(key: key);

  void _onPressed(BuildContext context) {
    switch (controller.activeFilter) {
      case ActiveFilter.allChats:
      case ActiveFilter.messages:
        VRouter.of(context).to('/newprivatechat');
        break;
      case ActiveFilter.groups:
        VRouter.of(context).to('/newgroup');
        break;
      case ActiveFilter.spaces:
        VRouter.of(context).to('/newspace');
        break;
    }
  }

  IconData get icon {
    switch (controller.activeFilter) {
      case ActiveFilter.allChats:
      case ActiveFilter.messages:
        return Icons.edit_outlined;
      case ActiveFilter.groups:
        return Icons.group_add_outlined;
      case ActiveFilter.spaces:
        return Icons.workspaces_outlined;
    }
  }

  String getLabel(BuildContext context) {
    switch (controller.activeFilter) {
      case ActiveFilter.allChats:
      case ActiveFilter.messages:
        return L10n.of(context)!.newChat;
      case ActiveFilter.groups:
        return L10n.of(context)!.newGroup;
      case ActiveFilter.spaces:
        return L10n.of(context)!.newSpace;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: controller.scrolledToTop ? 144 : 64,
      child: controller.scrolledToTop
          ? FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () => _onPressed(context),
              icon: Icon(icon),
              label: Text(
                getLabel(context),
                overflow: TextOverflow.fade,
              ),
            )
          : FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () => _onPressed(context),
              child: Icon(icon),
            ),
    );
  }
}
