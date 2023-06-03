import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import '../../config/themes.dart';
import 'chat_list.dart';

class StartChatFloatingActionButton extends StatelessWidget {
  final ActiveFilter activeFilter;
  final ValueNotifier<bool> scrolledToTop;
  final bool roomsIsEmpty;

  const StartChatFloatingActionButton({
    Key? key,
    required this.activeFilter,
    required this.scrolledToTop,
    required this.roomsIsEmpty,
  }) : super(key: key);

  void _onPressed(BuildContext context) {
    switch (activeFilter) {
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
    switch (activeFilter) {
      case ActiveFilter.allChats:
      case ActiveFilter.messages:
        return Icons.add_outlined;
      case ActiveFilter.groups:
        return Icons.group_add_outlined;
      case ActiveFilter.spaces:
        return Icons.workspaces_outlined;
    }
  }

  String getLabel(BuildContext context) {
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
