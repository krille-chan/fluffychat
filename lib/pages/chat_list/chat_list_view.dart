import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import '../../widgets/matrix.dart';
import 'chat_list_body.dart';
import 'chat_list_header.dart';
import 'start_chat_fab.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {Key? key}) : super(key: key);

  List<NavigationDestination> getNavigationDestinations(BuildContext context) =>
      [
        if (AppConfig.separateChatTypes) ...[
          NavigationDestination(
            icon: const Icon(Icons.group_outlined),
            label: L10n.of(context)!.groups,
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            label: L10n.of(context)!.messages,
          ),
        ] else
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble),
            label: L10n.of(context)!.allChats,
          ),
        if (controller.spaces.isNotEmpty)
          const NavigationDestination(
            icon: Icon(Icons.group_work_outlined),
            label: 'Spaces',
          ),
      ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object?>(
      stream: Matrix.of(context).onShareContentChanged.stream,
      builder: (_, __) {
        final selectMode = controller.selectMode;
        return VWidgetGuard(
          onSystemPop: (redirector) async {
            final selMode = controller.selectMode;
            if (selMode != SelectMode.normal) controller.cancelAction();
            if (selMode == SelectMode.select) redirector.stopRedirection();
          },
          child: Row(
            children: [
              if (FluffyThemes.isColumnMode(context) &&
                  FluffyThemes.getDisplayNavigationRail(context)) ...[
                NavigationRail(
                  selectedIndex: controller.selectedIndex,
                  onDestinationSelected: controller.onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: getNavigationDestinations(context)
                      .map(
                        (destination) => NavigationRailDestination(
                          icon: destination.icon,
                          label: Text(destination.label),
                        ),
                      )
                      .toList(),
                ),
                Container(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ],
              Expanded(
                child: Scaffold(
                  appBar: ChatListHeader(controller: controller),
                  body: ChatListViewBody(controller),
                  bottomNavigationBar: controller.displayNavigationBar
                      ? NavigationBar(
                          selectedIndex: controller.selectedIndex,
                          onDestinationSelected:
                              controller.onDestinationSelected,
                          destinations: getNavigationDestinations(context),
                        )
                      : null,
                  floatingActionButton: selectMode == SelectMode.normal
                      ? KeyBoardShortcuts(
                          keysToPress: {
                            LogicalKeyboardKey.controlLeft,
                            LogicalKeyboardKey.keyN
                          },
                          onKeysPressed: () =>
                              VRouter.of(context).to('/newprivatechat'),
                          helpLabel: L10n.of(context)!.newChat,
                          child: StartChatFloatingActionButton(
                              controller: controller),
                        )
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum ChatListPopupMenuItemActions {
  createGroup,
  createSpace,
  discover,
  setStatus,
  inviteContact,
  settings,
}
