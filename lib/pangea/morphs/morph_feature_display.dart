import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';

class MorphFeatureDisplay extends StatelessWidget {
  const MorphFeatureDisplay({
    super.key,
    required this.morphFeature,
  });

  final MorphFeaturesEnum morphFeature;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24.0,
          height: 24.0,
          child: MorphIcon(
            morphFeature: morphFeature,
            morphTag: null,
          ),
        ),
        const SizedBox(width: 10.0),
        Text(
          morphFeature.getDisplayCopy(context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
