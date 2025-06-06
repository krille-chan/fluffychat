import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/lemma_emoji_choice_item.dart';
import 'package:flutter/material.dart';

class LemmaReactionPicker extends StatefulWidget {
  final ConstructIdentifier cId;
  final ChatController controller;
  final double? iconSize;

  const LemmaReactionPicker({
    super.key,
    required this.cId,
    required this.controller,
    this.iconSize,
  });

  @override
  LemmaReactionPickerState createState() => LemmaReactionPickerState();
}

class LemmaReactionPickerState extends State<LemmaReactionPicker> {
  List<String> displayEmoji = [];

  @override
  void initState() {
    super.initState();
    widget.cId.getLemmaInfo().then((info) {
      setState(() => displayEmoji = info.emoji);
    }).catchError((e, s) {
      ErrorHandler.logError(data: widget.cId.toJson(), e: e, s: s);
    });
  }

  // @override
  // didUpdateWidget(LemmaReactionPicker oldWidget) {
  //   if (oldWidget.isSelected != widget.isSelected ||
  //       widget.cId.userSetEmoji != oldWidget.cId.userSetEmoji) {
  //     setState(() => displayEmoji = widget.cId.userSetEmoji.firstOrNull);
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  void setEmoji(String emoji) => widget.controller.sendEmojiAction(emoji);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: displayEmoji
            .map(
              (emoji) => LemmaEmojiChoiceItem(
                content: emoji,
                onTap: () => setEmoji(emoji),
              ),
            )
            .toList(),
      ),
    );
  }
}
