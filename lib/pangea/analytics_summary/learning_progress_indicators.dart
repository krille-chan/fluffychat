import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_list_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/get_analytics_controller.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_indicator_button.dart';
import 'package:fluffychat/pangea/analytics_summary/level_bar_popup.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicator.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// A summary of "My Analytics" shown at the top of the chat list
/// It shows a variety of progress indicators such as
/// messages sent,  words used, and error types, which can
/// be clicked to access more fine-grained analytics data.
class LearningProgressIndicators extends StatefulWidget {
  const LearningProgressIndicators({super.key});

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
    _languageSubscription =
        MatrixState.pangeaController.userController.stateStream.listen((_) {
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
        return _constructsModel.grammarLemmas;
      case ProgressIndicatorEnum.wordsUsed:
        return _constructsModel.vocabLemmas;
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
                      spacing: 16.0,
                      children: ConstructTypeEnum.values
                          .map(
                            (c) => LearningProgressIndicatorButton(
                              onPressed: () {
                                showDialog<AnalyticsPopupWrapper>(
                                  context: context,
                                  builder: (context) => AnalyticsPopupWrapper(
                                    view: c,
                                  ),
                                );
                              },
                              child: ProgressIndicatorBadge(
                                indicator: c.indicator,
                                loading: _loading,
                                points: uniqueLemmas(c.indicator),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  LearningProgressIndicatorButton(
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
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      showDialog<LevelBarPopup>(
                        context: context,
                        builder: (c) => const LevelBarPopup(),
                      );
                    },
                    child: Row(
                      spacing: 8.0,
                      children: [
                        Expanded(
                          child: LearningProgressBar(
                            level: _constructsModel.level,
                            totalXP: _constructsModel.totalXP,
                            height: 24.0,
                          ),
                        ),
                        Text(
                          "⭐ ${_constructsModel.level}",
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
