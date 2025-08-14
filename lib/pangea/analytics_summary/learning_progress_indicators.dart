import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_list_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/get_analytics_controller.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_indicator_button.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicator.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// A summary of "My Analytics" shown at the top of the chat list
/// It shows a variety of progress indicators such as
/// messages sent,  words used, and error types, which can
/// be clicked to access more fine-grained analytics data.
class LearningProgressIndicators extends StatefulWidget {
  final ProgressIndicatorEnum? selected;
  final bool canSelect;

  const LearningProgressIndicators({
    super.key,
    this.selected,
    this.canSelect = true,
  });

  @override
  State<LearningProgressIndicators> createState() =>
      LearningProgressIndicatorsState();
}

class LearningProgressIndicatorsState
    extends State<LearningProgressIndicators> {
  ConstructListModel get _constructsModel =>
      MatrixState.pangeaController.getAnalytics.constructListModel;
  bool _loading = true;

  StreamSubscription<AnalyticsStreamUpdate>? _analyticsSubscription;
  StreamSubscription? _languageSubscription;

  @override
  void initState() {
    super.initState();

    // if getAnalytics has already finished initializing,
    // the data is loaded and should be displayed.
    if (MatrixState.pangeaController.getAnalytics.initCompleter.isCompleted) {
      updateData(null);
    }
    _analyticsSubscription = MatrixState
        .pangeaController.getAnalytics.analyticsStream.stream
        .listen(updateData);

    // rebuild when target language changes
    _languageSubscription = MatrixState
        .pangeaController.userController.languageStream.stream
        .listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _analyticsSubscription?.cancel();
    _analyticsSubscription = null;
    _languageSubscription?.cancel();
    _languageSubscription = null;
    super.dispose();
  }

  void updateData(AnalyticsStreamUpdate? _) {
    if (_loading) _loading = false;
    if (mounted) setState(() {});
  }

  int uniqueLemmas(ProgressIndicatorEnum indicator) {
    switch (indicator) {
      case ProgressIndicatorEnum.morphsUsed:
        return _constructsModel.numConstructs(ConstructTypeEnum.morph);
      case ProgressIndicatorEnum.wordsUsed:
        return _constructsModel.numConstructs(ConstructTypeEnum.vocab);
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    if (client.userID == null) {
      return const SizedBox();
    }

    final userL1 = MatrixState.pangeaController.languageController.userL1;
    final userL2 = MatrixState.pangeaController.languageController.userL2;

    final isColumnMode = FluffyThemes.isColumnMode(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      spacing: isColumnMode ? 16.0 : 4.0,
                      children: [
                        ...ConstructTypeEnum.values.map(
                          (c) => HoverButton(
                            selected: widget.selected == c.indicator,
                            onPressed: () {
                              context.go(
                                "/rooms/analytics?mode=${c.string}",
                              );
                            },
                            child: ProgressIndicatorBadge(
                              indicator: c.indicator,
                              loading: _loading,
                              points: uniqueLemmas(c.indicator),
                            ),
                          ),
                        ),
                        HoverButton(
                          selected: widget.selected ==
                              ProgressIndicatorEnum.activities,
                          onPressed: () {
                            context.go(
                              "/rooms/analytics?mode=activities",
                            );
                          },
                          child: Tooltip(
                            message: ProgressIndicatorEnum.activities
                                .tooltip(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  size: 18,
                                  Icons.radar,
                                  color: Theme.of(context).colorScheme.primary,
                                  weight: 1000,
                                ),
                                const SizedBox(width: 6.0),
                                AnimatedFloatingNumber(
                                  number: Matrix.of(context)
                                          .client
                                          .analyticsRoomLocal()
                                          ?.activityRoomIds
                                          .length ??
                                      0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  HoverButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (c) => const SettingsLearning(),
                      barrierDismissible: false,
                    ),
                    child: Row(
                      children: [
                        if (userL1 != null && userL2 != null)
                          Text(
                            userL1.langCodeShort.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        if (userL1 != null && userL2 != null)
                          const Icon(Icons.chevron_right_outlined),
                        if (userL2 != null)
                          Text(
                            userL2.langCodeShort.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: HoverBuilder(
                  builder: (context, hovered) {
                    return Container(
                      decoration: BoxDecoration(
                        color: hovered && widget.canSelect
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha((0.2 * 255).round())
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 4.0,
                      ),
                      child: MouseRegion(
                        cursor: widget.canSelect
                            ? SystemMouseCursors.click
                            : MouseCursor.defer,
                        child: GestureDetector(
                          onTap: widget.canSelect
                              ? () {
                                  context.go("/rooms/analytics?mode=level");
                                }
                              : null,
                          child: Row(
                            spacing: 8.0,
                            children: [
                              Expanded(
                                child: LearningProgressBar(
                                  level: _constructsModel.level,
                                  totalXP: _constructsModel.totalXP,
                                  height: 24.0,
                                  loading: _loading,
                                ),
                              ),
                              if (!_loading)
                                Text(
                                  "⭐ ${_constructsModel.level}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ],
    );
  }
}
