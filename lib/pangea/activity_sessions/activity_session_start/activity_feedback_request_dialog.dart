import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';

class ActivityFeedbackRequestDialog extends StatefulWidget {
  const ActivityFeedbackRequestDialog({super.key});

  @override
  State<ActivityFeedbackRequestDialog> createState() =>
      ActivityFeedbackRequestDialogState();
}

class ActivityFeedbackRequestDialogState
    extends State<ActivityFeedbackRequestDialog> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _feedbackController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SizedBox(
          width: 325.0,
          child: Column(
            spacing: 20.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        L10n.of(context).feedbackTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                        child: Icon(Icons.flag_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  spacing: 20.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      L10n.of(context).feedbackDesc,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      child: TextField(
                        controller: _feedbackController,
                        decoration: InputDecoration(
                          hintText: L10n.of(context).feedbackHint,
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _feedbackController.text.isNotEmpty
                          ? () {
                              Navigator.of(context).pop(
                                _feedbackController.text,
                              );
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(L10n.of(context).feedbackButton),
                        ],
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
