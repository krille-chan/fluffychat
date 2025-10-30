import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_page/analytics_page_constants.dart';

class SavedActivityAnalyticsDialog extends StatelessWidget {
  const SavedActivityAnalyticsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: Dialog(
        backgroundColor: theme.colorScheme.surfaceContainerHigh,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 450.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                spacing: 16.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    spacing: 10.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        L10n.of(context).niceJob,
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        L10n.of(context).activityCompletedDesc,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        "${AppConfig.assetsBaseURL}/${AnalyticsPageConstants.dinoBotFileName}",
                    errorWidget: (context, e, s) => const SizedBox.shrink(),
                    progressIndicatorBuilder: (context, _, __) =>
                        const SizedBox.shrink(),
                    width: 150.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      padding: const EdgeInsets.all(4.0),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Row(
                      spacing: 4.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.map_outlined, size: 12.0),
                        Text(
                          L10n.of(context).continueText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
