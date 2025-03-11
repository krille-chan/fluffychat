import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class BottomNavLayout extends StatelessWidget {
  final Widget mainView;

  const BottomNavLayout({
    super.key,
    required this.mainView,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mainView,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int get selectedIndex {
    final route = GoRouterState.of(context).fullPath.toString();
    if (route.contains("settings")) {
      return 2;
    }
    if (route.contains('homepage')) {
      return 0;
    }
    return 1;
  }

  @override
  void didUpdateWidget(covariant BottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("didUpdateWidget");
  }

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/rooms/homepage');
        break;
      case 1:
        context.go('/rooms');
        break;
      case 2:
        context.go('/rooms/settings');
        break;
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavItem(
            controller: this,
            icon: Icons.home,
            label: L10n.of(context).home,
            index: 0,
          ),
          BottomNavItem(
            controller: this,
            icon: Icons.chat_bubble_outline,
            label: L10n.of(context).chats,
            index: 1,
          ),
          BottomNavItem(
            controller: this,
            icon: Icons.settings,
            label: L10n.of(context).settings,
            index: 2,
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final BottomNavBarState controller;
  final int index;
  final IconData icon;
  final String label;

  const BottomNavItem({
    required this.controller,
    required this.index,
    required this.icon,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.selectedIndex == index;
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onItemTapped(index),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.secondaryContainer,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSecondaryContainer,
              ),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
