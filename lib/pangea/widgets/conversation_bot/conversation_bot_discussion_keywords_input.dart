import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotDiscussionKeywordsInput extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  // call this to update propagate changes to parents
  final void Function(BotOptionsModel) onChanged;

  const ConversationBotDiscussionKeywordsInput({
    super.key,
    required this.initialBotOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String discussionKeywords = initialBotOptions.discussionKeywords ?? "";

    final TextEditingController textFieldController =
        TextEditingController(text: discussionKeywords);

    void setBotDiscussionKeywordsAction() async {
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            L10n.of(context)!
                .conversationBotDiscussionZone_discussionKeywordsLabel,
          ),
          content: TextField(
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            controller: textFieldController,
            onChanged: (value) {
              discussionKeywords = value;
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
                if (discussionKeywords == "") return;
                if (discussionKeywords !=
                    initialBotOptions.discussionKeywords) {
                  initialBotOptions.discussionKeywords = discussionKeywords;
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
      onTap: setBotDiscussionKeywordsAction,
      title: Text(
        initialBotOptions.discussionKeywords ??
            L10n.of(context)!
                .conversationBotDiscussionZone_discussionKeywordsPlaceholder,
      ),
    );
  }
}
