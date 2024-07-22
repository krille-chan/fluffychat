import 'dart:async';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/utils/on_chat_tap.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

/// A wrapper around ChatListItem to allow rebuilding on state changes.
/// Prevents having to rebuild the entire ChatList when a single item changes.
class ChatListItemWrapper extends StatefulWidget {
  final Room room;
  final bool activeChat;
  final void Function()? onForget;
  final String? filter;
  final ChatListController controller;

  final void Function()? onLongPress;
  final void Function()? onTap;

  const ChatListItemWrapper(
    this.room, {
    this.activeChat = false,
    this.onForget,
    this.filter,
    required this.controller,
    this.onLongPress,
    this.onTap,
    super.key,
  });

  @override
  ChatListItemWrapperState createState() => ChatListItemWrapperState();
}

class ChatListItemWrapperState extends State<ChatListItemWrapper> {
  StreamSubscription? stateSub;

  @override
  void initState() {
    super.initState();
    stateSub = widget.controller.selectionsStream.stream.listen((roomID) {
      if (roomID == widget.room.id) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    stateSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatListItem(
      widget.room,
      activeChat: widget.activeChat,
      selected: widget.controller.selectedRoomIds.contains(widget.room.id),
      onTap: widget.onTap ??
          (widget.controller.selectMode == SelectMode.select
              ? () => widget.controller.toggleSelection(widget.room.id)
              : () => onChatTap(widget.room, context)),
      onLongPress: widget.onLongPress ??
          () => widget.controller.toggleSelection(widget.room.id),
      onForget: widget.onForget,
      filter: widget.filter,
    );
  }
}
