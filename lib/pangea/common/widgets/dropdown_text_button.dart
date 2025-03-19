import 'package:flutter/material.dart';

class DropdownTextButton extends StatelessWidget {
  final bool isSelected;
  final String text;

  const DropdownTextButton({
    required this.text,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected
          ? Theme.of(context)
              .colorScheme
              .primary
              .withAlpha(20) // Highlight selected
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      child: Row(
        children: [
          Text(
            text,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }
}

class CustomDropdownTextButton extends StatelessWidget {
  final String text;

  const CustomDropdownTextButton({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.clip,
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}
