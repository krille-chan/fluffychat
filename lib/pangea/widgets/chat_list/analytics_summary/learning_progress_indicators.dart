import 'dart:async';

import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import 'package:fluffychat/pangea/controllers/get_analytics_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/pangea/widgets/animations/progress_bar/progress_bar.dart';
import 'package:fluffychat/pangea/widgets/animations/progress_bar/progress_bar_details.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/analytics_popup.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/progress_indicator.dart';
import 'package:fluffychat/pangea/widgets/flag.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A summary of "My Analytics" shown at the top of the chat list
/// It shows a variety of progress indicators such as
/// messages sent,  words used, and error types, which can
/// be clicked to access more fine-grained analytics data.
class LearningProgressIndicators extends StatefulWidget {
  const LearningProgressIndicators({
    super.key,
  });

  @override
  LearningProgressIndicatorsState createState() =>
      LearningProgressIndicatorsState();
}

class LearningProgressIndicatorsState
    extends State<LearningProgressIndicators> {
  final PangeaController _pangeaController = MatrixState.pangeaController;

  /// A stream subscription to listen for updates to
  /// the analytics data, either locally or from events
  StreamSubscription<AnalyticsStreamUpdate>? _analyticsUpdateSubscription;

  /// Vocabulary constructs model
  ConstructListModel? words;

  /// Morph constructs model
  ConstructListModel? morphs;

  bool loading = true;

  // Some buggy stuff is happening with this data not being updated at login, so switching
  // to stateful variables for now. Will switch this back later when I have more time to
  // figure out why it's now working.
  // int get serverXP => _pangeaController.analytics.serverXP;
  // int get totalXP => _pangeaController.analytics.currentXP;
  // int get level => _pangeaController.analytics.level;
  List<OneConstructUse> currentConstructs = [];
  int get currentXP => _pangeaController.analytics.calcXP(currentConstructs);
  int get localXP => _pangeaController.analytics.calcXP(
        _pangeaController.analytics.locallyCachedConstructs,
      );
  int get serverXP => currentXP - localXP;
  int get level => _pangeaController.analytics.level;

  @override
  void initState() {
    super.initState();
    updateAnalyticsData(
      _pangeaController.analytics.analyticsStream.value?.constructs ?? [],
    );
    _analyticsUpdateSubscription = _pangeaController
        .analytics.analyticsStream.stream
        .listen((update) => updateAnalyticsData(update.constructs));
  }

  @override
  void dispose() {
    _analyticsUpdateSubscription?.cancel();
    super.dispose();
  }

  /// Update the analytics data shown in the UI. This comes from a
  /// combination of stored events and locally cached data.
  Future<void> updateAnalyticsData(List<OneConstructUse> constructs) async {
    words = ConstructListModel(
      type: ConstructTypeEnum.vocab,
      uses: constructs,
    );
    morphs = ConstructListModel(
      type: ConstructTypeEnum.morph,
      uses: constructs,
    );

    currentConstructs = constructs;
    if (loading) loading = false;
    if (mounted) setState(() {});
  }

  /// Get the number of points for a given progress indicator
  ConstructListModel? getConstructsModel(ProgressIndicatorEnum indicator) {
    switch (indicator) {
      case ProgressIndicatorEnum.wordsUsed:
        return words;
      case ProgressIndicatorEnum.morphsUsed:
        return morphs;
      default:
        return null;
    }
  }

  /// Get the number of points for a given progress indicator
  int? getProgressPoints(ProgressIndicatorEnum indicator) {
    switch (indicator) {
      case ProgressIndicatorEnum.wordsUsed:
        return words?.lemmasWithPoints.length;
      case ProgressIndicatorEnum.morphsUsed:
        return morphs?.lemmasWithPoints.length;
      case ProgressIndicatorEnum.level:
        return level;
    }
  }

  // double get levelBarWidth => FluffyThemes.columnWidth - (32 * 2) - 25;

  Color levelColor(int level) {
    final colors = [
      const Color.fromARGB(255, 33, 97, 140), // Dark blue
      const Color.fromARGB(255, 186, 104, 200), // Soft purple
      const Color.fromARGB(255, 123, 31, 162), // Deep purple
      const Color.fromARGB(255, 0, 150, 136), // Teal
      const Color.fromARGB(255, 247, 143, 143), // Light pink
      const Color.fromARGB(255, 220, 20, 60), // Crimson red
    ];
    return colors[level % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    if (Matrix.of(context).client.userID == null) {
      return const SizedBox();
    }

    final progressBar = ProgressBar(
      levelBars: [
        LevelBarDetails(
          fillColor: kDebugMode
              ? const Color.fromARGB(255, 0, 190, 83)
              : Theme.of(context).colorScheme.primary,
          currentPoints: currentXP,
          widthMultiplier: _pangeaController.analytics.levelProgress,
        ),
        LevelBarDetails(
          fillColor: Theme.of(context).colorScheme.primary,
          currentPoints: serverXP,
          widthMultiplier: _pangeaController.analytics.serverLevelProgress,
        ),
      ],
    );

    final levelBadge = Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: levelColor(level),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "$level",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );

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
                              points: getProgressPoints(indicator),
                              onTap: () {
                                final model = getConstructsModel(indicator);
                                if (model == null) return;
                                showDialog<AnalyticsPopup>(
                                  context: context,
                                  builder: (c) => AnalyticsPopup(
                                    indicator: indicator,
                                    constructsModel: model,
                                  ),
                                );
                              },
                              progressIndicator: indicator,
                              loading: loading,
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
                      language: _pangeaController.languageController.userL2,
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
                    Positioned(left: 16, right: 0, child: progressBar),
                    Positioned(left: 0, child: levelBadge),
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
