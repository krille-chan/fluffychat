import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import '../../config/themes.dart';

class NaviRailItem extends StatelessWidget {
  final String toolTip;
  final bool isSelected;
  final void Function() onTap;
  final Widget icon;
  final Widget? selectedIcon;

  const NaviRailItem({
    required this.toolTip,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    this.selectedIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 64,
      child: Stack(
        children: [
          Positioned(
            top: 16,
            bottom: 16,
            left: 0,
            child: AnimatedContainer(
              width: isSelected ? 4 : 0,
              duration: FluffyThemes.animationDuration,
              curve: FluffyThemes.animationCurve,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(90),
                  bottomRight: Radius.circular(90),
                ),
              ),
            ),
          ),
          Center(
            child: IconButton(
              onPressed: onTap,
              tooltip: toolTip,
              icon: Material(
                borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.background,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: isSelected ? selectedIcon ?? icon : icon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
