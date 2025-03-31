import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_area.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_constants.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_indicators.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';

class SuggestionsPage extends StatelessWidget {
  const SuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isColumnMode ? 36.0 : 4.0,
            vertical: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isColumnMode)
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isColumnMode ? 0 : 12.0),
                  child: const LearningProgressIndicators(),
                ),
              Padding(
                padding: EdgeInsets.only(
                  left: isColumnMode ? 0.0 : 4.0,
                  right: isColumnMode ? 0.0 : 4.0,
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        L10n.of(context).startChat,
                        style: isColumnMode
                            ? theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)
                            : theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      spacing: 8.0,
                      children: [
                        InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => context.go('/rooms/newgroup'),
                          child: Container(
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomizedSvg(
                                  svgUrl:
                                      "${AppConfig.assetsBaseURL}/${ActivitySuggestionsConstants.plusIconPath}",
                                  colorReplacements: {
                                    "#CDBEF9": colorToHex(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  },
                                  height: 16.0,
                                  width: 16.0,
                                ),
                                Text(
                                  isColumnMode
                                      ? L10n.of(context).createOwnChat
                                      : L10n.of(context).chat,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => context.go('/rooms/planner'),
                          child: Container(
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomizedSvg(
                                  svgUrl:
                                      "${AppConfig.assetsBaseURL}/${ActivitySuggestionsConstants.crayonIconPath}",
                                  colorReplacements: {
                                    "#CDBEF9": colorToHex(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  },
                                  height: 16.0,
                                  width: 16.0,
                                ),
                                Text(
                                  isColumnMode
                                      ? L10n.of(context).makeYourOwnActivity
                                      : L10n.of(context).createActivity,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const ActivitySuggestionsArea(),
            ],
          ),
        ),
      ),
    );
  }
}
