import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';

class MorphTagDisplay extends StatelessWidget {
  const MorphTagDisplay({
    super.key,
    required String morphFeature,
    required this.textColor,
  }) : _morphFeature = morphFeature;

  final String _morphFeature;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24.0,
          height: 24.0,
          child: MorphIcon(morphFeature: _morphFeature, morphTag: null),
        ),
        const SizedBox(width: 10.0),
        Text(
          _morphFeature.toLowerCase() == "other"
              ? L10n.of(context).other
              : ConstructTypeEnum.morph.getDisplayCopy(
                    _morphFeature,
                    context,
                  ) ??
                  _morphFeature,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
        ),
      ],
    );
  }
}
