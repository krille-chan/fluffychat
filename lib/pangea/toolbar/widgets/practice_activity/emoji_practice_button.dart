import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_zoom_activity_button.dart';

class EmojiPracticeButton extends StatelessWidget {
  final PangeaToken token;
  final VoidCallback onPressed;
  final bool isSelected;

  const EmojiPracticeButton({
    required this.token,
    required this.onPressed,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = token.getEmoji();
    return emoji != null
        ? SizedBox(
            width: 40,
            child: WordZoomActivityButton(
              icon: Text(emoji),
              isSelected: isSelected,
              onPressed: onPressed,
            ),
          )
        : const SizedBox(width: 40);
  }
}
