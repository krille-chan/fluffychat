import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import '../pangea/bot/widgets/bot_face_svg.dart';

Future<dynamic> showFeedbackDialog(
  BuildContext context,
  Widget offendingContent,
  void Function(String) submitFeedback,
) {
  final TextEditingController feedbackController = TextEditingController();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          L10n.of(context).reportContentIssueTitle,
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BotFace(
                  width: 60,
                  expression: BotExpression.addled,
                ),
                const SizedBox(height: 10),
                Text(L10n.of(context).reportContentIssueDescription),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: AppConfig.warning,
                    ),
                  ),
                  child: offendingContent,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: feedbackController,
                  decoration: InputDecoration(
                    labelText: L10n.of(context).feedback,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(L10n.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // Call the additional callback function
              submitFeedback(feedbackController.text);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(L10n.of(context).submit),
          ),
        ],
      );
    },
  );
}
