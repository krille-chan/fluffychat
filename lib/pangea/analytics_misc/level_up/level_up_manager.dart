import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LevelUpManager {
  // Singleton instance so analytics can be generated when level up is initiated, and be ready by the time user clicks on banner
  static final LevelUpManager instance = LevelUpManager._internal();

  LevelUpManager._internal();

  int prevLevel = 0;
  int level = 0;

  int prevGrammar = 0;
  int nextGrammar = 0;
  int prevVocab = 0;
  int nextVocab = 0;

  bool hasSeenPopup = false;
  bool shouldAutoPopup = false;

  Future<void> preloadAnalytics(
    BuildContext context,
    int level,
    int prevLevel,
  ) async {
    this.level = level;
    this.prevLevel = prevLevel;

    //For on route change behavior, if added in the future
    shouldAutoPopup = true;

    nextGrammar = MatrixState.pangeaController.getAnalytics.constructListModel
        .numConstructs(ConstructTypeEnum.morph);
    nextVocab = MatrixState.pangeaController.getAnalytics.constructListModel
        .numConstructs(ConstructTypeEnum.vocab);

    final LanguageModel? l2 =
        MatrixState.pangeaController.languageController.userL2;
    final Room? analyticsRoom =
        MatrixState.pangeaController.matrixState.client.analyticsRoomLocal(l2!);

    if (analyticsRoom != null) {
      // How to get all summary events in the timeline
      final timeline = await analyticsRoom.getTimeline();
      final summaryEvents = timeline.events
          .where(
            (e) => e.type == PangeaEventTypes.constructSummary,
          )
          .map(
            (e) => ConstructSummary.fromJson(e.content),
          )
          .toList();

      //Find previous summary to get grammar constructs and vocab numbers from
      final lastSummary = summaryEvents
              .where((summary) => summary.upperLevel == prevLevel)
              .toList()
              .isNotEmpty
          ? summaryEvents
              .firstWhere((summary) => summary.upperLevel == prevLevel)
          : null;

      //Set grammar and vocab from last level summary, if there is one. Otherwise set to placeholder data
      if (lastSummary != null &&
          lastSummary.levelVocabConstructs != null &&
          lastSummary.levelGrammarConstructs != null) {
        prevVocab = lastSummary.levelVocabConstructs!;
        prevGrammar = lastSummary.levelGrammarConstructs!;
      } else {
        prevGrammar = (nextGrammar / prevLevel).round();
        prevVocab = (nextVocab / prevLevel).round();
      }
    }
  }

  void markPopupSeen() {
    hasSeenPopup = true;
    shouldAutoPopup = false;
  }

  void reset() {
    hasSeenPopup = false;
    shouldAutoPopup = false;
    prevLevel = 0;
    level = 0;
    prevGrammar = 0;
    nextGrammar = 0;
    prevVocab = 0;
    nextVocab = 0;
  }
}
