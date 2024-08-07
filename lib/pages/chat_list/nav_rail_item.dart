import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import '../../config/themes.dart';

class NaviRailItem extends StatefulWidget {
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
    super.key,
  });

  @override
  State<NaviRailItem> createState() => _NaviRailItemState();
}

class _NaviRailItemState extends State<NaviRailItem> {
  bool _hovered = false;

  void _onHover(bool hover) {
    if (hover == _hovered) return;
    setState(() {
      _hovered = hover;
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppConfig.borderRadius);
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
              width: widget.isSelected ? 4 : 0,
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
            child: AnimatedScale(
              scale: _hovered ? 1.2 : 1.0,
              duration: FluffyThemes.animationDuration,
              curve: FluffyThemes.animationCurve,
              child: Material(
                borderRadius: borderRadius,
                color: widget.isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surface,
                child: Tooltip(
                  message: widget.toolTip,
                  child: InkWell(
                    borderRadius: borderRadius,
                    onTap: widget.onTap,
                    onHover: _onHover,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: widget.isSelected
                          ? widget.selectedIcon ?? widget.icon
                          : widget.icon,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
