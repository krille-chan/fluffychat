import 'package:flutter/material.dart';

class InlineTooltip extends StatelessWidget {
  final String body;
  final VoidCallback onClose;

  const InlineTooltip({
    super.key,
    required this.body,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      offset: const Offset(0, -7),
      backgroundColor: Colors.transparent,
      label: CircleAvatar(
        radius: 10,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.close_outlined,
            size: 15,
          ),
          onPressed: onClose,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary.withAlpha(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(
                    Icons.lightbulb,
                    size: 16,
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 5),
                ),
                TextSpan(
                  text: body,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
