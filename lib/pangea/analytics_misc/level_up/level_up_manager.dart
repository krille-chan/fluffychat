import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/level_up_banner.dart';
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

  bool _isShowingLevelUp = false;

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
    prevGrammar = nextGrammar < 20 ? 0 : nextGrammar - 20;

    prevVocab = nextVocab < 20 ? 0 : nextVocab - 20;

    userL2Code = MatrixState.pangeaController.languageController
        .activeL2Code()
        ?.toUpperCase();

    //fetch construct summary
    try {
      constructSummary = await MatrixState.pangeaController.getAnalytics
          .generateLevelUpAnalytics(
        level,
        prevLevel,
      );
    } catch (e) {
      error = e.toString();
    }
  }

  void markPopupSeen() {
    hasSeenPopup = true;
    shouldAutoPopup = false;
  }

  void printAnalytics() {
    print('Level Up Analytics:');
    print('Current Level: $level');
    print('Previous Level: $prevLevel');
    print('Next Grammar: $nextGrammar');
    print('Next Vocab: $nextVocab');
    print("should show popup: $shouldAutoPopup");
    print("has seen popup: $hasSeenPopup");
    if (constructSummary != null) {
      print('Construct Summary: ${constructSummary!.toJson()}');
    } else {
      print('Construct Summary: Not available');
    }
  }

  Future<void> handleLevelUp(
    BuildContext context,
    int level,
    int prevLevel,
  ) async {
    if (_isShowingLevelUp) return;
    _isShowingLevelUp = true;

    await preloadAnalytics(context, level, prevLevel);

    if (!context.mounted) {
      _isShowingLevelUp = false;
      return;
    }

    await LevelUpUtil.showLevelUpDialog(level, prevLevel, context);
    _isShowingLevelUp = false;
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
    _isShowingLevelUp = false;
    // Reset any other state if necessary
  }
}
