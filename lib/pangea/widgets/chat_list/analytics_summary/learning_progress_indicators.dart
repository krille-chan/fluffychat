import 'dart:async';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
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
  StreamSubscription? _onAnalyticsUpdate;

  /// Vocabulary constructs model
  ConstructListModel? words;

  /// Grammar constructs model
  ConstructListModel? errors;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    updateAnalyticsData().then((_) {
      setState(() => loading = false);
    });
    // listen for changes to analytics data and update the UI
    _onAnalyticsUpdate = _pangeaController
        .myAnalytics.analyticsUpdateStream.stream
        .listen((_) => updateAnalyticsData());
  }

  @override
  void dispose() {
    _onAnalyticsUpdate?.cancel();
    super.dispose();
  }

  /// Update the analytics data shown in the UI. This comes from a
  /// combination of stored events and locally cached data.
  Future<void> updateAnalyticsData() async {
    final List<OneConstructUse> storedUses =
        await _pangeaController.analytics.getConstructs();
    final List<OneConstructUse> localUses = [];
    for (final uses in _pangeaController.analytics.messagesSinceUpdate.values) {
      localUses.addAll(uses);
    }

    if (storedUses.isEmpty) {
      words = ConstructListModel(
        type: ConstructTypeEnum.vocab,
        uses: localUses,
      );
      errors = ConstructListModel(
        type: ConstructTypeEnum.grammar,
        uses: localUses,
      );
      setState(() {});
      return;
    }

    final List<OneConstructUse> allConstructs = [
      ...storedUses,
      ...localUses,
    ];

    words = ConstructListModel(
      type: ConstructTypeEnum.vocab,
      uses: allConstructs,
    );
    errors = ConstructListModel(
      type: ConstructTypeEnum.grammar,
      uses: allConstructs,
    );

    if (mounted) setState(() {});
  }

  /// Get the number of points for a given progress indicator
  int? getProgressPoints(ProgressIndicatorEnum indicator) {
    switch (indicator) {
      case ProgressIndicatorEnum.wordsUsed:
        return words?.lemmas.length;
      case ProgressIndicatorEnum.errorTypes:
        return errors?.lemmas.length;
      case ProgressIndicatorEnum.level:
        return level;
    }
  }

  /// Get the total number of xp points, based on the point values of use types
  int get xpPoints {
    return (words?.points ?? 0) + (errors?.points ?? 0);
  }

  /// Get the current level based on the number of xp points
  int get level => xpPoints ~/ 500;

  double get levelBarWidth => FluffyThemes.columnWidth - (32 * 2) - 25;
  double get pointsBarWidth {
    final percent = (xpPoints % 500) / 500;
    return levelBarWidth * percent;
  }

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

    final levelBar = Container(
      height: 20,
      width: levelBarWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          width: 2,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(AppConfig.borderRadius),
          bottomRight: Radius.circular(AppConfig.borderRadius),
        ),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
    );

    final xpBar = AnimatedContainer(
      duration: FluffyThemes.animationDuration,
      height: 16,
      width: pointsBarWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(AppConfig.borderRadius),
          bottomRight: Radius.circular(AppConfig.borderRadius),
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    final levelBadge = Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: levelColor(level),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Center(
        child: Text(
          "$level",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(46, 0, 32, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future:
                    _pangeaController.matrixState.client.getProfileFromUserId(
                  _pangeaController.matrixState.client.userID!,
                ),
                builder: (context, snapshot) {
                  final mxid = Matrix.of(context).client.userID ??
                      L10n.of(context)!.user;
                  return Avatar(
                    name: snapshot.data?.displayName ?? mxid.localpart ?? mxid,
                    mxContent: snapshot.data?.avatarUrl,
                    size: 40,
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ProgressIndicatorEnum.values
                    .where(
                      (indicator) => indicator != ProgressIndicatorEnum.level,
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
              Positioned(left: 16, right: 0, child: levelBar),
              Positioned(left: 16, child: xpBar),
              Positioned(left: 0, child: levelBadge),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
