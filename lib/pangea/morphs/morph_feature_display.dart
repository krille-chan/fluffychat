import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';

class MorphFeatureDisplay extends StatelessWidget {
  const MorphFeatureDisplay({
    super.key,
    required String morphFeature,
    required String morphTag,
  })  : _morphFeature = morphFeature,
        _morphTag = morphTag;

  final String _morphFeature;
  final String _morphTag;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 32.0,
          height: 32.0,
          child: MorphIcon(
            morphFeature: _morphFeature,
            morphTag: _morphTag,
          ),
        ),
        const SizedBox(width: 10.0),
        Text(
          getGrammarCopy(
                category: _morphFeature,
                lemma: _morphTag,
                context: context,
              ) ??
              _morphTag,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
