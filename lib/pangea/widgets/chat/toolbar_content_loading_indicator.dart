import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:flutter/material.dart';

class ToolbarContentLoadingIndicator extends StatelessWidget {
  const ToolbarContentLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minHeight: minCardHeight),
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          height: 14,
          width: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
