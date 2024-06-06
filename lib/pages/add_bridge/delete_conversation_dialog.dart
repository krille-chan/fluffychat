import 'package:provider/provider.dart';
import 'package:tawkie/pages/add_bridge/add_bridge.dart';
import 'package:tawkie/pages/add_bridge/model/social_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/widgets/future_loading_dialog_custom.dart';
import 'package:tawkie/widgets/notifier_state.dart';

// ShowDialog to offer the user the option of cancelling the conversation with the bot after disconnection
Future<void> deleteConversationDialog(BuildContext context,
    SocialNetwork network, BotController controller) async {
  final connectionStateModel =
      Provider.of<ConnectionStateModel>(context, listen: false);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          L10n.of(context)!.bridgeBotDeleteConvTitle,
        ),
        content: Text(
          L10n.of(context)!.bridgeBotDeleteConvDescription,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(L10n.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              // Action to delete the conversation
              await showCustomLoadingDialog(
                context: context,
                future: () async {
                  await controller.deleteConversation(
                      context, network.chatBot, connectionStateModel);
                },
              );
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              L10n.of(context)!.delete,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
