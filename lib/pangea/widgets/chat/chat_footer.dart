import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_emoji_picker.dart';
import 'package:fluffychat/pages/chat/chat_input_row.dart';
import 'package:fluffychat/pages/chat/reactions_picker.dart';
import 'package:fluffychat/pages/chat/reply_display.dart';
import 'package:fluffychat/pangea/choreographer/widgets/it_bar.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import 'package:flutter/material.dart';

class ChatFooter extends StatefulWidget {
  final ChatController controller;
  const ChatFooter(
    this.controller, {
    super.key,
  });

  @override
  ChatFooterState createState() => ChatFooterState();
}

class ChatFooterState extends State<ChatFooter> {
  double? height;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        height = context.size!.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (_) {
        if (height != context.size!.height) {
          height = context.size!.height;
          widget.controller.updateView();
        }
        return true;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ConnectionStatusHeader(),
          ITBar(
            choreographer: widget.controller.choreographer,
          ),
          ReactionsPicker(widget.controller),
          ReplyDisplay(widget.controller),
          ChatInputRow(widget.controller),
          ChatEmojiPicker(widget.controller),
        ],
      ),
    );
  }
}
