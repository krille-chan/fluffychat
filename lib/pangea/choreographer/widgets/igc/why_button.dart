import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

class WhyButton extends StatelessWidget {
  const WhyButton({
    super.key,
    required this.onPress,
    required this.loading,
  });

  final VoidCallback onPress;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: loading ? null : onPress,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          Theme.of(context).colorScheme.primary.withAlpha(25),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Border radius
            side: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .primary, // Replace with your color
              style: BorderStyle.solid,
              width: 2.0,
            ),
          ),
        ),
      ),
      child: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!loading) const Icon(Icons.lightbulb_outline),
            if (loading)
              const Center(
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            const SizedBox(width: 8),
            Text(L10n.of(context).why),
          ],
        ),
      ),
    );
  }
}
