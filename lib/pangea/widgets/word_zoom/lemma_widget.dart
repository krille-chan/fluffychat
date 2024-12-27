import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:flutter/material.dart';

class LemmaWidget extends StatelessWidget {
  final PangeaToken token;
  final VoidCallback onPressed;

  final String? lemma;
  final Function(String) setLemma;

  const LemmaWidget({
    super.key,
    required this.token,
    required this.onPressed,
    this.lemma,
    required this.setLemma,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: () {
          onPressed();
          if (lemma == null) {
            setLemma(token.lemma.text);
          }
        },
        icon: Text(token.xpEmoji),
      ),
    );
  }
}
