import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/word_zoom_activity_button.dart';
import 'package:flutter/material.dart';

class LemmaWidget extends StatelessWidget {
  final PangeaToken token;
  final VoidCallback onPressed;
  final bool isSelected;

  const LemmaWidget({
    super.key,
    required this.token,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return WordZoomActivityButton(
      icon: Text(token.xpEmoji),
      isSelected: isSelected,
      onPressed: onPressed,
    );
  }
}
