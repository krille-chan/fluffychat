import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'chat_list.dart';

class StartChatFloatingActionButton extends StatelessWidget {
  final ChatListController controller;

  const StartChatFloatingActionButton({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      reverse: !controller.scrolledToTop,
      transitionBuilder: (
        Widget child,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
          fillColor: Colors.transparent,
        );
      },
      layoutBuilder: (children) => Stack(
        alignment: Alignment.centerRight,
        children: children,
      ),
      child: FloatingActionButton.extended(
        key: ValueKey(controller.scrolledToTop),
        isExtended: controller.scrolledToTop,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () => VRouter.of(context).to('/newprivatechat'),
        icon: const Icon(CupertinoIcons.chat_bubble),
        label: Text(
          L10n.of(context)!.newChat,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
