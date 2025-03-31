import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/message_activity_request.dart';
import 'package:fluffychat/pangea/practice_activities/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_match.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordFocusListeningGenerator {
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
    BuildContext context,
  ) async {
    if (req.targetTokens.length == 1) {
      return _multipleChoiceActivity(req, context);
    } else {
      return _matchActivity(req, context);
    }
  }

  Future<MessageActivityResponse> _multipleChoiceActivity(
    MessageActivityRequest req,
    BuildContext context,
  ) async {
    final token = req.targetTokens.first;
    final List<String> choices = await lemmaActivityDistractors(token);

    return MessageActivityResponse(
      activity: PracticeActivityModel(
        activityType: ActivityTypeEnum.wordFocusListening,
        targetTokens: [token],
        langCode: req.userL2,
        multipleChoiceContent: MultipleChoiceActivity(
          question: L10n.of(context).wordFocusListeningMultipleChoice,
          choices: choices,
          answers: [token.lemma.text],
          spanDisplayDetails: null,
        ),
      ),
    );
  }

  Future<MessageActivityResponse> _matchActivity(
    MessageActivityRequest req,
    BuildContext context,
  ) async {
    return MessageActivityResponse(
      activity: PracticeActivityModel(
        activityType: ActivityTypeEnum.wordFocusListening,
        targetTokens: req.targetTokens,
        langCode: req.userL2,
        matchContent: PracticeMatch(
          matchInfo: Map.fromEntries(
            req.targetTokens.map(
              (token) => MapEntry(token.vocabConstructID, [token.text.content]),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<String>> lemmaActivityDistractors(PangeaToken token) async {
    final List<String> lemmas = MatrixState
        .pangeaController.getAnalytics.constructListModel
        .constructList(type: ConstructTypeEnum.vocab)
        .map((c) => c.lemma)
        .toSet()
        .toList();

    // Offload computation to an isolate
    final Map<String, int> distances =
        await compute(_computeDistancesInIsolate, {
      'lemmas': lemmas,
      'target': token.lemma.text,
    });

    // Sort lemmas by distance
    final sortedLemmas = distances.keys.toList()
      ..sort((a, b) => distances[a]!.compareTo(distances[b]!));

    // Take the shortest 4
    final choices = sortedLemmas.take(4).toList();
    if (choices.isEmpty) {
      return [token.lemma.text];
    }

    if (!choices.contains(token.lemma.text)) {
      choices.add(token.lemma.text);
      choices.shuffle();
    }
    return choices;
  }

  // isolate helper function
  Map<String, int> _computeDistancesInIsolate(Map<String, dynamic> params) {
    final List<String> lemmas = params['lemmas'];
    final String target = params['target'];

    // Calculate Levenshtein distances
    final Map<String, int> distances = {};
    for (final lemma in lemmas) {
      distances[lemma] = levenshteinDistanceSync(target, lemma);
    }
    return distances;
  }

  int levenshteinDistanceSync(String s, String t) {
    final int m = s.length;
    final int n = t.length;
    final List<List<int>> dp = List.generate(
      m + 1,
      (_) => List.generate(n + 1, (_) => 0),
    );

    for (int i = 0; i <= m; i++) {
      for (int j = 0; j <= n; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s[i - 1] == t[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return dp[m][n];
  }
}
