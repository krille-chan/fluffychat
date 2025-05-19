import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_audio_button.dart';

class WordTextWithAudioButton extends StatelessWidget {
  final String text;
  final String uniqueID;
  final TextStyle? style;
  final double? iconSize;
  final String langCode;

  const WordTextWithAudioButton({
    super.key,
    required this.text,
    required this.uniqueID,
    required this.langCode,
    this.style,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8.0,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 180),
          child: Text(
            text,
            style: style ?? Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        WordAudioButton(
          text: text,
          uniqueID: uniqueID,
          isSelected: false,
          baseOpacity: 1,
          langCode: langCode,
          padding: const EdgeInsets.only(left: 8.0),
        ),
      ],
    );
  }
}
