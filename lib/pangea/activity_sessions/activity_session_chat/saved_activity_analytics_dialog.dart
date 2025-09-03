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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300.0,
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
                        style: const TextStyle(fontSize: 12.0),
                      ),
                      Text(
                        L10n.of(context).activityCompletedDesc,
                        style: const TextStyle(fontSize: 8.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        "${AppConfig.assetsBaseURL}/${AnalyticsPageConstants.dinoBotFileName}",
                    errorWidget: (context, e, s) => const SizedBox.shrink(),
                    progressIndicatorBuilder: (context, _, __) =>
                        const SizedBox.shrink(),
                    width: 100.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
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
                          style: const TextStyle(fontSize: 12.0),
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
