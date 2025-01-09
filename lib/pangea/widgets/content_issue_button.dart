import 'package:fluffychat/utils/feedback_dialog.dart';
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

            showFeedbackDialog(context, submitFeedback);
          },
        ),
      ),
    );
  }
}
