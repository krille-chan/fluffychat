import 'dart:async';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/constants/analytics_constants.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/widgets/animations/progress_bar/progress_bar.dart';
import 'package:fluffychat/pangea/widgets/animations/progress_bar/progress_bar_details.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/progress_indicator.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

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
  StreamSubscription<List<OneConstructUse>>? _analyticsUpdateSubscription;

  /// Vocabulary constructs model
  ConstructListModel? words;

  /// Grammar constructs model
  ConstructListModel? errors;

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
  int get level => currentXP ~/ AnalyticsConstants.xpPerLevel;

  @override
  void initState() {
    super.initState();
    updateAnalyticsData(
      _pangeaController.analytics.analyticsStream.value ?? [],
    );
    _analyticsUpdateSubscription = _pangeaController
        .analytics.analyticsStream.stream
        .listen(updateAnalyticsData);
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
    errors = ConstructListModel(
      type: ConstructTypeEnum.grammar,
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
  int? getProgressPoints(ProgressIndicatorEnum indicator) {
    switch (indicator) {
      case ProgressIndicatorEnum.wordsUsed:
        return words?.lemmas.length;
      case ProgressIndicatorEnum.errorTypes:
        return errors?.lemmas.length;
      case ProgressIndicatorEnum.morphsUsed:
        return morphs?.lemmas.length;
      case ProgressIndicatorEnum.level:
        return level;
    }
  }

  double get levelBarWidth => FluffyThemes.columnWidth - (32 * 2) - 25;

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
          fillColor: const Color.fromARGB(255, 0, 190, 83),
          currentPoints: currentXP,
        ),
        LevelBarDetails(
          fillColor: Theme.of(context).colorScheme.primary,
          currentPoints: serverXP,
        ),
      ],
      progressBarDetails: ProgressBarDetails(
        totalWidth: levelBarWidth,
        borderColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
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
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // const Positioned(
        //   child: PointsGainedAnimation(),
        // ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(46, 0, 32, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                    future: _pangeaController.matrixState.client
                        .getProfileFromUserId(
                      _pangeaController.matrixState.client.userID!,
                    ),
                    builder: (context, snapshot) {
                      final mxid = Matrix.of(context).client.userID ??
                          L10n.of(context)!.user;
                      return Avatar(
                        name: snapshot.data?.displayName ??
                            mxid.localpart ??
                            mxid,
                        mxContent: snapshot.data?.avatarUrl,
                        size: 40,
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ProgressIndicatorEnum.values
                        .where(
                          (indicator) =>
                              indicator != ProgressIndicatorEnum.level,
                        )
                        .map(
                          (indicator) => ProgressIndicatorBadge(
                            points: getProgressPoints(indicator),
                            onTap: () {},
                            progressIndicator: indicator,
                            loading: loading,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(left: 16, right: 0, child: progressBar),
                  Positioned(left: 0, child: levelBadge),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }
}
