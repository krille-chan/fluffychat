import 'package:flutter/material.dart';

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
    return IconButton(
      onPressed: loading ? null : onPress,
      icon: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            )
          : const Icon(Icons.lightbulb_outline, size: 24),
    );
  }
}
