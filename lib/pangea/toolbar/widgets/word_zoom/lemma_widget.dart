import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics/enums/lemma_category_enum.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';

class LemmaWidget extends StatelessWidget {
  final PangeaToken token;

  const LemmaWidget({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              token.lemma.text,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 20,
            height: 20,
            child: CustomizedSvg(
              svgUrl: token.lemmaXPCategory.svgURL,
              colorReplacements: const {},
              errorIcon: Text(token.xpEmoji),
            ),
          ),
        ],
      ),
    );
  }
}
