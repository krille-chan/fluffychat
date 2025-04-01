import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart' as http;

import 'package:fluffychat/pangea/choreographer/constants/choreo_constants.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/controllers/error_service.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import '../repo/similarity_repo.dart';

class AlternativeTranslator {
  final Choreographer choreographer;
  bool showAlternativeTranslations = false;
  bool loadingAlternativeTranslations = false;
  bool showTranslationFeedback = false;
  String? userTranslation;
  FeedbackKey? translationFeedbackKey;
  List<String> translations = [];
  SimilartyResponseModel? similarityResponse;
  AlternativeTranslator(this.choreographer);

  void clear() {
    userTranslation = null;
    showAlternativeTranslations = false;
    loadingAlternativeTranslations = false;
    showTranslationFeedback = false;
    translationFeedbackKey = null;
    translations = [];
    similarityResponse = null;
  }

  double get _percentCorrectChoices {
    final totalSteps = choreographer.choreoRecord.itSteps.length;
    if (totalSteps == 0) return 0.0;
    final int correctFirstAttempts = choreographer.itController.completedITSteps
        .where(
          (step) => !step.continuances.any(
            (c) =>
                c.level != ChoreoConstants.levelThresholdForGreen &&
                c.wasClicked,
          ),
        )
        .length;
    final double percentage = (correctFirstAttempts / totalSteps) * 100;
    return percentage;
  }

  int get starRating {
    final double percent = _percentCorrectChoices;
    if (percent == 100) return 5;
    if (percent >= 80) return 4;
    if (percent >= 60) return 3;
    if (percent >= 40) return 2;
    if (percent > 0) return 1;
    return 0;
  }

  Future<void> setTranslationFeedback() async {
    try {
      choreographer.startLoading();
      translationFeedbackKey = FeedbackKey.loadingPleaseWait;
      showTranslationFeedback = true;
      userTranslation = choreographer.currentText;

      final double percentCorrect = _percentCorrectChoices;

      // Set feedback based on percentage
      if (percentCorrect == 100) {
        translationFeedbackKey = FeedbackKey.allCorrect;
      } else if (percentCorrect >= 80) {
        translationFeedbackKey = FeedbackKey.newWayAllGood;
      } else {
        translationFeedbackKey = FeedbackKey.othersAreBetter;
      }
    } catch (err, stack) {
      if (err is! http.Response) {
        ErrorHandler.logError(
          e: err,
          s: stack,
          data: {
            "sourceText": choreographer.itController.sourceText,
            "currentText": choreographer.currentText,
            "userL1": choreographer.l1LangCode,
            "userL2": choreographer.l2LangCode,
            "goldRouteTranslation":
                choreographer.itController.goldRouteTracker.fullTranslation,
          },
        );
      }
      choreographer.errorService.setError(
        ChoreoError(type: ChoreoErrorType.unknown, raw: err),
      );
    } finally {
      choreographer.stopLoading();
    }
  }

  List<PangeaToken> get _selectedTokens => choreographer.choreoRecord.itSteps
      .where((step) => step.chosenContinuance != null)
      .map(
        (step) => step.chosenContinuance!.tokens.where(
          (token) => token.lemma.saveVocab,
        ),
      )
      .expand((element) => element)
      .toList();

  int countVocabularyWordsFromSteps() =>
      _selectedTokens.map((t) => t.lemma.text.toLowerCase()).toSet().length;

  int countGrammarConstructsFromSteps() => _selectedTokens
      .map(
        (t) => t.morph.entries.map(
          (m) => "${m.key}:${m.value}".toLowerCase(),
        ),
      )
      .expand((m) => m)
      .toSet()
      .length;

  String getDefaultFeedback(BuildContext context) {
    final l10n = L10n.of(context);
    switch (translationFeedbackKey) {
      case FeedbackKey.allCorrect:
        return l10n.perfectTranslation;
      case FeedbackKey.newWayAllGood:
        return l10n.greatJobTranslation;
      case FeedbackKey.othersAreBetter:
        if (_percentCorrectChoices >= 60) {
          return l10n.goodJobTranslation;
        }
        if (_percentCorrectChoices >= 40) {
          return l10n.makingProgress;
        }
        return l10n.keepPracticing;
      case FeedbackKey.loadingPleaseWait:
        return l10n.letMeThink;
      case FeedbackKey.allDone:
        return l10n.allDone;
      default:
        return l10n.loadingPleaseWait;
    }
  }
}

enum FeedbackKey {
  allCorrect,
  newWayAllGood,
  othersAreBetter,
  loadingPleaseWait,
  allDone,
}

extension FeedbackKeyExtension on FeedbackKey {}
