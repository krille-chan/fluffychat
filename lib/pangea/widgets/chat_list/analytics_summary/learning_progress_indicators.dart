import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
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
  int? wordsUsed;
  int? errorTypes;

  @override
  void initState() {
    super.initState();
    setData();
  }

  AnalyticsSelected get defaultSelected => AnalyticsSelected(
        _pangeaController.matrixState.client.userID!,
        AnalyticsEntryType.student,
        "",
      );

  Future<void> setData() async {
    await getNumLemmasUsed();
    setState(() {});
  }

  Future<void> getNumLemmasUsed() async {
    final constructs = await _pangeaController.analytics.getConstructs(
      defaultSelected: defaultSelected,
      timeSpan: TimeSpan.forever,
    );
    if (constructs == null) {
      errorTypes = 0;
      wordsUsed = 0;
      return;
    }

    final List<String> errorLemmas = [];
    final List<String> vocabLemmas = [];
    for (final event in constructs) {
      for (final use in event.content.uses) {
        if (use.lemma == null) continue;
        switch (use.constructType) {
          case ConstructTypeEnum.grammar:
            errorLemmas.add(use.lemma!);
            break;
          case ConstructTypeEnum.vocab:
            vocabLemmas.add(use.lemma!);
            break;
          default:
            break;
        }
      }
    }
    errorTypes = errorLemmas.toSet().length;
    wordsUsed = vocabLemmas.toSet().length;
  }

  int? getProgressPoints(ProgressIndicatorEnum indicator) {
    switch (indicator) {
      case ProgressIndicatorEnum.wordsUsed:
        return wordsUsed;
      case ProgressIndicatorEnum.errorTypes:
        return errorTypes;
      case ProgressIndicatorEnum.level:
        return level;
    }
  }

  int get xpPoints {
    final points = [
      wordsUsed ?? 0,
      errorTypes ?? 0,
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
                        child: LinearProgressIndicator(
                          value: (xpPoints % 100) / 100,
                          color: Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          minHeight: 15,
                          borderRadius:
                              BorderRadius.circular(AppConfig.borderRadius),
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
