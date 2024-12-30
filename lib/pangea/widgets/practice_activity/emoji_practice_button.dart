import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:flutter/material.dart';

class EmojiPracticeButton extends StatefulWidget {
  final PangeaToken token;
  final VoidCallback onPressed;

  final String? emoji;
  final Function(String) setEmoji;

  const EmojiPracticeButton({
    required this.token,
    required this.onPressed,
    this.emoji,
    required this.setEmoji,
    super.key,
  });

  @override
  EmojiPracticeButtonState createState() => EmojiPracticeButtonState();
}

class EmojiPracticeButtonState extends State<EmojiPracticeButton> {
  @override
  void didUpdateWidget(covariant EmojiPracticeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.token != oldWidget.token) {
      setState(() {});
    }
  }

  bool get _shouldDoActivity => widget.token.shouldDoActivity(
        a: ActivityTypeEnum.emoji,
        feature: null,
        tag: null,
      );

  @override
  Widget build(BuildContext context) {
    final emoji = widget.token.getEmoji();
    return SizedBox(
      height: 40,
      width: 40,
      child: _shouldDoActivity || emoji != null
          ? Opacity(
              opacity: _shouldDoActivity ? 0.5 : 1,
              child: IconButton(
                onPressed: () {
                  widget.onPressed();
                  if (widget.emoji == null && emoji != null) {
                    widget.setEmoji(emoji);
                  }
                },
                icon: emoji == null
                    ? const Icon(Icons.add_reaction_outlined)
                    : Text(emoji),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
