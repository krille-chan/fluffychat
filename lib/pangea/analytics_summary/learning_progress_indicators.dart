import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_list_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/get_analytics_controller.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_settings_button.dart';
import 'package:fluffychat/pangea/analytics_summary/level_badge.dart';
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
  Profile? _profile;

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

    final client = MatrixState.pangeaController.matrixState.client;
    if (client.userID == null) return;
    client.getProfileFromUserId(client.userID!).then((profile) {
      if (mounted) setState(() => _profile = profile);
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
    if (Matrix.of(context).client.userID == null) {
      return const SizedBox();
    }

    final userL2 = MatrixState.pangeaController.languageController.userL2;

    final mxid = Matrix.of(context).client.userID ?? L10n.of(context).user;
    final displayname = _profile?.displayName ?? mxid.localpart ?? mxid;

    return Row(
      children: [
        const ClientChooserButton(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 6.0,
                children: [
                  Text(
                    displayname,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  LearningSettingsButton(
                    onTap: () => showDialog(
                      context: context,
                      builder: (c) => const SettingsLearning(),
                      barrierDismissible: false,
                    ),
                    l2: userL2?.langCode.toUpperCase(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                spacing: 6.0,
                children: ConstructTypeEnum.values
                    .map(
                      (c) => ProgressIndicatorBadge(
                        points: uniqueLemmas(c.indicator),
                        loading: _loading,
                        onTap: () {
                          showDialog<AnalyticsPopupWrapper>(
                            context: context,
                            builder: (context) => AnalyticsPopupWrapper(
                              view: c,
                            ),
                          );
                        },
                        indicator: c.indicator,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 6),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    showDialog<LevelBarPopup>(
                      context: context,
                      builder: (c) => const LevelBarPopup(),
                    );
                  },
                  child: SizedBox(
                    height: 26,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 16,
                          right: 0,
                          child: LearningProgressBar(
                            level: _constructsModel.level,
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
