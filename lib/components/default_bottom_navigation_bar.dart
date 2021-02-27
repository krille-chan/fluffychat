import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class DefaultBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const DefaultBottomNavigationBar({Key key, this.currentIndex = 1})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (i) {
        if (i == currentIndex) return;
        switch (i) {
          case 0:
            AdaptivePageLayout.of(context)
                .pushNamedAndRemoveUntilIsFirst('/contacts');
            break;
          case 1:
            AdaptivePageLayout.of(context).pushNamedAndRemoveAllOthers('/');
            break;
          case 2:
            AdaptivePageLayout.of(context)
                .pushNamedAndRemoveUntilIsFirst('/discover');
            break;
        }
      },
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor: Theme.of(context).accentColor,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 0 ? Icons.people : Icons.people_outlined),
          label: L10n.of(context).friends,
        ),
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 1
              ? CupertinoIcons.chat_bubble_2_fill
              : CupertinoIcons.chat_bubble_2),
          label: L10n.of(context).messages,
        ),
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 2
              ? CupertinoIcons.compass_fill
              : CupertinoIcons.compass),
          label: L10n.of(context).discover,
        ),
      ],
    );
  }
}
