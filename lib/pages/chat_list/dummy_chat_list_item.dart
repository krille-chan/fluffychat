import 'package:flutter/material.dart';

class DummyChatListItem extends StatelessWidget {
  final double opacity;
  final bool animate;

  const DummyChatListItem({
    required this.opacity,
    required this.animate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = theme.textTheme.bodyLarge!.color!.withAlpha(100);
    final subtitleColor = theme.textTheme.bodyLarge!.color!.withAlpha(50);
    return Opacity(
      opacity: opacity,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: titleColor,
          child: animate
              ? CircularProgressIndicator(
                  strokeWidth: 1,
                  color: theme.textTheme.bodyLarge!.color,
                )
              : const SizedBox.shrink(),
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  color: titleColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(width: 36),
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: subtitleColor,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: subtitleColor,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ],
        ),
        subtitle: Container(
          decoration: BoxDecoration(
            color: subtitleColor,
            borderRadius: BorderRadius.circular(3),
          ),
          height: 12,
          margin: const EdgeInsets.only(right: 22),
        ),
      ),
    );
  }
}
