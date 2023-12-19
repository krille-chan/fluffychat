import 'dart:core';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class StartChatFloatingActionButton extends StatelessWidget {
  final ActiveFilter activeFilter;
  final ValueNotifier<bool> scrolledToTop;
  final bool roomsIsEmpty;
  // #Pangea
  final ChatListController controller;
  // Pangea#

  const StartChatFloatingActionButton({
    super.key,
    required this.activeFilter,
    required this.scrolledToTop,
    required this.roomsIsEmpty,
    // #Pangea
    required this.controller,
    // Pangea#
  });

  void _onPressed(BuildContext context) {
    //#Pangea
    if (controller.activeSpaceId != null) {
      context.go('/rooms/newgroup/${controller.activeSpaceId ?? ''}');
      return;
    }
    //Pangea#
    switch (activeFilter) {
      case ActiveFilter.allChats:
      case ActiveFilter.messages:
      // #Pangea
      // context.go('/rooms/newprivatechat');
      // break;
      // Pangea#
      case ActiveFilter.groups:
        // #Pangea
        // context.go('/rooms/newgroup');
        context.go('/rooms/newgroup/${controller.activeSpaceId ?? ''}');
        // Pangea#
        break;
      case ActiveFilter.spaces:
        context.go('/rooms/newspace');
        break;
    }
  }

  IconData get icon {
    // #Pangea
    if (controller.activeSpaceId != null) {
      return Icons.group_add_outlined;
    }
    // Pangea#
    switch (activeFilter) {
      case ActiveFilter.allChats:
      case ActiveFilter.messages:
      // #Pangea
      // return Icons.add_outlined;
      // Pangea#
      case ActiveFilter.groups:
        return Icons.group_add_outlined;
      case ActiveFilter.spaces:
        return Icons.workspaces_outlined;
    }
  }

  String getLabel(BuildContext context) {
    // #Pangea
    if (controller.activeSpaceId != null) {
      return L10n.of(context)!.newGroup;
    }
    // Pangea#
    switch (activeFilter) {
      case ActiveFilter.allChats:
      case ActiveFilter.messages:
        return roomsIsEmpty
            ? L10n.of(context)!.startFirstChat
            : L10n.of(context)!.newChat;
      case ActiveFilter.groups:
        return L10n.of(context)!.newGroup;
      case ActiveFilter.spaces:
        return L10n.of(context)!.newSpace;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: scrolledToTop,
      builder: (context, scrolledToTop, _) => AnimatedSize(
        duration: FluffyThemes.animationDuration,
        curve: FluffyThemes.animationCurve,
        clipBehavior: Clip.none,
        child: scrolledToTop
            ? FloatingActionButton.extended(
                onPressed: () => _onPressed(context),
                icon: Icon(icon),
                label: Text(
                  getLabel(context),
                  overflow: TextOverflow.fade,
                ),
              )
            : FloatingActionButton(
                onPressed: () => _onPressed(context),
                child: Icon(icon),
              ),
      ),
    );
  }
}
