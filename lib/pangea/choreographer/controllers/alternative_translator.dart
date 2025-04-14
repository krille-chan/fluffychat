import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart' as http;

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/choreographer/constants/choreo_constants.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/controllers/error_service.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/widgets/matrix.dart';
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

  List<OneConstructUse> get _itStepConstructs {
    final metadata = ConstructUseMetaData(
      roomId: choreographer.roomId,
      timeStamp: DateTime.now(),
    );

    final List<OneConstructUse> constructs = [];
    for (final step in choreographer.choreoRecord.itSteps) {
      for (final continuance in step.continuances) {
        final ConstructUseTypeEnum useType = continuance.wasClicked &&
                continuance.level == ChoreoConstants.levelThresholdForGreen
            ? ConstructUseTypeEnum.corIt
            : continuance.wasClicked
                ? ConstructUseTypeEnum.incIt
                : ConstructUseTypeEnum.ignIt;

        final tokens = continuance.tokens.where((t) => t.lemma.saveVocab);
        constructs.addAll(
          tokens.map(
            (token) => OneConstructUse(
              useType: useType,
              lemma: token.lemma.text,
              constructType: ConstructTypeEnum.vocab,
              metadata: metadata,
              category: token.pos,
              form: token.text.content,
            ),
          ),
        );
        for (final token in tokens) {
          constructs.add(
            OneConstructUse(
              useType: useType,
              lemma: token.pos,
              form: token.text.content,
              category: "POS",
              constructType: ConstructTypeEnum.morph,
              metadata: metadata,
            ),
          );
          for (final entry in token.morph.entries) {
            constructs.add(
              OneConstructUse(
                useType: useType,
                lemma: entry.value,
                form: token.text.content,
                category: entry.key,
                constructType: ConstructTypeEnum.morph,
                metadata: metadata,
              ),
            );
          }
        }
      }
    }
    return constructs;
  }

  int countNewConstructs(ConstructTypeEnum type) {
    final vocabUses = _itStepConstructs.where((c) => c.constructType == type);
    final Map<ConstructIdentifier, int> constructPoints = {};
    for (final use in vocabUses) {
      constructPoints[use.identifier] ??= 0;
      constructPoints[use.identifier] =
          constructPoints[use.identifier]! + use.pointValue;
    }

    final constructListModel =
        MatrixState.pangeaController.getAnalytics.constructListModel;

    int newConstructCount = 0;
    for (final entry in constructPoints.entries) {
      final construct = constructListModel.getConstructUses(entry.key);
      if (construct?.points == entry.value) {
        newConstructCount++;
      }
    }

    return newConstructCount;
  }

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
