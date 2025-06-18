import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class LevelUpManager {
  // Singleton instance
  static final LevelUpManager instance = LevelUpManager._internal();

  // Private constructor
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

  int get vocabCount =>
      MatrixState.pangeaController.getAnalytics.constructListModel
          .unlockedLemmas(ConstructTypeEnum.vocab)
          .length;

  Future<void> preloadAnalytics(
    BuildContext context,
    int level,
    int prevLevel,
  ) async {
    this.level = level;
    this.prevLevel = prevLevel;

    shouldAutoPopup = true;

    //grammar and vocab
    nextGrammar = MatrixState
        .pangeaController.getAnalytics.constructListModel.grammarLemmas;
    nextVocab = MatrixState
        .pangeaController.getAnalytics.constructListModel.vocabLemmas;

    //for now idk how to get these
    prevGrammar = nextGrammar < 30 ? 0 : nextGrammar - 30;

    prevVocab = nextVocab < 30 ? 0 : nextVocab - 30;

    userL2Code = MatrixState.pangeaController.languageController
        .activeL2Code()
        ?.toUpperCase();

    /*for testing, just fetch last level up
    constructSummary = MatrixState.pangeaController.getAnalytics
        .getConstructSummaryFromStateEvent();
    debugPrint(
      "Last saved construct summary: ${constructSummary?.toJson()}",
    );

    final client = MatrixState.pangeaController.matrixState.client;

    final Room? analyticsRoom = client.analyticsRoomLocal(
      MatrixState.pangeaController.languageController.userL2!,
    );

    // Get all summary events in the timeline
    final timeline = await analyticsRoom!.getTimeline();
    final summaryEvents = timeline.events
        .where(
          (e) => e.type == PangeaEventTypes.constructSummary,
        )
        .map(
          (e) => ConstructSummary.fromJson(e.content),
        )
        .toList();
    debugPrint("List of previous summaries from timeline: $summaryEvents");

    for (final summary in summaryEvents) {
      debugPrint("Individual summaries from timeline: ${summary.toJson()}");
    }

    */

    // fetch construct summary for actual app, not while testing since level up isn't true
    try {
      constructSummary = await MatrixState.pangeaController.getAnalytics
          .generateLevelUpAnalytics(
        level,
        prevLevel,
      );
    } catch (e) {
      error = e.toString();
    }
    // end of that block
    await Future.delayed(
      const Duration(seconds: 1),
      () => LevelUpManager.instance.printAnalytics(),
    );
  }

  void printAnalytics() {
    debugPrint('Level Up Analytics:');
    debugPrint('Current Level: $level');
    debugPrint('Previous Level: $prevLevel');
    debugPrint('Next Grammar: $nextGrammar');
    debugPrint('Next Vocab: $nextVocab');
    if (constructSummary != null) {
      debugPrint('Construct Summary: ${constructSummary!.toJson()}');
    } else {
      debugPrint('Construct Summary: Not available');
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
    constructSummary = null;
    error = null;
    // Reset any other state if necessary
  }
}
