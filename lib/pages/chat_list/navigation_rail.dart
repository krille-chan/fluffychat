import 'package:flutter/material.dart';

import 'package:animations/animations.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'navigation_rail_content.dart';
import 'spaces_drawer.dart';

final drawerKey = GlobalKey<State<AnimatedContainer>>();

class ChatListNavigationRail extends StatelessWidget {
  final ChatListController controller;

  const ChatListNavigationRail({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: FluffyThemes.getDisplayNavigationRail(context)!,
      builder: (context, drawerOpen, c) {
        final client = Matrix.of(context).client;
        final allSpaces = client.rooms.where((room) => room.isSpace);
        final rootSpaces = allSpaces
            .where(
              (space) => space.hasNotJoinedParentSpace(),
            )
            .toList();
        final destinations = controller.getNavigationDestinations(context);

        return LayoutBuilder(
          builder: (context, constraints) {
            final allowFullSizeDrawer = MediaQuery.of(context).size.width >=
                FluffyThemes.hugeScreenBreakpoint;
            drawerOpen &= allowFullSizeDrawer;
            return AnimatedContainer(
              key: drawerKey,
              width: drawerOpen ? 256 : 64,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: PageTransitionSwitcher(
                reverse: drawerOpen,
                transitionBuilder: (
                  Widget child,
                  Animation<double> primaryAnimation,
                  Animation<double> secondaryAnimation,
                ) {
                  return SharedAxisTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    child: child,
                  );
                },
                layoutBuilder: (children) => Stack(
                  alignment: Alignment.topLeft,
                  children: children,
                ),
                child: drawerOpen
                    ? SpacesDrawer(
                        key: const ValueKey(true),
                        rootSpaces: rootSpaces,
                        destinations: destinations,
                        controller: controller)
                    : NavigationRailContent(
                        key: const ValueKey(false),
                        allowFullSizeDrawer: allowFullSizeDrawer,
                        rootSpaces: rootSpaces,
                        destinations: destinations,
                        controller: controller,
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
