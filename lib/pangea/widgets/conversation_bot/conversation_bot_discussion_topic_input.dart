import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotDiscussionTopicInput extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  // call this to update propagate changes to parents
  final void Function(BotOptionsModel) onChanged;

  const ConversationBotDiscussionTopicInput({
    super.key,
    required this.initialBotOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String discussionTopic = initialBotOptions.discussionTopic ?? "";

    final TextEditingController textFieldController =
        TextEditingController(text: discussionTopic);

    void setBotDiscussionTopicAction() async {
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            L10n.of(context)!
                .conversationBotDiscussionZone_discussionTopicLabel,
          ),
          content: TextField(
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            controller: textFieldController,
            onChanged: (value) {
              discussionTopic = value;
            },
          ),
          actions: [
            TextButton(
              child: Text(L10n.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(L10n.of(context)!.ok),
              onPressed: () {
                if (discussionTopic == "") return;
                if (discussionTopic != initialBotOptions.discussionTopic) {
                  initialBotOptions.discussionTopic = discussionTopic;
                  onChanged.call(initialBotOptions);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      );
    }

    return ListTile(
      onTap: setBotDiscussionTopicAction,
      title: Text(
        initialBotOptions.discussionTopic ??
            L10n.of(context)!
                .conversationBotDiscussionZone_discussionTopicPlaceholder,
      ),
    );
  }
}
