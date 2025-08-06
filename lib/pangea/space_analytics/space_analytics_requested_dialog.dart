import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_page/analytics_page_constants.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';

class SpaceAnalyticsRequestedDialog extends StatelessWidget {
  final Room room;
  const SpaceAnalyticsRequestedDialog({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);
    return FullWidthDialog(
      maxHeight: 800.0,
      maxWidth: 450.0,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      dialogContent: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                spacing: 12.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    L10n.of(context).accessRequestedTitle,
                    style: TextStyle(fontSize: isColumnMode ? 24.0 : 20.0),
                  ),
                  Text(
                    L10n.of(context).accessRequestedDesc(
                      room.getLocalizedDisplayname(),
                    ),
                    style: TextStyle(fontSize: isColumnMode ? 16.0 : 14.0),
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        "${AppConfig.assetsBaseURL}/${AnalyticsPageConstants.dinoBotFileName}",
                    errorWidget: (context, e, s) => const SizedBox.shrink(),
                    progressIndicatorBuilder: (context, _, __) =>
                        const SizedBox.shrink(),
                    width: 150.0,
                  ),
                  const SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                spacing: 16.0,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Row(
                        spacing: 10.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Symbols.approval_delegation),
                          Text(L10n.of(context).allowAccess),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Row(
                        spacing: 10.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.visibility_off),
                          Text(L10n.of(context).denyAccess),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
