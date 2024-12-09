import 'package:fluffychat/pangea/widgets/common/bot_face_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ContentIssueButton extends StatelessWidget {
  final bool isActive;
  final void Function(String) submitFeedback;

  const ContentIssueButton({
    super.key,
    required this.isActive,
    required this.submitFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8, // Slight opacity
      child: Tooltip(
        message: L10n.of(context).reportContentIssueTitle,
        child: IconButton(
          icon: const Icon(Icons.flag),
          iconSize: 16,
          onPressed: () {
            if (!isActive) {
              return;
            }
            final TextEditingController feedbackController =
                TextEditingController();

            showDialog(
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
          },
        ),
      ),
    );
  }
}
