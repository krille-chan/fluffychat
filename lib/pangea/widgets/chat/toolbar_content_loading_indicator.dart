import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';

class ToolbarContentLoadingIndicator extends StatelessWidget {
  const ToolbarContentLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConfig.toolbarMinWidth / 2,
      height: AppConfig.toolbarMinHeight / 2,
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
