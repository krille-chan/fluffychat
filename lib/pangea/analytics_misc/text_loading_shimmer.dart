import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import 'package:fluffychat/config/app_config.dart';

class TextLoadingShimmer extends StatelessWidget {
  final double width;
  const TextLoadingShimmer({
    super.key,
    this.width = 140.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.transparent, // Base color of the shimmer effect
      // for higlight, use white with 50 opacity
      highlightColor: Theme.of(context).colorScheme.primary.withAlpha(70),
      child: Container(
        height: AppConfig.messageFontSize * AppConfig.fontSizeFactor,
        width: width, // Width of the rectangle
        color: Theme.of(context)
            .colorScheme
            .primary, // Background color of the rectangle
      ),
    );
  }
}
