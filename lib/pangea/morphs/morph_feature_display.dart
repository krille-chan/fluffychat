import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:flutter/material.dart';

class MorphFeatureDisplay extends StatelessWidget {
  MorphFeatureDisplay({
    super.key,
    required String morphFeature,
  }) : _morphFeature = MorphFeaturesEnumExtension.fromString(morphFeature);

  final MorphFeaturesEnum _morphFeature;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24.0,
          height: 24.0,
          child: MorphIcon(
            morphFeature: _morphFeature,
            morphTag: null,
          ),
        ),
        const SizedBox(width: 10.0),
        Text(
          _morphFeature.getDisplayCopy(context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
