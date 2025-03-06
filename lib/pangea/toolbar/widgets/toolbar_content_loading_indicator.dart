import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';

class ToolbarContentLoadingIndicator extends StatelessWidget {
  const ToolbarContentLoadingIndicator({
    super.key,
    this.height,
  });

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConfig.toolbarMinWidth / 2,
      height: height ?? AppConfig.toolbarMinHeight / 2,
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
