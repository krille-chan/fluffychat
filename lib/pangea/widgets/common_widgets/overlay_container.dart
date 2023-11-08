import 'package:flutter/material.dart';

class OverlayContainer extends StatelessWidget {
  final Widget cardToShow;
  final Size cardSize;
  final Color? borderColor;

  const OverlayContainer({
    Key? key,
    required this.cardToShow,
    this.cardSize = const Size(300.0, 300.0),
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        maxWidth: cardSize.width,
        maxHeight: cardSize.height,
        minWidth: cardSize.width,
        minHeight: cardSize.height,
      ),
      //PTODO - position card above input/message
      // margin: const EdgeInsets.all(10),
      child: cardToShow,
    );
  }
}
