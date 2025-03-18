import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_area.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_indicators.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';

class SuggestionsPage extends StatelessWidget {
  const SuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isColumnMode ? 36.0 : 8.0,
        vertical: isColumnMode ? 24.0 : 8.0,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isColumnMode) const LearningProgressIndicators(),
            Padding(
              padding: EdgeInsets.only(
                left: isColumnMode ? 12.0 : 4.0,
                right: isColumnMode ? 12.0 : 4.0,
                top: 16.0,
                bottom: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    L10n.of(context).learnByTexting,
                    style: isColumnMode
                        ? theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)
                        : theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 10.0,
                    ),
                    child: Row(
                      spacing: 8.0,
                      children: [
                        PangeaLogoSvg(
                          width: 16.0,
                          forceColor: theme.colorScheme.primary,
                        ),
                        Text(
                          AppConfig.applicationName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Flexible(
              child: ActivitySuggestionsArea(),
            ),
          ],
        ),
      ),
    );
  }
}
