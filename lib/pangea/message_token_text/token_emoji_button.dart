import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class TokenEmojiButton extends StatefulWidget {
  final PangeaToken? token;
  final String eventId;
  final String? targetId;
  final VoidCallback? onSelect;

  const TokenEmojiButton({
    super.key,
    required this.token,
    required this.eventId,
    this.targetId,
    this.onSelect,
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
    final eligible = widget.token?.lemma.saveVocab ?? false;
    final emoji = widget.token?.vocabConstructID.userSetEmoji.firstOrNull;
    if (_sizeAnimation != null) {
      final content = AnimatedBuilder(
        key: widget.targetId != null
            ? MatrixState.pAnyState.layerLinkAndKey(widget.targetId!).key
            : null,
        animation: _sizeAnimation!,
        builder: (context, child) {
          return Container(
            height: _sizeAnimation!.value,
            width: eligible ? _sizeAnimation!.value : 0,
            alignment: Alignment.center,
            child: eligible
                ? InkWell(
                    onTap: widget.onSelect,
                    borderRadius: BorderRadius.circular(99.0),
                    child: emoji != null
                        ? Text(
                            emoji,
                            style: TextStyle(fontSize: buttonSize - 4.0),
                            textScaler: TextScaler.noScaling,
                          )
                        : Icon(
                            Icons.add_reaction_outlined,
                            size: buttonSize - 4.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  )
                : null,
          );
        },
      );
      return widget.targetId != null
          ? CompositedTransformTarget(
              link:
                  MatrixState.pAnyState.layerLinkAndKey(widget.targetId!).link,
              child: content,
            )
          : content;
    }

    return const SizedBox.shrink();
  }
}
