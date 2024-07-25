import 'dart:async';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_header.dart';
import 'package:flutter/material.dart';

/// A wrapper around ChatListHeader to allow rebuilding on state changes.
/// Prevents having to rebuild the entire ChatList when a single item changes.
class ChatListHeaderWrapper extends StatefulWidget {
  final ChatListController controller;
  final bool globalSearch;

  const ChatListHeaderWrapper({
    super.key,
    required this.controller,
    this.globalSearch = true,
  });

  @override
  ChatListHeaderWrapperState createState() => ChatListHeaderWrapperState();
}

class ChatListHeaderWrapperState extends State<ChatListHeaderWrapper> {
  StreamSubscription? stateSub;

  @override
  void initState() {
    super.initState();
    stateSub = widget.controller.selectionsStream.stream.listen((roomID) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    stateSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatListHeader(
      controller: widget.controller,
      globalSearch: widget.globalSearch,
    );
  }
}
