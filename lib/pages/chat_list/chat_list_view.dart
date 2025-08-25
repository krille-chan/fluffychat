import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pangea/chat_list/widgets/chat_list_view_body_wrapper.dart';
import 'package:fluffychat/pangea/onboarding/onboarding.dart';
import 'package:fluffychat/pangea/onboarding/onboarding_steps_enum.dart';

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
          // if (FluffyThemes.isColumnMode(context) ||
          //     AppConfig.displayNavigationRail) ...[
          //   SpacesNavigationRail(
          //     activeSpaceId: controller.activeSpaceId,
          //     onGoToChats: controller.clearActiveSpace,
          //     onGoToSpaceId: controller.setActiveSpace,
          //   ),
          //   Container(
          //     color: Theme.of(context).dividerColor,
          //     width: 1,
          //   ),
          // ],
          // Pangea#
          Expanded(
            child: GestureDetector(
              onTap: FocusManager.instance.primaryFocus?.unfocus,
              excludeFromSemantics: true,
              behavior: HitTestBehavior.translucent,
              child: Scaffold(
                // #Pangea
                // body: ChatListViewBody(controller),
                body: ChatListViewBodyWrapper(controller: controller),
                // floatingActionButton: !controller.isSearchMode &&
                //         controller.activeSpaceId == null
                floatingActionButton: !controller.isSearchMode &&
                        controller.activeSpaceId == null &&
                        OnboardingController.complete(
                          OnboardingStepsEnum.chatWithBot,
                        )
                    // Pangea#
                    ? FloatingActionButton.extended(
                        onPressed: () => context.go('/rooms/newprivatechat'),
                        // #Pangea
                        icon: const Icon(Icons.chat_bubble_outline),
                        // icon: const Icon(Icons.add_outlined),
                        // Pangea#
                        label: Text(
                          // #Pangea
                          L10n.of(context).directMessage,
                          // L10n.of(context).chat,
                          // Pangea#
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
