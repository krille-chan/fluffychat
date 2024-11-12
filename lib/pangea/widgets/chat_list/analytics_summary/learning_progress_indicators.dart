import 'dart:async';

import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import 'package:fluffychat/pangea/controllers/get_analytics_controller.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/analytics_popup/analytics_popup.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/learning_progress_bar.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/level_badge.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/progress_indicator.dart';
import 'package:fluffychat/pangea/widgets/flag.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _analyticsSubscription = MatrixState
        .pangeaController.getAnalytics.analyticsStream.stream
        .listen(updateData);
  }

  @override
  void dispose() {
    _analyticsSubscription?.cancel();
    _analyticsSubscription = null;
    super.dispose();
  }

  void updateData(AnalyticsStreamUpdate _) {
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
    if (Matrix.of(context).client.userID == null) {
      return const SizedBox();
    }

    return Row(
      children: [
        const ClientChooserButton(),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: ProgressIndicatorEnum.values
                        .where((i) => i != ProgressIndicatorEnum.level)
                        .map(
                          (indicator) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ProgressIndicatorBadge(
                              points: uniqueLemmas(indicator),
                              loading: _loading,
                              onTap: () {
                                showDialog<AnalyticsPopup>(
                                  context: context,
                                  builder: (c) => AnalyticsPopup(
                                    type: indicator.constructType,
                                    showGroups: indicator ==
                                        ProgressIndicatorEnum.morphsUsed,
                                  ),
                                );
                              },
                              indicator: indicator,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (c) => const SettingsLearning(),
                    ),
                    child: LanguageFlag(
                      language: MatrixState
                          .pangeaController.languageController.userL2,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 36,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 16,
                      right: 0,
                      child: LearningProgressBar(
                        totalXP: _constructsModel.totalXP,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: LevelBadge(level: _constructsModel.level),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
