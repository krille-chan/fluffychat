import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_page/analytics_page.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_indicators.dart';
import 'package:fluffychat/pangea/analytics_summary/level_dialog_content.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/widgets/navigation_rail.dart';

class AnalyticsPageView extends StatelessWidget {
  final AnalyticsPageState controller;
  const AnalyticsPageView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return Row(
      children: [
        if (!isColumnMode && AppConfig.displayNavigationRail) ...[
          SpacesNavigationRail(
            activeSpaceId: null,
            onGoToChats: () => context.go('/rooms'),
            onGoToSpaceId: (spaceId) => context.go('/rooms?spaceId=$spaceId'),
          ),
          Container(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ],
        Expanded(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsetsGeometry.all(16.0),
              child: Column(
                spacing: 16.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LearningProgressIndicators(
                    selected: controller.selectedIndicator,
                    onIndicatorSelected: controller.onIndicatorSelected,
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (controller.selectedIndicator ==
                            ProgressIndicatorEnum.level) {
                          return const LevelDialogContent();
                        } else if (controller.selectedIndicator ==
                            ProgressIndicatorEnum.morphsUsed) {
                          return const AnalyticsPopupWrapper(
                            view: ConstructTypeEnum.morph,
                            showAppBar: false,
                          );
                        } else if (controller.selectedIndicator ==
                            ProgressIndicatorEnum.wordsUsed) {
                          return const AnalyticsPopupWrapper(
                            view: ConstructTypeEnum.vocab,
                            showAppBar: false,
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
