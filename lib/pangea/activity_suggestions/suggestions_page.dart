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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: FluffyThemes.isColumnMode(context) ? 36.0 : 8.0,
        vertical: 24.0,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10n.of(context).learnByTexting,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(36.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  spacing: 8.0,
                  children: [
                    PangeaLogoSvg(
                      width: 24.0,
                      forceColor: theme.colorScheme.primary,
                    ),
                    Text(
                      AppConfig.applicationName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!FluffyThemes.isColumnMode(context))
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: LearningProgressIndicators(),
                ),
              const SizedBox(height: 16.0),
              const Flexible(
                child: ActivitySuggestionsArea(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
