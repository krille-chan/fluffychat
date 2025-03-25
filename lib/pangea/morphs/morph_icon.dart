import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/get_svg_link.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/utils/color_value.dart';

class MorphIcon extends StatelessWidget {
  const MorphIcon({
    super.key,
    required this.morphFeature,
    required this.morphTag,
    this.size,
    this.showTooltip = false,
  });

  final MorphFeaturesEnum morphFeature;
  final String? morphTag;
  final bool showTooltip;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    // debugPrint("MorphIcon: morphFeature: $morphFeature, morphTag: $morphTag");

    final ThemeData theme = Theme.of(context);

    final content = CustomizedSvg(
      svgUrl: getMorphSvgLink(
        morphFeature: morphFeature.name,
        morphTag: morphTag,
        context: context,
      ),
      colorReplacements: theme.brightness == Brightness.dark
          ? {
              "white": theme.cardColor.hexValue.toString(),
              "black": "white",
            }
          : {},
      errorIcon: Icon(morphFeature.fallbackIcon),
      width: size?.width,
      height: size?.height,
    );

    if (!showTooltip) {
      return content;
    }

    return Tooltip(
      message: morphTag == null
          ? morphFeature.getDisplayCopy(context)
          : getGrammarCopy(
              category: morphFeature.name,
              lemma: morphTag!,
              context: context,
            ),
      triggerMode: TooltipTriggerMode.tap,
      child: content,
    );
  }
}
