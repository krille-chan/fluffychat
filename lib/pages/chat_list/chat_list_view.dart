import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../widgets/matrix.dart';
import 'chat_list_body.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object?>(
      stream: Matrix.of(context).onShareContentChanged.stream,
      builder: (_, __) {
        final selectMode = controller.selectMode;
        return PopScope(
          canPop: controller.selectMode == SelectMode.normal &&
              !controller.isSearchMode &&
              controller.activeFilter == ActiveFilter.allChats,
          onPopInvoked: (pop) async {
            if (pop) return;
            final selMode = controller.selectMode;
            if (controller.isSearchMode) {
              controller.cancelSearch();
              return;
            }
            if (selMode != SelectMode.normal) {
              controller.cancelAction();
              return;
            }
          },
          child: GestureDetector(
            onTap: FocusManager.instance.primaryFocus?.unfocus,
            excludeFromSemantics: true,
            behavior: HitTestBehavior.translucent,
            child: Scaffold(
              body: ChatListViewBody(controller),
              floatingActionButton:
                  // #Pangea
                  // KeyBoardShortcuts(
                  //   keysToPress: {
                  //     LogicalKeyboardKey.controlLeft,
                  //     LogicalKeyboardKey.keyN,
                  //   },
                  //   onKeysPressed: () => context.go('/rooms/newprivatechat'),
                  //   helpLabel: L10n.of(context)!.newChat,
                  //   child:
                  // Pangea#
                  selectMode == SelectMode.normal && !controller.isSearchMode
                      ? FloatingActionButton.extended(
                          onPressed: controller.addChatAction,
                          icon: const Icon(Icons.add_outlined),
                          label: Text(
                            L10n.of(context)!.chat,
                            overflow: TextOverflow.fade,
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
