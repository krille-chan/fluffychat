import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pangea/chat_list/widgets/chat_list_view_body_wrapper.dart';
import 'package:fluffychat/pangea/spaces/widgets/space_floating_actions_buttons.dart';
import 'package:fluffychat/widgets/navigation_rail.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !controller.isSearchMode && controller.activeSpaceId == null,
      onPopInvokedWithResult: (pop, _) {
        if (pop) return;
        if (controller.activeSpaceId != null) {
          controller.clearActiveSpace();
          return;
        }
        if (controller.isSearchMode) {
          controller.cancelSearch();
          return;
        }
      },
      child: Row(
        children: [
          // #Pangea
          // if (FluffyThemes.isColumnMode(context) &&
          //     controller.widget.displayNavigationRail) ...[
          if (FluffyThemes.isColumnMode(context) ||
              AppConfig.displayNavigationRail) ...[
            // Pangea#
            SpacesNavigationRail(
              activeSpaceId: controller.activeSpaceId,
              onGoToChats: controller.clearActiveSpace,
              onGoToSpaceId: controller.setActiveSpace,
            ),
            Container(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ],
          Expanded(
            child: GestureDetector(
              onTap: FocusManager.instance.primaryFocus?.unfocus,
              excludeFromSemantics: true,
              behavior: HitTestBehavior.translucent,
              child: Scaffold(
                // #Pangea
                // body: ChatListViewBody(controller),
                body: ChatListViewBodyWrapper(controller: controller),
                // Pangea#
                floatingActionButton:
                    // #Pangea
                    // !controller.isSearchMode && controller.activeSpaceId == null
                    controller.activeFilter == ActiveFilter.spaces &&
                            controller.activeSpaceId == null &&
                            !controller.isSearchMode
                        ? const SpaceFloatingActionButtons()
                        : !controller.isSearchMode &&
                                controller.activeSpaceId == null
                            // Pangea#
                            ? FloatingActionButton.extended(
                                // #Pangea
                                // onPressed: () => context.go('/rooms/newprivatechat'),
                                onPressed: () => context.go(
                                  '/rooms/newgroup/${controller.activeSpaceId ?? ''}',
                                ),
                                // Pangea#
                                icon: const Icon(Icons.add_outlined),
                                label: Text(
                                  L10n.of(context).chat,
                                  overflow: TextOverflow.fade,
                                ),
                              )
                            : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
