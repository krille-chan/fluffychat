import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_page/activity_archive.dart';
import 'package:fluffychat/pangea/analytics_page/analytics_page_constants.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_indicators.dart';
import 'package:fluffychat/pangea/analytics_summary/level_dialog_content.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AnalyticsPage extends StatefulWidget {
  final ProgressIndicatorEnum? indicator;
  final ConstructIdentifier? construct;
  final bool isSidebar;

  const AnalyticsPage({
    super.key,
    this.indicator,
    this.construct,
    this.isSidebar = false,
  });

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    final analytics = MatrixState.pangeaController.getAnalytics;

    // Check if getAnalytics is initialized, if not wait for the first stream entry
    if (!analytics.initCompleter.isCompleted) {
      analytics.analyticsStream.stream.first.then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final analyticsRoomId = GoRouterState.of(context).pathParameters['roomid'];
    return Scaffold(
      appBar: widget.construct != null ? AppBar() : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isSidebar ||
                  (!FluffyThemes.isColumnMode(context) &&
                      widget.construct == null))
                LearningProgressIndicators(
                  selected: widget.indicator,
                  canSelect: widget.indicator != ProgressIndicatorEnum.level,
                ),
              Expanded(
                child: () {
                  if (widget.indicator == ProgressIndicatorEnum.level) {
                    return const LevelDialogContent();
                  } else if (widget.indicator ==
                      ProgressIndicatorEnum.morphsUsed) {
                    return ConstructAnalyticsView(
                      construct: widget.construct,
                      view: ConstructTypeEnum.morph,
                    );
                  } else if (widget.indicator ==
                      ProgressIndicatorEnum.wordsUsed) {
                    return ConstructAnalyticsView(
                      construct: widget.construct,
                      view: ConstructTypeEnum.vocab,
                    );
                  } else if (widget.indicator ==
                      ProgressIndicatorEnum.activities) {
                    return ActivityArchive(
                      selectedRoomId: analyticsRoomId,
                    );
                  }

                  return Center(
                    child: SizedBox(
                      width: 250.0,
                      child: CachedNetworkImage(
                        imageUrl:
                            "${AppConfig.assetsBaseURL}/${AnalyticsPageConstants.dinoBotFileName}",
                        errorWidget: (context, url, error) => const SizedBox(),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ),
                  );
                }(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
