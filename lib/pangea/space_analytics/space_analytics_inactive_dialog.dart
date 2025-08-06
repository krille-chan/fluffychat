import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';

class SpaceAnalyticsInactiveDialog extends StatelessWidget {
  const SpaceAnalyticsInactiveDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FullWidthDialog(
      maxHeight: 375.0,
      maxWidth: 450.0,
      dialogContent: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 40.0,
          ),
          child: Column(
            spacing: 12.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      L10n.of(context).analyticsInactiveTitle,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Text(
                L10n.of(context).analyticsInactiveDesc,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
