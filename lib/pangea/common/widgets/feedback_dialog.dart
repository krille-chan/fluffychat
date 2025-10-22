import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';

class FeedbackDialog extends StatefulWidget {
  final String title;
  final Function(String) onSubmit;

  final bool scrollable;
  final Widget? extraContent;

  const FeedbackDialog({
    super.key,
    required this.title,
    required this.onSubmit,
    this.scrollable = true,
    this.extraContent,
  });

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      spacing: 20.0,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Center(
          child: BotFace(
            width: 50.0,
            expression: BotExpression.addled,
          ),
        ),
        Text(
          L10n.of(context).feedbackDialogDesc,
          textAlign: TextAlign.center,
        ),
        if (widget.extraContent != null) widget.extraContent!,
        TextFormField(
          controller: _feedbackController,
          decoration: InputDecoration(
            hintText: L10n.of(context).feedbackHint,
          ),
          keyboardType: TextInputType.multiline,
          onFieldSubmitted: _feedbackController.text.isNotEmpty
              ? (value) => widget.onSubmit(value)
              : null,
          maxLines: null,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        ),
      ],
    );

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width: 325.0,
          constraints: const BoxConstraints(
            maxHeight: 600.0,
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 20.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
              widget.scrollable
                  ? Expanded(child: SingleChildScrollView(child: content))
                  : content,
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _feedbackController,
                builder: (context, value, _) {
                  final isNotEmpty = value.text.isNotEmpty;
                  return ElevatedButton(
                    onPressed:
                        isNotEmpty ? () => widget.onSubmit(value.text) : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(L10n.of(context).feedbackButton),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
