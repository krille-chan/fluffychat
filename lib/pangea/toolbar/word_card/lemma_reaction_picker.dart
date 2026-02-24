import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_misc/lemma_emoji_setter_mixin.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/lemmas/lemma_highlight_emoji_row.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaReactionPicker extends StatefulWidget with LemmaEmojiSetter {
  final Event? event;
  final ConstructIdentifier constructId;
  final String langCode;
  final bool enabled;
  final String? form;

  const LemmaReactionPicker({
    super.key,
    required this.constructId,
    required this.langCode,
    this.event,
    this.enabled = true,
    this.form,
  });

  @override
  LemmaReactionPickerState createState() => LemmaReactionPickerState();
}

class LemmaReactionPickerState extends State<LemmaReactionPicker> {
  ScaffoldMessengerState? messenger;
  StreamSubscription? _emojiSub;
  String? _selectedEmoji;

  @override
  void initState() {
    super.initState();
    _selectedEmoji = widget.constructId.userSetEmoji;
    _setEmojiSub();
  }

  @override
  void didUpdateWidget(LemmaReactionPicker oldWidget) {
    if (oldWidget.constructId != widget.constructId) {
      setState(() => _selectedEmoji = widget.constructId.userSetEmoji);
      _setEmojiSub();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    messenger?.hideCurrentSnackBar();
    messenger = null;
    _emojiSub?.cancel();
    super.dispose();
  }

  bool get _enabled =>
      (widget.langCode.split("-").first ==
          MatrixState.pangeaController.userController.userL2?.langCodeShort) &&
      widget.enabled;

  void _setEmojiSub() {
    _emojiSub?.cancel();
    _emojiSub = Matrix.of(context).analyticsDataService.updateDispatcher
        .lemmaUpdateStream(widget.constructId)
        .listen((update) => _setSelectedEmoji(update.emojis?.firstOrNull));
  }

  void _setSelectedEmoji(String? emoji) {
    setState(() => _selectedEmoji = emoji);
  }

  Event? _sentReaction(String emoji) {
    final userSentEmojis = widget.event!
        .aggregatedEvents(
          widget.event!.room.timeline!,
          RelationshipTypes.reaction,
        )
        .where((e) => e.senderId == Matrix.of(context).client.userID);

    return userSentEmojis.firstWhereOrNull(
      (e) => e.content.tryGetMap('m.relates_to')?['key'] == emoji,
    );
  }

  Future<void> _setEmoji(String emoji, String targetId) async {
    await widget.setLemmaEmoji(
      widget.constructId,
      widget.langCode,
      emoji,
      targetId,
      widget.event?.roomId,
      widget.event?.eventId,
      widget.form,
    );
    messenger = ScaffoldMessenger.of(context);
    widget.showLemmaEmojiSnackbar(
      messenger!,
      context,
      widget.constructId,
      emoji,
    );
  }

  Future<void> _sendOrRedactReaction(String emoji) async {
    if (widget.event?.room.timeline == null) return;
    try {
      final reactionEvent = _sentReaction(emoji);
      if (reactionEvent != null) {
        await reactionEvent.redactEvent();
        return;
      }

      await widget.event!.room.sendReaction(widget.event!.eventId, emoji);
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {'emoji': emoji, 'eventId': widget.event?.eventId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetId = "emoji-choice-item-${widget.constructId.lemma}-$hashCode";
    return LemmaHighlightEmojiRow(
      cId: widget.constructId,
      langCode: widget.langCode,
      targetId: targetId,
      onEmojiSelected: (emoji, target) => emoji != _selectedEmoji
          ? _setEmoji(emoji, target)
          : _sendOrRedactReaction(emoji),
      emoji: _selectedEmoji,
      messageInfo: widget.event?.content ?? {},
      selectedEmojiBadge:
          widget.event != null &&
              _selectedEmoji != null &&
              _sentReaction(_selectedEmoji!) == null
          ? const Icon(Icons.add_reaction, size: 12.0)
          : null,
      enabled: _enabled,
    );
  }
}
