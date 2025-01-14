import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';

class ConversationBotGameMasterInstructionsInput extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  // call this to update propagate changes to parents
  final void Function(BotOptionsModel) onChanged;

  const ConversationBotGameMasterInstructionsInput({
    super.key,
    required this.initialBotOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String gameMasterInstructions =
        initialBotOptions.textAdventureGameMasterInstructions ?? "";

    final TextEditingController textFieldController =
        TextEditingController(text: gameMasterInstructions);

    final GlobalKey<FormState> gameMasterInstructionsFormKey =
        GlobalKey<FormState>();

    void setBotTextAdventureGameMasterInstructionsAction() async {
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            L10n.of(context)
                .conversationBotTextAdventureZone_instructionPlaceholder,
          ),
          content: Form(
            key: gameMasterInstructionsFormKey,
            child: TextFormField(
              minLines: 1,
              maxLines: 10,
              maxLength: 1000,
              controller: textFieldController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  gameMasterInstructions = value;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field cannot be empty';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text(L10n.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(L10n.of(context).ok),
              onPressed: () {
                if (gameMasterInstructionsFormKey.currentState!.validate()) {
                  if (gameMasterInstructions !=
                      initialBotOptions.textAdventureGameMasterInstructions) {
                    initialBotOptions.textAdventureGameMasterInstructions =
                        gameMasterInstructions;
                    onChanged.call(initialBotOptions);
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      );
    }

    return ListTile(
      onTap: setBotTextAdventureGameMasterInstructionsAction,
      title: Text(
        initialBotOptions.textAdventureGameMasterInstructions ??
            L10n.of(context)
                .conversationBotTextAdventureZone_instructionPlaceholder,
      ),
    );
  }
}
