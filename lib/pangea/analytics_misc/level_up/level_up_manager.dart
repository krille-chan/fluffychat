import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
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

  String? userL2Code;

  ConstructSummary? constructSummary;

  bool hasSeenPopup = false;
  bool shouldAutoPopup = false;
  String? error;

  Future<void> preloadAnalytics(
    BuildContext context,
    int level,
    int prevLevel,
    bool test,
  ) async {
    this.level = level;
    this.prevLevel = prevLevel;

    shouldAutoPopup = true;

    //grammar and vocab
    nextGrammar = MatrixState
        .pangeaController.getAnalytics.constructListModel.grammarLemmas;
    nextVocab = MatrixState
        .pangeaController.getAnalytics.constructListModel.vocabLemmas;

    userL2Code = MatrixState.pangeaController.languageController
        .activeL2Code()
        ?.toUpperCase();

    // fetch construct summary based on test value
    if (test) {
      getConstructFromButton();
    } else {
      getConstructFromLevelUp();
    }

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

      debugPrint("List of all previous level up summaries: $summaryEvents");
      for (final summary in summaryEvents) {
        debugPrint("${summary.toJson()}");
      }
      //Find previous summary to get grammar constructs and vocab numbers from
      final lastSummary = summaryEvents
              .where((summary) => summary.upperLevel == prevLevel)
              .toList()
              .isNotEmpty
          ? summaryEvents
              .firstWhere((summary) => summary.upperLevel == prevLevel)
          : null;

      //Set grammar and vocab from last level summary, if there is one. Otherwise set to placeholder data
      debugPrint("Last construct summary is: ${lastSummary?.toJson()}");
      if (lastSummary != null &&
          lastSummary.levelVocabConstructs != null &&
          lastSummary.levelGrammarConstructs != null) {
        prevVocab = lastSummary.levelVocabConstructs!;
        prevGrammar = lastSummary.levelGrammarConstructs!;
      } else {
        prevGrammar = nextGrammar < 30 ? 0 : nextGrammar - 30;
        prevVocab = nextVocab < 30 ? 0 : nextVocab - 30;
      }
    }
  }

  void getConstructFromButton() {
    //for testing, just fetch last level up from saved analytics
    constructSummary = MatrixState.pangeaController.getAnalytics
        .getConstructSummaryFromStateEvent();
    debugPrint(
      "Last saved construct summary from analytics controller function: ${constructSummary?.toJson()}",
    );
  }

  void getConstructFromLevelUp() async {
    //for getting real level up data when leveled up
    try {
      constructSummary = await MatrixState.pangeaController.getAnalytics
          .generateLevelUpAnalytics(
        prevLevel,
        level,
      );
    } catch (e) {
      error = e.toString();
    }
  }

  // void printAnalytics() {
  //   debugPrint('Level Up Analytics:');
  //   debugPrint('Current Level: $level');
  //   debugPrint('Previous Level: $prevLevel');
  //   debugPrint('Next Grammar: $nextGrammar');
  //   debugPrint('Next Vocab: $nextVocab');
  //   if (constructSummary != null) {
  //     debugPrint('Construct Summary: ${constructSummary!.toJson()}');
  //   } else {
  //     debugPrint('Construct Summary: Not available');
  //   }
  // }

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
    constructSummary = null;
    error = null;
    // Reset any other state if necessary
  }
}
