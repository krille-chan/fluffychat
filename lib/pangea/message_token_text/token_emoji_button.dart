import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class TokenEmojiButton extends StatefulWidget {
  final PangeaToken token;
  final String eventId;
  final String targetId;
  final VoidCallback onSelect;

  const TokenEmojiButton({
    super.key,
    required this.token,
    required this.eventId,
    required this.targetId,
    required this.onSelect,
  });

  @override
  State<TokenEmojiButton> createState() => TokenEmojiButtonState();
}

class TokenEmojiButtonState extends State<TokenEmojiButton>
    with TickerProviderStateMixin {
  final double buttonSize = 20.0;
  AnimationController? _controller;
  Animation<double>? _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: FluffyThemes.animationDuration,
    );

    _sizeAnimation = Tween<double>(
      begin: 0,
      end: buttonSize,
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeOut));

    _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emoji = widget.token.vocabConstructID.userSetEmoji.firstOrNull;
    if (_sizeAnimation != null) {
      return CompositedTransformTarget(
        link: MatrixState.pAnyState.layerLinkAndKey(widget.targetId).link,
        child: AnimatedBuilder(
          key: MatrixState.pAnyState.layerLinkAndKey(widget.targetId).key,
          animation: _sizeAnimation!,
          builder: (context, child) {
            return Container(
              height: _sizeAnimation!.value,
              width: _sizeAnimation!.value,
              alignment: Alignment.center,
              child: InkWell(
                onTap: widget.onSelect,
                borderRadius: BorderRadius.circular(99.0),
                child: emoji != null
                    ? Text(
                        emoji,
                        style: TextStyle(fontSize: buttonSize - 4.0),
                      )
                    : Icon(
                        Icons.add_reaction_outlined,
                        size: buttonSize - 4.0,
                      ),
              ),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
