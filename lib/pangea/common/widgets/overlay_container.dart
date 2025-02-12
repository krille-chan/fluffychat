import 'package:flutter/material.dart';

class OverlayContainer extends StatelessWidget {
  final Widget cardToShow;
  final Color? borderColor;
  final double maxHeight;
  final double maxWidth;
  final bool isScrollable;

  const OverlayContainer({
    super.key,
    required this.cardToShow,
    this.borderColor,
    required this.maxHeight,
    required this.maxWidth,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [cardToShow],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // color: Colors.purple,
        border: Border.all(
          width: 2,
          color: borderColor ?? Theme.of(context).colorScheme.primary,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        minHeight: 100,
        minWidth: 100,
      ),
      child: isScrollable ? SingleChildScrollView(child: content) : content,
    );
  }
}
