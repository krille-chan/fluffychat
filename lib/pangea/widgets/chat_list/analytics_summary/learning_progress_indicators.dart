import 'dart:async';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/widgets/chat_list/analytics_summary/progress_indicator.dart';
import 'package:fluffychat/utils/string_color.dart';
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

  @override
  void initState() {
    super.initState();
    updateAnalyticsData();
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
    final constructEvents = await _pangeaController.analytics.getConstructs();
    final List<OneConstructUse> localUses = [];
    for (final uses in _pangeaController.analytics.messagesSinceUpdate.values) {
      localUses.addAll(uses);
    }

    if (constructEvents == null || constructEvents.isEmpty) {
      words = ConstructListModel(
        type: ConstructTypeEnum.vocab,
        uses: localUses,
      );
      errors = ConstructListModel(
        type: ConstructTypeEnum.grammar,
        uses: localUses,
      );
      return;
    }

    final List<OneConstructUse> storedConstruct =
        constructEvents.expand((e) => e.content.uses).toList();
    final List<OneConstructUse> allConstructs = [
      ...storedConstruct,
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
    setState(() {});
  }

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

  int get xpPoints {
    final points = [
      words?.lemmas.length ?? 0,
      errors?.lemmas.length ?? 0,
    ];
    return points.reduce((a, b) => a + b);
  }

  int get level => xpPoints ~/ 100;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 36,
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                  );
                },
              ),
              Expanded(
                child: Row(
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
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 35,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  right: 0,
                  child: Row(
                    children: [
                      SizedBox(
                        width: FluffyThemes.columnWidth - (36 * 2) - 25,
                        child: Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppConfig.borderRadius,
                                  ),
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              AnimatedContainer(
                                duration: FluffyThemes.animationDuration,
                                curve: FluffyThemes.animationCurve,
                                height: 15,
                                width:
                                    (FluffyThemes.columnWidth - (36 * 2) - 25) *
                                        ((xpPoints % 100) / 100),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppConfig.borderRadius,
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  child: CircleAvatar(
                    backgroundColor: "$level $xpPoints".lightColorAvatar,
                    radius: 16,
                    child: Text(
                      "$level",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
