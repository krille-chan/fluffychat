import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class LevelUpManager {
  LevelUpManager._internal();
  factory LevelUpManager() {
    return _instance;
  }
  static final LevelUpManager _instance = LevelUpManager._internal();

  int? prevLevel;
  int? level;

  int? prevGrammar;
  int? nextGrammar;
  int? prevVocab;
  int? nextVocab;

  ConstructSummary? constructSummary;

  bool hasSeenPopup = false;
  bool shouldAutoPopup = false;
  String? error;

  Future<void> preloadAnalytics(
    BuildContext context,
    int level,
    int prevLevel,
  ) async {
    this.level = level;
    this.prevLevel = prevLevel;

    //grammar and vocab
    nextGrammar = MatrixState.pangeaController.getAnalytics.constructListModel
        .unlockedLemmas(
          ConstructTypeEnum.morph,
        )
        .length;

    nextVocab = MatrixState.pangeaController.getAnalytics.constructListModel
        .unlockedLemmas(
          ConstructTypeEnum.vocab,
        )
        .length;

    //for now idk how to get these
    prevGrammar = 0;
    prevVocab = 0;

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
    if (constructSummary != null) {
      print('Construct Summary: ${constructSummary!.toJson()}');
    } else {
      print('Construct Summary: Not available');
    }
  }

  void reset() {
    hasSeenPopup = false;
    shouldAutoPopup = false;
    prevLevel = null;
    level = null;
    prevGrammar = null;
    nextGrammar = null;
    prevVocab = null;
    nextVocab = null;
    constructSummary = null;
    error = null;
    // Reset any other state if necessary
  }
}
