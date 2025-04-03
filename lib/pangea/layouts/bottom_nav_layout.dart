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

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/homepage');
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
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary.withAlpha(50),
          ),
        ),
      ),
      child: BottomNavigationBar(
        iconSize: 16.0,
        onTap: onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: L10n.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            activeIcon: const Icon(Icons.chat_bubble),
            label: L10n.of(context).chats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: L10n.of(context).settings,
          ),
        ],
      ),
    );
  }
}
