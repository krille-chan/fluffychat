import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_animation.dart';

class FillingStars extends StatefulWidget {
  final int rating;

  const FillingStars({
    super.key,
    required this.rating,
  });

  @override
  State<FillingStars> createState() => _FillingStarsState();
}

class _FillingStarsState extends State<FillingStars> {
  final List<bool> _isFilledList = List.filled(5, false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _animate());
  }

  Future<void> _animate() async {
    for (int i = 0; i < widget.rating; i++) {
      await Future.delayed(
          const Duration(milliseconds: choiceArrayAnimationDuration), () {
        if (mounted) {
          setState(() => _isFilledList[i] = true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: choiceArrayAnimationDuration),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: Icon(
            _isFilledList[index] ? Icons.star_rounded : Icons.star_rounded,
            key: ValueKey<bool>(_isFilledList[index]),
            color: _isFilledList[index]
                ? AppConfig.gold
                : Theme.of(context).cardColor.withAlpha(180),
            size: 32.0,
          ),
        );
      }),
    );
  }
}
