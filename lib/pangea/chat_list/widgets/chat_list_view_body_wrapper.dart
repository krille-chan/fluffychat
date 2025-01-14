import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// The ChatListBody often appears to load forever if prevBatch is null when it first loads.
/// This wrapper triggers a rebuild when the client has finished its first sync.
class ChatListViewBodyWrapper extends StatefulWidget {
  final ChatListController controller;

  const ChatListViewBodyWrapper({
    required this.controller,
    super.key,
  });

  @override
  State<ChatListViewBodyWrapper> createState() =>
      ChatListViewBodyWrapperState();
}

class ChatListViewBodyWrapperState extends State<ChatListViewBodyWrapper> {
  @override
  void initState() {
    final client = Matrix.of(context).client;
    if (client.prevBatch == null) {
      // SyncStatus.cleaningUp is added to the stream right after prevBatch is set
      // so wait for that to confirm that prevBatch is set
      client.onSyncStatus.stream
          .firstWhere((update) => update.status == SyncStatus.cleaningUp)
          .then((update) => setState(() {}));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChatListViewBody(widget.controller);
}
