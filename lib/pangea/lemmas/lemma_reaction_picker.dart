import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/lemma_emoji_choice_item.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaReactionPicker extends StatefulWidget {
  final ConstructIdentifier cId;
  final Event event;
  final ChatController controller;
  final double? iconSize;

  const LemmaReactionPicker({
    super.key,
    required this.cId,
    required this.event,
    required this.controller,
    this.iconSize,
  });

  @override
  LemmaReactionPickerState createState() => LemmaReactionPickerState();
}

class LemmaReactionPickerState extends State<LemmaReactionPicker> {
  List<String> displayEmoji = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void didUpdateWidget(LemmaReactionPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cId != widget.cId) {
      _refresh();
    }
  }

  void setEmoji(String emoji) {
    final allReactionEvents = widget.event.aggregatedEvents(
      widget.controller.timeline!,
      RelationshipTypes.reaction,
    );

    final client = Matrix.of(context).client;
    final reactionEvent = allReactionEvents.firstWhereOrNull(
      (e) =>
          e.senderId == client.userID &&
          e.content.tryGetMap('m.relates_to')?['key'] == emoji,
    );

    if (reactionEvent != null) {
      showFutureLoadingDialog(
        context: context,
        future: () => reactionEvent.redactEvent(),
      );
    } else {
      widget.controller.room.sendReaction(
        widget.event.eventId,
        emoji,
      );
    }
  }

  Future<void> _refresh() async {
    setState(() {
      loading = true;
      displayEmoji = [];
    });

    try {
      final info = await widget.cId.getLemmaInfo();
      displayEmoji = info.emoji;
    } catch (e, s) {
      ErrorHandler.logError(data: widget.cId.toJson(), e: e, s: s);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4.0,
        children: loading == false
            ? displayEmoji
                .map(
                  (emoji) => LemmaEmojiChoiceItem(
                    content: emoji,
                    onTap: () => setEmoji(emoji),
                  ),
                )
                .toList()
            : [1, 2, 3, 4, 5]
                .map(
                  (e) => const LemmaEmojiChoicePlaceholder(),
                )
                .toList(),
      ),
    );
  }
}
