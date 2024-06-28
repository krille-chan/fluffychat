import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotCustomSystemPromptInput extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  // call this to update propagate changes to parents
  final void Function(BotOptionsModel) onChanged;

  const ConversationBotCustomSystemPromptInput({
    super.key,
    required this.initialBotOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String customSystemPrompt = initialBotOptions.customSystemPrompt ?? "";

    final TextEditingController textFieldController =
        TextEditingController(text: customSystemPrompt);

    void setBotCustomSystemPromptAction() async {
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            L10n.of(context)!.conversationBotCustomZone_customSystemPromptLabel,
          ),
          content: TextField(
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            controller: textFieldController,
            onChanged: (value) {
              customSystemPrompt = value;
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
                if (customSystemPrompt == "") return;
                if (customSystemPrompt !=
                    initialBotOptions.customSystemPrompt) {
                  initialBotOptions.customSystemPrompt = customSystemPrompt;
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
      onTap: setBotCustomSystemPromptAction,
      title: Text(
        initialBotOptions.customSystemPrompt ??
            L10n.of(context)!
                .conversationBotCustomZone_customSystemPromptPlaceholder,
      ),
    );
  }
}
