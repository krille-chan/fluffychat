import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_drawer.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import '../../widgets/matrix.dart';
import 'chat_list_body.dart';
import 'chat_list_header.dart';
import 'start_chat_fab.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {Key? key}) : super(key: key);

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
          child: Scaffold(
            appBar: ChatListHeader(controller: controller),
            body: ChatListViewBody(controller),
            drawer: ChatListDrawer(controller),
            bottomNavigationBar: const ConnectionStatusHeader(),
            floatingActionButton: selectMode == SelectMode.normal
                ? KeyBoardShortcuts(
                    child:
                        StartChatFloatingActionButton(controller: controller),
                    keysToPress: {
                      LogicalKeyboardKey.controlLeft,
                      LogicalKeyboardKey.keyN
                    },
                    onKeysPressed: () =>
                        VRouter.of(context).to('/newprivatechat'),
                    helpLabel: L10n.of(context)!.newChat,
                  )
                : null,
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
