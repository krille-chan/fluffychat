import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
import 'package:fluffychat/pangea/morphs/get_icon_for_morph_feature.dart';
import 'package:fluffychat/pangea/morphs/get_svg_link.dart';
import 'package:fluffychat/utils/color_value.dart';

class MorphIcon extends StatelessWidget {
  const MorphIcon({
    super.key,
    required this.morphFeature,
    required this.morphTag,
  });

  final String morphFeature;
  final String? morphTag;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return CustomizedSvg(
      svgUrl: getMorphSvgLink(
        morphFeature: morphFeature,
        morphTag: morphTag,
        context: context,
      ),
      colorReplacements: theme.brightness == Brightness.dark
          ? {
              "white": theme.cardColor.hexValue.toString(),
              "black": "white",
            }
          : {},
      errorIcon: Icon(getIconForMorphFeature(morphFeature)),
    );
  }
}
