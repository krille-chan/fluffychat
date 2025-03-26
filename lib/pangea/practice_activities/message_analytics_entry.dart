import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/message_analytics_controller.dart';
import 'package:fluffychat/pangea/practice_activities/target_tokens_and_activity_type.dart';

class MessageAnalyticsEntry {
  final DateTime createdAt = DateTime.now();

  late final List<PangeaToken> _tokens;

  final Map<ActivityTypeEnum, List<TargetTokensAndActivityType>>
      _activityQueue = {};

  final int _maxQueueLength = 5;

  MessageAnalyticsEntry({
    required List<PangeaToken> tokens,
  }) {
    _tokens = tokens;
    initialize();
  }

  List<PangeaToken> get tokens => _tokens;

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt.toIso8601String(),
        'tokens': _tokens.map((t) => t.toJson()).toList(),
        'activityQueue': _activityQueue.map(
          (key, value) => MapEntry(
            key.toString(),
            value.map((e) => e.toJson()).toList(),
          ),
        ),
      };

  static MessageAnalyticsEntry fromJson(Map<String, dynamic> json) {
    return MessageAnalyticsEntry(
      tokens:
          (json['tokens'] as List).map((t) => PangeaToken.fromJson(t)).toList(),
    ).._activityQueue.addAll(
        (json['activityQueue'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            ActivityTypeEnum.values.firstWhere((e) => e.toString() == key),
            (value as List)
                .map((e) => TargetTokensAndActivityType.fromJson(e))
                .toList(),
          ),
        ),
      );
  }

  void _pushQueue(TargetTokensAndActivityType entry) {
    if (_activityQueue.containsKey(entry.activityType)) {
      _activityQueue[entry.activityType]!.insert(0, entry);
    } else {
      _activityQueue[entry.activityType] = [entry];
    }

    // just in case we make a mistake and the queue gets too long
    if (_activityQueue[entry.activityType]!.length > _maxQueueLength) {
      debugger(when: kDebugMode);
      _activityQueue[entry.activityType]!.removeRange(
        _maxQueueLength,
        _activityQueue.length,
      );
    }
  }

  TargetTokensAndActivityType? nextActivity(ActivityTypeEnum a) =>
      _activityQueue[a]?.firstOrNull;

  bool get hasHiddenWordActivity =>
      activities(ActivityTypeEnum.hiddenWordListening).isNotEmpty;

  bool get hasMessageMeaningActivity =>
      activities(ActivityTypeEnum.messageMeaning).isNotEmpty;

  int get numActivities => _activityQueue.length;

  List<TargetTokensAndActivityType> activities(ActivityTypeEnum a) =>
      _activityQueue[a] ?? [];

  // /// If there are more than 4 tokens that can be heard, we don't want to do word focus listening
  // /// Otherwise, we don't have enough distractors
  // bool get canDoWordFocusListening =>
  //     _tokens.where((t) => t.canBeHeard).length > 4;

  /// On initialization, we pick which tokens to do activities on and what types of activities to do
  void initialize() {
    final eligibleTokens = _tokens.where((t) => t.lemma.saveVocab);

    // EMOJI
    // sort the tokens by the preference of them for an emoji activity
    // order from least to most recent
    // words that have never been used are counted as 1000 days
    // we preference content words over function words by multiplying the days since last use by 2
    // NOTE: for now, we put it at the end if it has no uses and basically just give them the answer
    // later on, we may introduce an emoji activity that is easier than the current matching one
    // i.e. we show them 3 good emojis and 1 bad one and ask them to pick the bad one
    _activityQueue[ActivityTypeEnum.emoji] = eligibleTokens
        .map(
          (t) => TargetTokensAndActivityType(
            tokens: [t],
            activityType: ActivityTypeEnum.emoji,
          ),
        )
        .sorted(
          (a, b) => b.tokens.first
              .activityPriorityScore(ActivityTypeEnum.emoji, null)
              .compareTo(
                a.tokens.first
                    .activityPriorityScore(ActivityTypeEnum.emoji, null),
              ),
        );
    debugPrint(
        'emoji activity priority score: ${_activityQueue[ActivityTypeEnum.emoji]!.map(
      (e) => e.tokens.first.activityPriorityScore(ActivityTypeEnum.emoji, null),
    )}');

    _activityQueue[ActivityTypeEnum.emoji] =
        _activityQueue[ActivityTypeEnum.emoji]!
            .take(_maxQueueLength)
            .shuffled()
            .toList();

    // WORD MEANING
    // make word meaning activities
    // same as emojis for now
    _activityQueue[ActivityTypeEnum.wordMeaning] = eligibleTokens
        .map(
          (t) => TargetTokensAndActivityType(
            tokens: [t],
            activityType: ActivityTypeEnum.wordMeaning,
          ),
        )
        .sorted(
          (a, b) => b.tokens.first
              .activityPriorityScore(ActivityTypeEnum.wordMeaning, null)
              .compareTo(
                a.tokens.first
                    .activityPriorityScore(ActivityTypeEnum.wordMeaning, null),
              ),
        )
        .take(_maxQueueLength)
        .shuffled()
        .toList();

    // WORD FOCUS LISTENING
    // make word focus listening activities
    // same as emojis for now
    _activityQueue[ActivityTypeEnum.wordFocusListening] = eligibleTokens
        .map(
          (t) => TargetTokensAndActivityType(
            tokens: [t],
            activityType: ActivityTypeEnum.wordFocusListening,
          ),
        )
        .sorted(
          (a, b) => b.tokens.first
              .activityPriorityScore(ActivityTypeEnum.wordFocusListening, null)
              .compareTo(
                a.tokens.first.activityPriorityScore(
                  ActivityTypeEnum.wordFocusListening,
                  null,
                ),
              ),
        )
        .take(_maxQueueLength)
        .shuffled()
        .toList();

    // GRAMMAR
    // build a list of TargetTokensAndActivityType for all tokens and all features in the message
    // limits to _maxQueueLength activities and only one per token
    final List<TargetTokensAndActivityType> candidates = eligibleTokens.expand(
      (t) {
        return t.morphsBasicallyEligibleForPracticeByPriority.map(
          (m) => TargetTokensAndActivityType(
            tokens: [t],
            activityType: ActivityTypeEnum.morphId,
            morphFeature: MorphFeaturesEnumExtension.fromString(m.category),
          ),
        );
      },
    ).sorted(
      (a, b) => b.tokens.first
          .activityPriorityScore(
            ActivityTypeEnum.morphId,
            b.morphFeature!.name,
          )
          .compareTo(
            a.tokens.first.activityPriorityScore(
              ActivityTypeEnum.morphId,
              a.morphFeature!.name,
            ),
          ),
    );
    //pick from the top 5, only including one per token
    _activityQueue[ActivityTypeEnum.morphId] = [];
    for (final candidate in candidates) {
      if (_activityQueue[ActivityTypeEnum.morphId]!.length >= _maxQueueLength) {
        break;
      }
      if (_activityQueue[ActivityTypeEnum.morphId]?.any(
            (entry) => entry.tokens.contains(candidate.tokens.first),
          ) ==
          false) {
        _activityQueue[ActivityTypeEnum.morphId]?.add(candidate);
      }
    }

    MessageAnalyticsController.save(this);
  }

  bool hasActivity(
    ActivityTypeEnum a,
    PangeaToken t, [
    MorphFeaturesEnum? morph,
  ]) =>
      _activityQueue[a]?.any(
        (entry) =>
            entry.tokens.contains(t) &&
            (morph == null || entry.morphFeature == morph),
      ) ==
      true;

  /// Add a message meaning activity to the front of the queue
  /// And limits to _maxQueueLength activities
  void addMessageMeaningActivity() {
    final entry = TargetTokensAndActivityType(
      tokens: _tokens,
      activityType: ActivityTypeEnum.messageMeaning,
    );
    _pushQueue(entry);
  }

  void onActivityComplete(ActivityTypeEnum a, PangeaToken? token) {
    _activityQueue[a]
        ?.removeWhere((entry) => token == null || entry.tokens.contains(token));
    MessageAnalyticsController.save(this);
  }

  void exitPracticeFlow() {
    _activityQueue.clear();
    MessageAnalyticsController.save(this);
  }

  void revealAllTokens() {
    _activityQueue[ActivityTypeEnum.hiddenWordListening]?.clear();
    MessageAnalyticsController.save(this);
  }

  bool isTokenInHiddenWordActivity(PangeaToken token) =>
      _activityQueue[ActivityTypeEnum.hiddenWordListening]?.isNotEmpty ?? false;

  Future<List<LemmaInfoResponse>> getLemmaInfoForActivityTokens() async {
    // make a list of unique tokens in emoji and wordMeaning activities
    final List<PangeaToken> uniqueTokens = [];
    for (final t in _activityQueue[ActivityTypeEnum.emoji] ?? []) {
      if (!uniqueTokens.contains(t.tokens.first)) {
        uniqueTokens.add(t.tokens.first);
      }
    }
    for (final t in _activityQueue[ActivityTypeEnum.wordMeaning] ?? []) {
      if (!uniqueTokens.contains(t.tokens.first)) {
        uniqueTokens.add(t.tokens.first);
      }
    }

    // get the lemma info for each token
    final List<Future<LemmaInfoResponse>> lemmaInfoFutures = [];
    for (final t in uniqueTokens) {
      lemmaInfoFutures.add(t.vocabConstructID.getLemmaInfo());
    }

    return Future.wait(lemmaInfoFutures);
  }
}
