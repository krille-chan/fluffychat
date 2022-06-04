import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/spaces_bottom_bar.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import '../../widgets/matrix.dart';
import 'chat_list_body.dart';
import 'chat_list_header.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object?>(
      stream: Matrix.of(context).onShareContentChanged.stream,
      builder: (_, __) {
        final selectMode = controller.selectMode;
        final showSpaces = controller.spacesEntries.length > 1 &&
            controller.selectedRoomIds.isEmpty;
        return VWidgetGuard(
          onSystemPop: (redirector) async {
            final selMode = controller.selectMode;
            if (selMode != SelectMode.normal) controller.cancelAction();
            if (selMode == SelectMode.select) redirector.stopRedirection();
          },
          child: Scaffold(
            appBar: ChatListHeader(controller: controller),
            body: LayoutBuilder(
              builder: (context, size) {
                controller.snappingSheetContainerSize = size;
                return SnappingSheet(
                  key: ValueKey(Matrix.of(context).client.userID.toString() +
                      showSpaces.toString()),
                  controller: controller.snappingSheetController,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        height: controller.showChatBackupBanner ? 54 : 0,
                        duration: const Duration(milliseconds: 300),
                        clipBehavior: Clip.hardEdge,
                        curve: Curves.bounceInOut,
                        decoration: const BoxDecoration(),
                        child: Material(
                          color: Theme.of(context).colorScheme.surface,
                          child: ListTile(
                            leading: Image.asset(
                              'assets/backup.png',
                              fit: BoxFit.contain,
                              width: 44,
                            ),
                            title: Text(L10n.of(context)!.setupChatBackupNow),
                            trailing: const Icon(Icons.chevron_right_outlined),
                            onTap: controller.firstRunBootstrapAction,
                          ),
                        ),
                      ),
                      Expanded(child: ChatListViewBody(controller)),
                    ],
                  ),
                  initialSnappingPosition: showSpaces
                      ? const SnappingPosition.pixels(
                          positionPixels: kSpacesBottomBarHeight)
                      : const SnappingPosition.factor(positionFactor: 0.0),
                  snappingPositions: showSpaces
                      ? const [
                          SnappingPosition.pixels(
                              positionPixels: kSpacesBottomBarHeight),
                          SnappingPosition.factor(positionFactor: 0.5),
                          SnappingPosition.factor(positionFactor: 0.9),
                        ]
                      : [const SnappingPosition.factor(positionFactor: 0.0)],
                  sheetBelow: showSpaces
                      ? SnappingSheetContent(
                          childScrollController:
                              controller.snappingSheetScrollContentController,
                          draggable: true,
                          child: SpacesBottomBar(controller),
                        )
                      : null,
                );
              },
            ),
            floatingActionButton: selectMode == SelectMode.normal
                ? Padding(
                    padding: showSpaces
                        ? const EdgeInsets.only(bottom: 64.0)
                        : const EdgeInsets.all(0),
                    child: KeyBoardShortcuts(
                      child: FloatingActionButton.extended(
                        isExtended: controller.scrolledToTop,
                        onPressed: () =>
                            VRouter.of(context).to('/newprivatechat'),
                        icon: const Icon(CupertinoIcons.chat_bubble),
                        label: Text(L10n.of(context)!.newChat),
                      ),
                      keysToPress: {
                        LogicalKeyboardKey.controlLeft,
                        LogicalKeyboardKey.keyN
                      },
                      onKeysPressed: () =>
                          VRouter.of(context).to('/newprivatechat'),
                      helpLabel: L10n.of(context)!.newChat,
                    ),
                  )
                : null,
            bottomNavigationBar: const SafeArea(
              child: ConnectionStatusHeader(),
            ),
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
