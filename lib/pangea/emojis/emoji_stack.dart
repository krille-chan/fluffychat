import 'package:flutter/material.dart';

class EmojiStack extends StatelessWidget {
  const EmojiStack({
    super.key,
    required List<String> emoji,
    this.style,
  }) : _emoji = emoji;

  final List<String> _emoji;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    // return Text(
    //   _emoji.first,
    //   style: style,
    // );
    return Text(
      _emoji.join(''),
      style: style,
    );
    // return Stack(
    //   children: [
    //     for (final emoji in _emoji)
    //       Positioned(
    //         left: _emoji.indexOf(emoji) * style!.fontSize! * 0.5,
    //         child: Text(
    //           emoji,
    //           style: style,
    //         ),
    //       ),
    //   ],
    // );
  }
}
